### get_model_fit
# requires: project_packages.R, data.csv, general_model.stan
# project dir is a folder like `model_1`
# usage: get_model_fit(model_1)
# function will write file, so no need to assign

get_model_fit <- function (
  model_name, 
  data_path = '../project_files/data.csv', # path to data from project dir
  stan_model_path = '../project_files/general_model.stan', # path to Stan model from project dir
  n_chains = 4, 
  warmup = 1000, 
  sampling = 6000, 
  thin = 3,
  seed = 122984) {
  
  # make sure to revert after changing working directory
  initial_wd <- getwd(); on.exit(setwd(initial_wd))
  model_name <- enexpr(model_name) %>% as_string()
  y_vars <- get_y_vars(!!enexpr(model_name))
  rstan_options(auto_write = TRUE)
  options(mc.cores = parallel::detectCores())

  model <- cmdstan_model(stan_model_path)
  d <- read_csv(data_path)
  X <- d %>% select(ones, years, age_c, male)
  y <- d %>% select(any_of(y_vars))
  group <- d %>% group_by(id) %>% summarize(group = mean(group)) %>% pull(group)
  
  stan_data <- list(
    I = max(d$id),
    N = nrow(d),
    K = ncol(y),
    id = d$id,
    group = group,
    y = y,
    X = X)
  
  # run model, recording start and end time
  start_time <- lubridate::now()
  fit <- model$sample(
    data = stan_data,
    seed = seed,
    chains = n_chains, 
    iter_warmup = warmup,
    iter_sampling = sampling,
    refresh = (warmup + sampling) / 100, 
    thin = thin,
    max_treedepth = 20,
    adapt_delta = .95)
  end_time <- lubridate::now()
  
  # create /fit directory
  # save .csv chains to /fit directory
  # create .RDS from all chains
  if (!dir.exists("fit")) dir.create("fit")
  fit$save_output_files(
    dir = 'fit/',
    basename = model_name,
    timestamp = T,
    random = F)
  setwd('fit')
  chains <- list.files() %>% 
    str_subset('.csv') %>% 
    str_subset('summary', negate = TRUE)
  model_fit <- read_stan_csv(chains) %>%
    structure(
      model_name = model_name,
      y_vars = y_vars,
      n_chains = n_chains,
      warmup = warmup,
      sampling = sampling,
      thin = thin,
      start_time = start_time, 
      end_time = end_time)
  saveRDS(model_fit, glue('{model_name}_fit.rds'))

}

