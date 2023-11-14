### get_model_fit()
#' requires: project_packages.R, data.csv, general_model.stan

get_model_fit <- function(model_name, 
  y1, 
  y2, 
  y3 = NULL, 
  data = "data.csv", 
  n_chains = 4, 
  warmup = 1000, 
  sampling = 6000, 
  thin = 3){
  
  d <- read_csv('../project_files/data.csv')
  X <- d %>% select(ones, years, age_c, male)
  y <- d %>% select({{y1}}, {{y2}}, {{y3}})
  group <- d %>% group_by(id) %>% summarize(group = mean(group)) %>% pull(group)
  
  stan_data <- list(
    I = max(d$id),
    N = nrow(d),
    K = ncol(y),
    id = d$id,
    group = group,
    y = y,
    X = X)
  
  model <- cmdstan_model('../project_files/general_model.stan')
  rstan_options(auto_write=TRUE)
  options(mc.cores = parallel::detectCores())
  
  # run model, recording start and end time
  start_time <- lubridate::now()
  fit <- model$sample(
    data = stan_data,
    seed = 122984,
    chains = n_chains, 
    iter_warmup = warmup,
    iter_sampling = sampling,
    refresh = 1, 
    thin = thin,
    max_treedepth = 20,
    adapt_delta = .95)
  end_time <- lubridate::now()
  
  # create /fit directory
  # save .csv chains to /fit directory
  # create .RDS from all chains
  if( !dir.exists("fit") ){dir.create("fit")}
  fit$save_output_files(
    dir = 'fit/',
    basename=model_name,
    timestamp=T,
    random=F)
  setwd('fit')
  chains <- list.files() %>% 
    str_subset('.csv') %>% 
    str_subset('summary', negate=TRUE)
  model_fit <- read_stan_csv(chains) %>%
    structure(
      model_name = model_name,
      yvars = colnames(y),
      n_chains = n_chains,
      warmup = warmup,
      sampling = sampling,
      thin = thin,
      start_time = start_time, 
      end_time = end_time)
  saveRDS(model_fit, glue('{model_name}_fit.rds'))
  setwd('..')

}