### get_lov_elpd

get_lov_elpd <- function(model_name) {
  
  model_name <- enexpr(model_name) %>% as_string()
  y_vars <- get_y_vars(!!enexpr(model_name))
  K <- length(y_vars)
  transformed <- any(str_detect(y_vars, 'transformed'))
  d_lov <- read_csv('../project_files/data.csv') %>% 
    filter(validation) %>%
    mutate(v_id = 1:nrow(.), .after = id)
  fit <- readRDS(glue('lov_fit/{model_name}_lov.RDS'))
  
  # strategy: find (log)likelihood of test MMSEs, given mu_y = a'x + b'z, sigma_epsilon
  
  # iteration, group, index
  alpha_0 <- fit %>% rstan::extract(pars='alpha') %>% `[[`(1)
  # iteration, subject, index
  beta_0 <- fit %>% rstan::extract(pars='beta') %>% `[[`(1)
  # iteration, group, index
  sigma_epsilon_0 <- fit %>% rstan::extract(pars='sigma_epsilon') %>% `[[`(1)
  # number of observations = number of subjects
  N <- nrow(d_lov)
  # group membership of each subject
  group <- d_lov$group
  # number of MCMC samples per parameter
  S <- dim(alpha_0)[1]
  
  y <- d_lov %>% pull(y_vars[1])
  X <- d_lov %>% select(age_c, male) %>% as.matrix(ncol = 2)
  Z <- d_lov %>% select(ones, years) %>% as.matrix(ncol = 2)
  
  alpha <- list()
  for (i in 1:N) {
    alpha[[i]] <- list()
    for (s in 1:S) alpha[[i]][[s]] <- alpha_0[s, group[i], 1:2]
  }
  
  beta <- list()
  for (i in 1:N) {
    beta[[i]] <- list()
    for (s in 1:S) beta[[i]][[s]] <- beta_0[s, i, 1:2] 
  }
  
  sigma_epsilon <- list()
  for (i in 1:N) {
    sigma_epsilon[[i]] <- list()
    for (s in 1:S) sigma_epsilon[[i]][[s]] <- sigma_epsilon_0[s, group[i], 1] 
  }
  
  mu <- list()
  for (i in 1:N) {
    mu[[i]] <- list()
    for (s in 1:S) mu[[i]][[s]] <- sum(X[i, ]*alpha[[i]][[s]]) + sum(Z[i, ]*beta[[i]][[s]])
  }
  
  L <- matrix(NA, nrow = S, ncol = N)
  for (i in 1:N) {
    for(s in 1:S) L[s, i] <- dnorm(y[i], mean = mu[[i]][[s]], sd = sigma_epsilon[[i]][[s]])
  }

  elpd <- if(transformed){
    L %>% colMeans() %>% log() %>% add(d_lov$transformation_constant) %>% sum()
  } else {
    L %>% colMeans() %>% log() %>% sum()
  }
  
  saveRDS(elpd, 'lov_fit/lov_elpd.RDS')
  
}


