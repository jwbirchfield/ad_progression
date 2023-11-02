### get_folds()
# partition model into five folds, and fit separately with each fold left out
# requires: project_packages.R, general_model_cv.stan

get_folds <- function(model_name, 
  y1, 
  y2, 
  y3 = NULL,
  data = 'data.csv', 
  n_chains = 4, 
  warmup = 1000, 
  sampling = 2000, 
  thin = 2){
  
  d <- read_csv('../project_files/data.csv')
  model <- cmdstan_model('../project_files/general_model_cv.stan')
  rstan_options(auto_write=TRUE)
  options(mc.cores = parallel::detectCores())
  if( !dir.exists("cv_fit") ){dir.create("cv_fit")}
  
  for(k in 1:5){
    
    d_train <- d %>% filter(fold != k)
    d_test <- d %>% filter(fold == k)
    
    stan_data = list(
      K = d_train %>% select({{y1}}, {{y2}}, {{y3}}) %>% ncol(),
      I = d_train %>% pull(id) %>% unique() %>% length(),
      I_test = d_test %>% pull(id) %>% unique() %>% length(),
      N = d_train %>% nrow(),
      N_test = d_test %>% nrow(),
      id = d_train %>% pull(id) %>% as_factor() %>% as.numeric(),
      id_test = d_test %>% pull(id) %>% as_factor() %>% as.numeric(),
      group = d_train %>% group_by(id) %>% summarize(group = mean(group)) %>% pull(group),
      group_test = d_test %>% group_by(id) %>% summarize(group = mean(group)) %>% pull(group),
      y = d_train %>% select({{y1}}, {{y2}}, {{y3}}),
      y_test = d_test %>% select({{y1}}, {{y2}}, {{y3}}),
      X = d_train %>% select(ones, years, age_c, male),
      X_test = d_test %>% select(ones, years, age_c, male))
    
    fit <- model$sample(
      data = stan_data,
      seed = 122984,
      chains = n_chains,
      iter_warmup = warmup,
      iter_sampling = sampling,
      refresh = (warmup+sampling)/100,
      thin = thin,
      adapt_delta = .95)
    
    fit$save_output_files(
      dir='cv_fit',
      basename=glue('{model_name}_fold_{k}_chain'), 
      timestamp=F,
      random=F)
    
    fold_chains <- list.files('cv_fit') %>% 
      str_subset(glue('{model_name}_fold_{k}_chain'))
    for(i in 1:length(fold_chains)){
      fold_chains[i] <- glue('cv_fit/{fold_chains[i]}')
    }
    fold_fit <- read_stan_csv(fold_chains) %>%
      structure(
        model_name = model_name,
        fold = k,
        yvars = (d_train %>% select({{y1}}, {{y2}}, {{y3}}) %>% colnames())
      )
    saveRDS(object = fold_fit, file = glue('cv_fit/{model_name}_fold_{k}.rds'))
    
  } # end for(k=1:5)
  
} # end function