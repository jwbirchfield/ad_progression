# This loads all the necessary packages and functions

source('../project_files/project_packages.R')
source('../project_files/get_y_vars.R')
source('../project_files/get_model_fit.R')
source('../project_files/get_model_summary.R')
source('../project_files/get_model_run_report.R')
source('../project_files/get_model_results_table.R')
source('../project_files/get_cv_fit.R')
source('../project_files/get_cv_elpd.R')
source('../project_files/get_lov_fit.R')
source('../project_files/get_lov_elpd.R')
# source('../project_files/get_marginal_elpd.R')
beep <- function() beepr::beep(8)

# # turn MMSE loss (0 - 30 scale) into transformed MMSE loss 
# mmse_transform <- function(y){
#   qnorm(1 - exp(-.236*(y + .5)))
# }
# 
# # turn transformed MMSE loss (roughly standard normal) into MMSE loss (0 - 30 scale)
# inverse_mmse_transform <- function(z){
#   -1/.236 * log(1-pnorm(z)) - .5
# }
# 
# # the log-likelihood of MMSE loss is the log likelihood of transformed MMSE loss plus this
# transformation_constant <- function(z){
#   -log(dnorm(z)) + log(.236) + log(1-pnorm(z))
# }