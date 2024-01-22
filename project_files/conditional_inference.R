p_load(rstan, cmdstanr)

d <- read_csv('../project_files/data.csv')
fit <- readRDS('../model_6/fit/model_6_fit.rds')

# mu_y: 3-dimensional array
# first dimension: 8000 MCMC samples
# second dimension: 2449 observations
# third dimension: 2 outcomes: transformed_MMSE_loss, ANTsSST
# mu_y[,n,] is the vector of samples of the n^th mu_y vector
mu_y <- rstan::extract(fit, pars = 'mu_y')[[1]]

# Sigma_epsilon: 4-dimensional array
# first dimension: 8000 MCMC samples
# second dimension: 3 groups
# third dimension: 2 matrix rows
# fourth dimension: 2 matrix columns
V_y <- rstan::extract(fit, pars = 'Sigma_epsilon')[[1]]

y <- d %>% select(transformed_MMSE_loss, ANTsSST) %>% as.matrix(ncol = 2) %>% unname()
group <- d$group

# get all conditional distributions
N <- 2449
S <- 8000
mu_conditional <- matrix(NA, nrow = S, ncol = N)
V_conditional <- matrix(NA, nrow = S, ncol = N)
for (n in 1:N) { for (s in 1:S) { 
    mu_conditional[s, n] <- 
      mu_y[s, n, 1] + 
      V_y[s, group[n], 1, 2] * 
      (V_y[s, group[n], 2, 2])^(-1) * 
      (y[n, 2] - mu_y[s, n, 2])
    # note, these are variances not sd's
    V_conditional[s, n] <- 
      V_y[s, group[n], 1, 1] - 
      V_y[s, group[n], 1, 2] * 
      V_y[s, group[n], 2, 2]^(-1) * 
      V_y[s, group[n], 2, 1]
} }

n <- 1
w <- seq(from = 2, to = 10, by = 1)
mu_conditional_test <- matrix(NA, nrow = S, ncol = length(w))
V_conditional_test <- matrix(NA, nrow = S, ncol = length(w))
for (s in 1:S) { for(i in seq_along(w)) {
  mu_conditional_test[s, i] <- 
    mu_y[s, n, 1] + 
    V_y[s, group[n], 1, 2] * 
    (V_y[s, group[n], 2, 2])^(-1) * 
    (w[i] - mu_y[s, n, 2])
  # note, these are variances not sd's
  V_conditional_test[s, i] <- 
    V_y[s, group[n], 1, 1] - 
    V_y[s, group[n], 1, 2] * 
    V_y[s, group[n], 2, 2]^(-1) * 
    V_y[s, group[n], 2, 1]
} }

ggplot(data = )
plot(density(mu_conditional_test[,1]))
plot(density(mu_conditional_test[,2]))
plot(density(mu_conditional_test[,3]))
plot(density(mu_conditional_test[,4]))
plot(density(mu_conditional_test[,5]))
plot(density(mu_conditional_test[,6]))
plot(density(mu_conditional_test[,7]))
plot(density(mu_conditional_test[,8]))
plot(density(mu_conditional_test[,9]))

# get samples of conditional mean and variance of y2 given y1 (which depends on X, alpha, Z, beta)

# Future time point, known individual, given y1 or y2


# Specify: age, gender, diagnosis, time in study, and y2
# draw alpha, beta
# draw mu_y, V_y
# draw mu_y_conditional, V_y conditional

########
# subject 1
# baseline covariates remain the same
# choose a future timepoint
# draw from posterior alpha (for group) and subject-specific beta
# compute mu_y
# V_y (residual covariance) is estimated for the whole group
# find conditional mean and variance
# repeat S times


