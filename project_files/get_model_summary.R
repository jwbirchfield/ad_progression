### get_model_summary
# requires: project_packages.R, model_fit(object), fit(directory)
# project dir is a folder like `model_1`
# usage: get_model_summary(model_1)
# function writes a file, so no need to assign

get_model_summary <- function(model_name){
  
  model_name <- enexpr(model_name) %>% as_string()
  model_fit <- readRDS(glue('fit/{model_name}_fit.RDS'))
  model_summary <- summarize_draws(
    model_fit, mean, sd, ~quantile(.x, probs = c(.05,.95)), rhat, ess_bulk)
  colnames(model_summary) <- c('parameter', 'mean', 'sd', 'q05', 'q95', 'rhat', 'ess')
  model_summary <- model_summary %>% 
    filter(!is.na(ess)) %>% 
    filter(!str_detect(parameter, "log_lik")) %>%
    mutate(mean = round(mean, 3), 
           sd = round(sd, 3), 
           q05 = round(q05, 3), 
           q95 = round(q95, 3), 
           rhat = round(rhat, 3), 
           ess = round(ess, 0))
  write_csv(model_summary, glue('fit/{model_name}_summary.csv'))
  
}

