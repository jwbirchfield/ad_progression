### get_cv_fit
# partition model into five folds, and fit separately with each fold left out
# requires: project_packages.R, general_model_cv.stan
# project dir is a folder like `model_1`
# usage: get_folds(model_1)
# function will write file, so no need to assign

get_cv_fit <- function (
  model_name, 
  data_path = '../project_files/data.csv', 
  stan_model_path = '../project_files/general_model_cv.stan',
  n_chains = 4, 
  warmup = 1000, 
  sampling = 2000, 
  thin = 2, 
  seed = 122984) {
  
  model_name <- as_string(enexpr(model_name))
  y_vars <- get_y_vars(!!enexpr(model_name))
  d <- read_csv(data_path)
  model <- cmdstan_model(stan_model_path)
  rstan_options(auto_write = TRUE)
  options(mc.cores = parallel::detectCores())
  if (!dir.exists("cv_fit")) dir.create("cv_fit")
  
  for (k in 1:5) {
    
    cat(glue('\n\n---\n\nBeginning sampling on fold {k}\n\n---\n\n'))
    
    d_train <- d %>% filter(fold != k)
    d_test <- d %>% filter(fold == k)
    
    stan_data = list(
      I = d_train %>% pull(id) %>% unique() %>% length(),
      N = d_train %>% nrow(),
      id = d_train %>% pull(id) %>% as_factor() %>% as.numeric(),
      group = d_train %>% group_by(id) %>% summarize(group = mean(group)) %>% pull(group),
      K = length(y_vars),
      y = d_train %>% select(any_of(y_vars)),
      X = d_train %>% select(ones, years, age_c, male),
      I_test = d_test %>% pull(id) %>% unique() %>% length(),
      N_test = d_test %>% nrow(),
      id_test = d_test %>% pull(id) %>% as_factor() %>% as.numeric(),
      group_test = d_test %>% group_by(id) %>% summarize(group = mean(group)) %>% pull(group),
      X_test = d_test %>% select(ones, years, age_c, male))
    
    fit <- model$sample(
      data = stan_data,
      seed = seed,
      chains = n_chains,
      iter_warmup = warmup,
      iter_sampling = sampling,
      refresh = (warmup + sampling) / 100,
      thin = thin,
      adapt_delta = .95)
    
    fit$save_output_files(
      dir = 'cv_fit',
      basename = glue('{model_name}_fold_{k}_chain'), 
      timestamp = FALSE,
      random = FALSE)
    
    fold_chains <- list.files('cv_fit') %>% 
      str_subset(glue('{model_name}_fold_{k}_chain'))
    
    for(i in 1:length(fold_chains)){
      fold_chains[i] <- glue('cv_fit/{fold_chains[i]}')
    }
    
    fold_fit <- read_stan_csv(fold_chains) %>%
      structure(
        model_name = model_name,
        fold = k,
        y_vars = y_vars)
    
    saveRDS(object = fold_fit, file = glue('cv_fit/{model_name}_fold_{k}.rds'))
    
  } # end for (k in 1:5)
  
} # end function

