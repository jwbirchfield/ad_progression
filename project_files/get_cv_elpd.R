### get_cv_elpd
# requires: cv_fit results
# usage: get_mmse_elpd(model_1)
# file writes value to an RDS, so no need to assign

get_cv_elpd <- function(model_name) {
  
  model_name <- enexpr(model_name) %>% as_string()
  y_vars <- get_y_vars(!!enexpr(model_name))
  K <- length(y_vars)
  transformed <- any(str_detect(y_vars, 'transformed'))
  d <- read_csv('../project_files/data.csv')
  d_cv <- list(
    d %>% filter(fold == 1),
    d %>% filter(fold == 2),
    d %>% filter(fold == 3),
    d %>% filter(fold == 4),
    d %>% filter(fold == 5))
  N_fold <- c(
    nrow(d_cv[[1]]),
    nrow(d_cv[[2]]),
    nrow(d_cv[[3]]),
    nrow(d_cv[[4]]),
    nrow(d_cv[[5]]))
  cv_fit <- list(
    readRDS(glue('cv_fit/{model_name}_fold_1.rds')),
    readRDS(glue('cv_fit/{model_name}_fold_2.rds')),
    readRDS(glue('cv_fit/{model_name}_fold_3.rds')),
    readRDS(glue('cv_fit/{model_name}_fold_4.rds')),
    readRDS(glue('cv_fit/{model_name}_fold_5.rds')))
  
  # container object
  elpd <- numeric(5)
  
  # transformation function
  J <- if (transformed) {
      function(z) .236 * (1 - pnorm(z)) / dnorm(z)
    } else {
      function(z) 1
    }

  for(k in 1:5){
    
    # aliases for easier reference
    d_cv_k <- d_cv[[k]]
    N <- N_fold[k]
    fit <- cv_fit[[k]]
    
    # alpha: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups: CN, MCI, AD
    # third dimension: 2K parameters: y1 age_c, y1 male, y2 age_c, y2 male, (y3 age_c, y3 male)
    alpha <- rstan::extract(fit, pars = 'alpha')[[1]]
    
    # beta: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: subjects
    # third dimension: 2K parameters: y1 intercept, y1 slope, y2 intercept, y2 slope, (y3 intercept, y3 slope)
    # beta[,i,] is the vector of sample of the i^th beta vector
    beta <- rstan::extract(fit, pars = 'beta_test')[[1]]
    
    # mu_y: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: observations
    # third dimension: K outcomes: y1, y2, y3
    # mu_y[,n,] is the vector of samples of the n^th mu_y vector
    mu_y <- rstan::extract(fit, pars = 'mu_y_test')[[1]]
    
    # Sigma_epsilon: 4-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups
    # third dimension: K matrix rows
    # fourth dimension: K matrix columns
    Sigma_epsilon <- rstan::extract(fit, pars = 'Sigma_epsilon')[[1]]
    
    # Sigma_beta: 4 dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups
    # third dimension: K matrix rows
    # fourth dimension: K matrix columns
    Sigma_beta <- rstan::extract(fit, pars = 'Sigma_beta')[[1]]
    
    y <- d_cv_k %>% 
      select(any_of(y_vars)) %>% 
      as.matrix(ncol = K)
    # structured as y[n, k] = y[observation, outcome]
    
    group <- d_cv_k$group
    
    mu_conditional <- matrix(NA, nrow = 4000, ncol = nrow(y))
    V_conditional <- matrix(NA, nrow = 4000, ncol = nrow(y))
    # rows are MCMC samples, columns are observations
    
    # Find conditional mean and variance of y1 given y2 (and y3 if it is present)
    if (K == 2) {
      for (n in 1:N) { 
        for (s in 1:4000) { 
          mu_conditional[s, n] <- 
            mu_y[s, n, 1] + 
            Sigma_epsilon[s, group[n], 1, 2] * 
            (Sigma_epsilon[s, group[n], 2, 2])^(-1) * 
            (y[n, 2] - mu_y[s, n, 2])
          # note, these are variances not sd's
          V_conditional[s, n] <- 
            Sigma_epsilon[s, group[n], 1, 1] - 
            Sigma_epsilon[s, group[n], 1, 2] * 
            Sigma_epsilon[s, group[n], 2, 2]^(-1) * 
            Sigma_epsilon[s, group[n], 2, 1]
        }
        if (n %% 50 == 0 | n == N) {
          cat('\n')
          cat(glue('Completed: fold {k}, (mu, V)[{n}]'))
        }
      }
    }

    if (K == 3) {
      for (n in 1:N) {
        for (s in 1:4000) {
          mu_conditional[s, n] <- 
            mu_y[s, n, 1] + 
            Sigma_epsilon[s, group[n], 2:3, 1] %*%
            pinv(Sigma_epsilon[s, group[n], 2:3, 2:3]) %*%
            (y[n, 2:3] - mu_y[s, n, 2:3])
          V_conditional[s, n] <- 
            Sigma_epsilon[s, group[n], 1, 1] - 
            matrix(Sigma_epsilon[s, group[n], 2:3, 1], nrow = 1) %*%
            pinv(Sigma_epsilon[s, group[n], 2:3, 2:3]) %*%
            matrix(Sigma_epsilon[s, group[n], 2:3, 1], ncol = 1)
        }
        if (n %% 50 == 0 | n == N) {
          cat('\n')
          cat(glue('Completed: fold {k}, (mu, V)[{n}]'))
        }
      }
    }
    
    fold_elpd <- numeric(N)
    for (n in 1:N) {
      fold_elpd[n] <- (dnorm(
          x = y[n, 1], 
          mean = mu_conditional[, n], 
          sd = sqrt(V_conditional[, n])) * J(y[n, 1])) %>% 
        mean() %>% log()
    }
    elpd[k] <- sum(fold_elpd)
    
  } # end of for (k = 1:5)
  
  elpd <- sum(elpd)
  saveRDS(elpd, 'cv_fit/cv_elpd.RDS')
  return(elpd)
  
} # end of function



