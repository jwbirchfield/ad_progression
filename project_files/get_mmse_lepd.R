
get_mmse_lepd_2 <- function(model_name, y1, y2, transformed_MMSE = FALSE){
  
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
  lepd <- numeric(5)
  
  # transformation function
  if(transformed_MMSE){
    J <- function(z){ .236 * (1 - pnorm(z)) / dnorm(z) }
  } else {
    J <- function(z){ 1 }
  }
  
  for(k in 1:5){
    
    # aliases for easier reference
    d_cv_k <- d_cv[[k]]
    N <- N_fold[k]
    fit <- cv_fit[[k]]
    
    # alpha: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups: CN, MCI, AD
    # third dimension: 4 parameters
    alpha <- rstan::extract(fit, pars = 'alpha')[[1]]
    dimnames(alpha)[[2]] <- c('CN', 'MCI', 'AD')
    dimnames(alpha)[[3]] <- c('y1 age_c', 'y1 male', 
                              'MMSE_loss age_c', 'MMSE_loss male')
    
    # beta: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: subjects
    # third dimension: 4 parameters
    # beta[,i,] is the vector of sample of the i^th beta vector
    beta <- rstan::extract(fit, pars='beta_test')[[1]]
    dimnames(beta)[[3]] <- c('y1 intercept', 'y1 slope', 
                             'MMSE_loss intercept', 'MMSE_loss slope')
    
    # mu_y: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: observations
    # third dimension: 2 outcomes
    # mu_y[,n,] is the vector of samples of the n^th mu_y vector
    mu_y <- rstan::extract(fit, pars='mu_y_test')[[1]]
    dimnames(mu_y)[[3]] <- c('y1', 'MMSE_loss')
    
    # Sigma_epsilon: 4-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups
    # third dimension: 2 matrix rows
    # fourth dimension: 2 matrix columns
    Sigma_epsilon <- rstan::extract(fit, pars='Sigma_epsilon')[[1]]
    dimnames(Sigma_epsilon)[[2]] <- c('CN', 'MCI', 'AD')
    
    # Sigma_beta: 4 dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups
    # third dimension: 4 matrix rows
    # fourth dimension: 4 matrix columns
    Sigma_beta <- rstan::extract(fit, pars='Sigma_beta')[[1]]
    dimnames(Sigma_beta)[[2]] <- c('CN', 'MCI', 'AD')
    
    y <- d_cv_k %>% 
      select({{y1}}, {{y2}}) %>% 
      as.matrix(ncol = 2)
    # structured as y[n, k] = y[observation, outcome]
    group <- d_cv_k$group
    
    mu_y2_conditional <- matrix(NA, nrow=4000, ncol=nrow(y))
    # rows are MCMC samples, columns are observations
    for(n in 1:N){ for(s in 1:4000){ 
      mu_y2_conditional[s,n] <- 
        mu_y[s,n,2] + 
        Sigma_epsilon[s,group[n],2,1] * 
        (Sigma_epsilon[s,group[n],1,1])^(-1) * 
        (y[n,1] - mu_y[s,n,1])
      cat('\n', k, 'mu '); cat(round((4000*(n-1)+s)/(.01*4000*N),1)); cat('%')
    }}
    
    v_y2_conditional <- matrix(NA, nrow=4000, ncol=nrow(y))
    # note, these are variances not sd's
    for(n in 1:N){ for(s in 1:4000){ 
      v_y2_conditional[s,n] <- 
        Sigma_epsilon[s, group[n],2,2] - 
        Sigma_epsilon[s,group[n],2,1] * 
        (Sigma_epsilon[s,group[n],1,1])^(-1) * 
        Sigma_epsilon[s,group[n],1,2]
      cat('\n', k, 'v '); cat(round((4000*(n-1)+s)/(.01*4000*N),1)); cat('%')
    }}
    
    # calculate CV lepd
    fold_lepd <- numeric(N)
    for(n in 1:N){
      fold_lepd[n] <- ( dnorm(
        y[n,2], 
        mean = mu_y2_conditional[,n], 
        sd = sqrt(v_y2_conditional[,n])
      ) * J(y[n,2]) ) %>% 
        mean() %>% log()
    }
    lepd[k] <- sum(fold_lepd)
    
  } # end of for(k=1:5)
  
  lepd_total <- sum(lepd)
  return(lepd_total)
  
} # end of function

#####

