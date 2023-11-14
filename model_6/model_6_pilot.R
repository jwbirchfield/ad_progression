### MODEL 6 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(
  model_name = 'model_6',
  y1 = ANTsSST,
  y2 = transformed_MMSE_loss)

get_model_summary(
  model_name = 'model_6')

get_results_table(
  model_name = 'model_6')

get_run_report(
  model_name = 'model_6')

get_folds(
  y1 = ANTsSST,
  y2 = transformed_MMSE_loss,
  model_name = 'model_6')

get_mmse_lepd_2(
  y1 = ANTsSST, 
  y2 = transformed_MMSE_loss,
  model_name = 'model_6',
  transformed_MMSE = TRUE) # -4829.206
