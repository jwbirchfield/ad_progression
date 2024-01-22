########## this script needs update

get_lov_fit <- function(
    model_name, 
    data_path = '../project_files/data.csv', # path to data from project dir
    stan_model_path = '../project_files/general_model.stan', # path to Stan model from project dir
    n_chains = 4, 
    warmup = 1000, 
    sampling = 6000, 
    seed = 122984,
    thin = 3) {

  # make sure to revert after changing working directory
  initial_wd <- getwd(); on.exit(setwd(initial_wd))
  model_name <- enexpr(model_name) %>% as_string()
  y_vars <- get_y_vars(!!enexpr(model_name))
  rstan_options(auto_write = TRUE)
  options(mc.cores = parallel::detectCores())
  
  model <- cmdstan_model(stan_model_path)
  d <- read_csv(data_path) %>% filter(validation == FALSE)
  if (!dir.exists('lov_fit')) dir.create('lov_fit')

  stan_data = list(
    I = d %>% pull(id) %>% unique() %>% length(),
    N = d %>% nrow(),
    id = d %>% pull(id) %>% as_factor() %>% as.numeric(),
    group = d %>% group_by(id) %>% summarize(group = mean(group)) %>% pull(group),
    K = length(y_vars),
    y = d %>% select(any_of(y_vars)),
    X = d %>% select(ones, years, age_c, male))
  
  fit <- model$sample(
    seed = seed,
    data = stan_data,
    chains = n_chains,
    iter_warmup = warmup,
    iter_sampling = sampling,
    refresh = (warmup + sampling) / 100,
    thin = thin,
    adapt_delta = .95)
  
  fit$save_output_files(
    dir = 'lov_fit/',
    basename = glue('{model_name}_lov'), 
    timestamp = FALSE,
    random = FALSE)
  
  setwd('lov_fit')
  chains <- list.files() %>% 
    str_subset('.csv')
  fit_rstan <- read_stan_csv(chains) %>%
    structure(
      model_name = model_name,
      y_vars = y_vars)
  saveRDS(object = fit_rstan, file = glue('{model_name}_lov.RDS'))

}