get_mmse_lepd_3 <- function(model_name, y1, y2, y3, transformed_MMSE = FALSE){
  
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
  lepd <- numeric(5)
  
  # transformation function
  if(transformed_MMSE){
    Ja <- function(z){ .236 * (1 - pnorm(z)) / dnorm(z) }
  } else {
    Ja <- function(z){ 1 }
  }
  
  for(k in 1:5){
    
    # aliases for easier reference
    d_cv_k <- d_cv[[k]]
    N <- N_fold[k]
    fit <- cv_fit[[k]]
    
    # alpha: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups: CN, MCI, AD
    # third dimension: 6 parameters
    alpha <- rstan::extract(fit, pars = 'alpha')[[1]]
    dimnames(alpha)[[2]] <- c('CN', 'MCI', 'AD')
    dimnames(alpha)[[3]] <- c('y1 age_c', 'y1 male', 
                              'y2 age_c', 'y2 male', 
                              'MMSE_loss age_c', 'MMSE_loss male')
    
    # beta: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: subjects
    # third dimension: 6 parameters
    # beta[,i,] is the vector of sample of the i^th beta vector
    beta <- rstan::extract(fit, pars='beta_test')[[1]]
    dimnames(beta)[[3]] <- c('y1 intercept', 'y1 slope', 
                             'y2 intercept', 'y2 slope',
                             'MMSE_loss intercept', 'MMSE_loss slope')
    
    # mu_y: 3-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: observations
    # third dimension: 3 outcomes
    # mu_y[,n,] is the vector of samples of the n^th mu_y vector
    mu_y <- rstan::extract(fit, pars='mu_y_test')[[1]]
    dimnames(mu_y)[[3]] <- c('y1', 'y2', 'MMSE_loss')
    
    # Sigma_epsilon: 4-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups
    # third dimension: 3 matrix rows
    # fourth dimension: 3 matrix columns
    Sigma_epsilon <- rstan::extract(fit, pars='Sigma_epsilon')[[1]]
    dimnames(Sigma_epsilon)[[2]] <- c('CN', 'MCI', 'AD')
    
    # Sigma_beta: 4-dimensional array
    # first dimension: 4000 MCMC samples
    # second dimension: 3 groups
    # third dimension: 6 matrix rows
    # fourth dimension: 6 matrix columns
    Sigma_beta <- rstan::extract(fit, pars='Sigma_beta')[[1]]
    dimnames(Sigma_beta)[[2]] <- c('CN', 'MCI', 'AD')
    
    y <- d_cv_k %>% 
      select({{y1}}, {{y2}}, {{y3}}) %>% 
      as.matrix(ncol = 3)
    # structured as y[n,k] = y[observation, outcome]
    group <- d_cv_k$group
    
    mu_y3_conditional <- matrix(NA, nrow=4000, ncol=nrow(y))
    # rows are MCMC samples, columns are observations
    for(n in 1:nrow(y)){ for(s in 1:4000){ 
      mu_y3_conditional[s,n] <- 
        mu_y[s,n,3] + 
        Sigma_epsilon[s,group[n],3,1:2] %*% 
        pinv(Sigma_epsilon[s,group[n],1:2,1:2]) %*% 
        (y[n,1:2] - mu_y[s,n,1:2])
      cat('\n', k, 'mu '); cat(round((4000*(n-1)+s)/(.01*4000*N),1)); cat('%')
    }}
    
    v_y3_conditional <- matrix(NA, nrow=4000, ncol=nrow(y))
    # note, these are variances not sd's
    for(n in 1:nrow(y)){ for(s in 1:4000){ 
      v_y3_conditional[s,n] <- 
        Sigma_epsilon[s, group[n],3,3] - 
        matrix(Sigma_epsilon[s,group[n],3,1:2],nrow=1) %*% 
        pinv(Sigma_epsilon[s,group[n],1:2,1:2]) %*% 
        matrix((Sigma_epsilon[s,group[n],3,1:2]),ncol=1)
      cat('\n', k, 'v '); cat(round((4000*(n-1)+s)/(.01*4000*N),1)); cat('%')
    }}
    
    # calculate CV lepd
    fold_lepd = numeric(N)
    for(n in 1:N){
      fold_lepd[n] <-
        ( dnorm(
          y[n,3], mean=mu_y3_conditional[,n], 
          sd = sqrt(v_y3_conditional[,n])
        ) * J(y[n,3]) ) %>% 
        mean() %>% 
        log()
    }
    lepd[k] = sum(fold_lepd)
    
  } # end of for(k in 1:5)
  
  lepd_total <- sum(lepd)
  return(lepd_total)
  
} # end of function
