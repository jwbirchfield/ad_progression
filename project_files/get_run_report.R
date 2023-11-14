### get_run_report(model_name)
#' requires: project_packages.R, model_fit(object), model_summary(object), fit(directory)

get_run_report <- function(model_name){
  
  model_fit <- readRDS(glue('fit/{model_name}_fit.RDS'))
  model_summary <- read_csv(glue('fit/{model_name}_summary.csv'))
  
  model_name <- attributes(model_fit)$model_name
  n_chains <- attributes(model_fit)$n_chains
  warmup <- attributes(model_fit)$warmup
  sampling <- attributes(model_fit)$sampling
  thin <- attributes(model_fit)$thin
  start_time <- attributes(model_fit)$start_time
  end_time <- attributes(model_fit)$end_time
  run_time <- difftime(end_time, start_time, units='mins')
  check_ess <- model_summary %>% filter(parameter != 'lp__') %>% arrange(ess) %>% slice(1:10)
  check_rhat <- model_summary %>% filter(parameter != 'lp__') %>% arrange(desc(rhat)) %>% slice(1:10)
  sampler_params <- get_sampler_params(model_fit, inc_warmup=FALSE)
  divergent <- do.call(rbind, sampler_params)[,'divergent__']
  treedepths <- do.call(rbind, sampler_params)[,'treedepth__']
  too_deep <- length(treedepths[sapply(treedepths, function(x) x == 10)])
  log_lik_1 <- extract_log_lik(model_fit, merge_chains=FALSE)
  r_eff <- relative_eff(exp(log_lik_1), cores=8)
  loo_1 <- loo(log_lik_1, r_eff=r_eff, cores=8, save_psis=TRUE)
  sink(file=glue('fit/{model_name}_run_info.txt'))
  cat('Model name:', model_name, 
      '\n\nChains:', n_chains, 
      '\nWarmup iterations per chain:', warmup, 
      '\nSampling iterations per chain:', sampling, 
      '\nThin:', thin,
      '\nStart time:', as.character(start_time),
      '\nEnd time:', as.character(end_time),
      '\nRun time:', round(run_time, 0), 'minutes',
      '\nMean transitions per minute:', round(sampling*n_chains/as.numeric(run_time), 1),
      '\nMin ESS: ', round(min(check_ess$ess), 1),
      '\nMean ESS:', round(mean(model_summary$ess, na.rm=TRUE), 1),
      '\nMin ESS per transition:', round(min(check_ess$ess)/(sampling*n_chains/thin), 2),
      '\nMean ESS per transition:', round(mean(model_summary$ess, na.rm=TRUE)/(n_chains*sampling/thin), 2),
      '\nMin ESS per minute:', round(min(check_ess$ess)/as.numeric(run_time), 2),
      '\nMean ESS per minute:', round(mean(model_summary$ess, na.rm=TRUE)/as.numeric(run_time) , 2),
      '\nDivergent transitions: ', sum(divergent), '/', (n_chains*sampling/thin),
      '\nMax treedepth exceeded: ', too_deep, '/', (n_chains*sampling/thin),
      '\n\nLowest ESS:\n')
  print(check_ess)
  cat('\nHighest R-hat:\n') 
  print(check_rhat) 
  cat('\n\nLOO:\n')
  print(loo_1)
  sink()
  
}