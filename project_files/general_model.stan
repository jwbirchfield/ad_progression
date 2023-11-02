// GENERAL SCRIPT FOR 8 MODELS

data{
  
  int<lower=1> I; // number of subjects
  int<lower=1> N; // total number of observations, each n is ij
  array[N] int<lower=1> id; // id of nth observation
  array[I] int<lower=1> group; // diagnostic group of subject i (CN=1, MCI=2, AD=3)
  int<lower=1> K; // number of outcomes
  array[N] vector[K] y; // vector of outcomes (e.g. FSLong, ANTsSST, MMSE_loss) for n = 1:N
  array[N] row_vector[4] X; // 1, t, age_c, male
  
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
    L_Sigma_epsilon[l] = diag_pre_multiply(sigma_epsilon[l], L_Rho_epsilon[l]);
    L_Sigma_beta[l] = diag_pre_multiply(sigma_beta[l], L_Rho_beta[l]);    
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

// Likelihood

  for(n in 1:N){
    y[n] ~ multi_normal_cholesky(mu_y[n], L_Sigma_epsilon[group[id[n]]]);
  }

  // Priors
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

  vector[N] log_lik;
  array[3] matrix[2*K,2*K] Rho_beta;
  array[3] matrix[K,K] Rho_epsilon;

  for(n in 1:N){
    log_lik[n] = multi_normal_cholesky_lpdf(y[n] | mu_y[n], L_Sigma_epsilon[group[id[n]]]);
  }

  for(l in 1:3){
    Rho_beta[l] = L_Rho_beta[l] * L_Rho_beta[l]';
    Rho_epsilon[l] = L_Rho_epsilon[l] * L_Rho_epsilon[l]';  
  }

}
