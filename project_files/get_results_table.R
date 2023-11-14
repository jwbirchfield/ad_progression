### get_results_table
#' requires: project_packages.R, model_summary(object), fit(directory)

get_results_table <- function(model_name){
  
  model_fit <- readRDS(glue('fit/{model_name}_fit.RDS'))
  yvars <- attributes(model_fit)$yvars
  
  model_summary <- read_csv(glue('fit/{model_name}_summary.csv'))
  
  results_table <- model_summary %>%
    filter( 
      str_detect(model_summary$parameter, pattern = 'alpha|mu_beta|sigma_beta|sigma_epsilon|Rho_beta|Rho_epsilon')
      & !str_detect(model_summary$parameter, pattern = 'L')) %>%
    mutate(
      symbol = word(parameter, start=1, sep='\\['),
      indices = word(parameter, start=2, sep='\\['), 
      indices = str_sub(indices, start=1, end=-2L),
      l = str_sub(indices, 1, 1), 
      m = case_when(symbol %in% c('alpha', 'mu_beta', 'sigma_beta', 'sigma_epsilon', 'mu_epsilon') ~ str_sub(indices, 3, -1L)),
      r = case_when(symbol %in% c('Rho_beta', 'Rho_epsilon') ~ str_sub(indices, 3, 3)),
      c = case_when(symbol %in% c('Rho_beta', 'Rho_epsilon') ~ str_sub(indices, 5, 5)),
      rc = case_when(
        r <= c ~ paste0(r, ',', c), 
        c < r ~ paste0(c, ',', r)),
      group = case_when(
        l == 1 ~ 'CN',
        l == 2 ~ 'MCI', 
        l == 3 ~ 'AD',
        is.na(l) ~ ''))
  if(length(yvars) == 2){
    results_table <- results_table %>% mutate(
      description = case_when(
        (symbol == 'alpha' & m == 1) ~ glue('age(c) coef {yvars[1]}'),
        (symbol == 'alpha' & m == 2) ~ glue('male coef {yvars[1]}'),
        (symbol == 'alpha' & m == 3) ~ glue('age(c) coef {yvars[2]}'),
        (symbol == 'alpha' & m == 4) ~ glue('male coef {yvars[2]}'),
        (symbol == 'mu_beta' & m == 1) ~ glue('random intercept mean {yvars[1]}'),
        (symbol == 'mu_beta' & m == 2) ~ glue('random slope mean {yvars[1]}'),
        (symbol == 'mu_beta' & m == 3) ~ glue('random intercept mean {yvars[2]}'),
        (symbol == 'mu_beta' & m == 4) ~ glue('random slope mean {yvars[2]}'),
        (symbol == 'sigma_beta' & m == 1) ~ glue('random intercept sd {yvars[1]}'),
        (symbol == 'sigma_beta' & m == 2) ~ glue('random slope sd {yvars[1]}'),
        (symbol == 'sigma_beta' & m == 3) ~ glue('random intercept sd {yvars[2]}'),
        (symbol == 'sigma_beta' & m == 4) ~ glue('random slope sd {yvars[2]}'),
        (symbol == 'sigma_epsilon' & m == 1) ~ glue('error/residual sd {yvars[1]}'),
        (symbol == 'sigma_epsilon' & m == 2) ~ glue('error/residual sd {yvars[2]}'),
        (symbol == 'Rho_epsilon') ~ glue('error/residual correlation {rc}'),
        (symbol == 'Rho_beta') ~ glue('random effects correlation {rc}')))}
  if(length(yvars) == 3){
    results_table <- results_table %>% mutate(
      description = case_when(
        (symbol == 'alpha' & m == 1) ~ glue('age(c) coef {yvars[1]}'),
        (symbol == 'alpha' & m == 2) ~ glue('male coef {yvars[1]}'),
        (symbol == 'alpha' & m == 3) ~ glue('age(c) coef {yvars[2]}'),
        (symbol == 'alpha' & m == 4) ~ glue('male coef {yvars[2]}'),
        (symbol == 'alpha' & m == 5) ~ glue('age(c) coef {yvars[3]}'),
        (symbol == 'alpha' & m == 6) ~ glue('male coef {yvars[3]}'),
        (symbol == 'mu_beta' & m == 1) ~ glue('random intercept mean {yvars[1]}'),
        (symbol == 'mu_beta' & m == 2) ~ glue('random slope mean {yvars[1]}'),
        (symbol == 'mu_beta' & m == 3) ~ glue('random intercept mean {yvars[2]}'),
        (symbol == 'mu_beta' & m == 4) ~ glue('random slope mean {yvars[2]}'),
        (symbol == 'mu_beta' & m == 5) ~ glue('random intercept mean {yvars[3]}'),
        (symbol == 'mu_beta' & m == 6) ~ glue('random slope mean {yvars[3]}'),        
        (symbol == 'sigma_beta' & m == 1) ~ glue('random intercept sd {yvars[1]}'),
        (symbol == 'sigma_beta' & m == 2) ~ glue('random slope sd {yvars[1]}'),
        (symbol == 'sigma_beta' & m == 3) ~ glue('random intercept sd {yvars[2]}'),
        (symbol == 'sigma_beta' & m == 4) ~ glue('random slope sd {yvars[2]}'),
        (symbol == 'sigma_beta' & m == 5) ~ glue('random intercept sd {yvars[3]}'),
        (symbol == 'sigma_beta' & m == 6) ~ glue('random slope sd {yvars[3]}'),        
        (symbol == 'sigma_epsilon' & m == 1) ~ glue('error/residual sd {yvars[1]}'),
        (symbol == 'sigma_epsilon' & m == 2) ~ glue('error/residual sd {yvars[2]}'),
        (symbol == 'sigma_epsilon' & m == 3) ~ glue('error/residual sd {yvars[3]}'),
        (symbol == 'Rho_epsilon') ~ glue('error/residual correlation {rc}'),
        (symbol == 'Rho_beta') ~ glue('random effects correlation {rc}')))}  
  results_table <- results_table %>%
    filter(!is.na(description)) %>%
    select(description, group, mean, sd, q05, q95) %>%
    distinct()
  write_csv(x=results_table, file=glue('fit/{model_name}_results_table.csv'))
  
}
