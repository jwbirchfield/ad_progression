// GENERAL SCRIPT FOR K-FOLD CROSS-VALIDATION

data{
  
  int<lower=1> I; // number of subjects
  int<lower=1> N; // total number of observations, each n is ij
  array[N] int<lower=1> id; // id of nth observation
  array[I] int<lower=1> group; // diagnostic group of subject i (CN=1, MCI=2, AD=3)
  int<lower=1> K; // number of outcomes
  array[N] vector[K] y; // vector of outcomes (e.g. FSLong, ANTsSST, MMSE_loss) for n = 1:N
  array[N] row_vector[4] X; // 1, t, age_c, male
  
  int<lower=1> I_test; // number of subjects in test set
  int<lower=1> N_test; // total number of observations in test set
  array[N_test] int<lower=1> id_test; // id of nth observation in test set
  array[I_test] int<lower=1> group_test; // diagnostic group of subject i in test set (CN=1, MCI=2, AD=3)
  array[N_test] vector[K] y_test; // vector of outcomes (e.g. FSLong, ANTsSST, MMSE_loss) for n in test set
  array[N_test] row_vector[4] X_test; // 1, t, age_c, male for observations in test set
  
}

transformed data {}

parameters{

  array[3] vector[2*K] alpha;
  array[3] vector[2*K] mu_beta; 
  array[3] vector<lower=0>[2*K] sigma_beta; 
  array[3] vector<lower=0>[K] sigma_epsilon; 
  array[3] cholesky_factor_corr[2*K] L_Rho_beta; 
  array[3] cholesky_factor_corr[K] L_Rho_epsilon; 
  array[I] vector[2*K] z;
  
}

transformed parameters{
  
  array[N] vector[K] mu_y; 
  array[I] vector[2*K] beta; 
  array[3] cholesky_factor_cov[2*K] L_Sigma_beta;
  array[3] cholesky_factor_cov[K] L_Sigma_epsilon; 
  
  for(l in 1:3){
    // turn sd's and cholesky_corr into cholesky_cov
    L_Sigma_beta[l] = diag_pre_multiply(sigma_beta[l], L_Rho_beta[l]);    
    L_Sigma_epsilon[l] = diag_pre_multiply(sigma_epsilon[l], L_Rho_epsilon[l]);
  }
  
  for(i in 1:I){
    // equiv to beta[i] ~ multi_normal(mu_beta[group[i]], Sigma_beta[group[i]])
    beta[i] = mu_beta[group[i]] + L_Sigma_beta[group[i]] * z[i];
  }

  if(K == 2){
    for(n in 1:N){
      mu_y[n] = [ X[n] * append_row(beta[id[n]][1:2], alpha[group[id[n]]][1:2]),
                  X[n] * append_row(beta[id[n]][3:4], alpha[group[id[n]]][3:4])]';
    }
  }

  if(K == 3){
    for(n in 1:N){
      mu_y[n] = [ X[n] * append_row(beta[id[n]][1:2], alpha[group[id[n]]][1:2]),
                  X[n] * append_row(beta[id[n]][3:4], alpha[group[id[n]]][3:4]),
                  X[n] * append_row(beta[id[n]][5:6], alpha[group[id[n]]][5:6]) ]';
    }
  }
  
}

model{

  // likelihood
  for(n in 1:N){
    y[n] ~ multi_normal_cholesky(mu_y[n], L_Sigma_epsilon[group[id[n]]]);
  }
  
  // priors
  for(l in 1:3){
    
    alpha[l] ~ normal(0,2); 
    mu_beta[l][1] ~ normal(7,3); // y1 intercept mean
    mu_beta[l][2] ~ normal(0,1); // y1 slope mean
    sigma_beta[l][1] ~ exponential(1); // y1 intercept sd
    sigma_beta[l][2] ~ exponential(5); // y1 slope sd
    
    if(K == 2){
      mu_beta[l][3] ~ normal(0,2); // MMSE intercept mean
      mu_beta[l][4] ~ normal(0,2); // MMSE slope mean
      sigma_beta[l][3] ~ exponential(1); // MMSE intercept sd
      sigma_beta[l][4] ~ exponential(1); // MMSE slope sd
    }
    
    if(K == 3){
      mu_beta[l][3] ~ normal(7,3); // y2 intercept mean
      mu_beta[l][4] ~ normal(0,1); // y2 slope mean
      mu_beta[l][5] ~ normal(0,2); // MMSE intercept mean
      mu_beta[l][6] ~ normal(0,2); // MMSE slope mean
      sigma_beta[l][3] ~ exponential(1); // y2 intercept sd
      sigma_beta[l][4] ~ exponential(5); // y2 slope sd  
      sigma_beta[l][5] ~ exponential(1); // MMSE intercept sd
      sigma_beta[l][6] ~ exponential(1); // MMSE slope sd
    }
    
    L_Rho_beta[l] ~ lkj_corr_cholesky(1);
    sigma_epsilon[l] ~ exponential(1);
    L_Rho_epsilon[l] ~ lkj_corr_cholesky(1);
    
  }
  
  // random effects distribution
  for(i in 1:I){
    z[i] ~ std_normal();
  }
  
}

generated quantities {

  array[I_test] vector[2*K] beta_test;
  array[N_test] vector[K] mu_y_test;
  array[3] cov_matrix[2*K] Sigma_beta;
  array[3] cov_matrix[K] Sigma_epsilon;
  
  for(l in 1:3){
    Sigma_beta[l] = L_Sigma_beta[l] * L_Sigma_beta[l]';
    Sigma_epsilon[l] = L_Sigma_epsilon[l] * L_Sigma_epsilon[l]'; }
  for(i in 1:I_test){
    beta_test[i] = multi_normal_cholesky_rng(mu_beta[group_test[i]], L_Sigma_beta[group_test[i]]); }
  for(n in 1:N_test){
    if(K == 2){
      mu_y_test[n] = [
        X_test[n] * append_row(beta_test[id_test[n]][1:2], alpha[group_test[id_test[n]]][1:2]),
        X_test[n] * append_row(beta_test[id_test[n]][3:4], alpha[group_test[id_test[n]]][3:4])
      ]'; }
    if(K == 3){
        mu_y_test[n] = [
        X_test[n] * append_row(beta_test[id_test[n]][1:2], alpha[group_test[id_test[n]]][1:2]),
        X_test[n] * append_row(beta_test[id_test[n]][3:4], alpha[group_test[id_test[n]]][3:4]),
        X_test[n] * append_row(beta_test[id_test[n]][5:6], alpha[group_test[id_test[n]]][5:6])
      ]'; } }
  
}

