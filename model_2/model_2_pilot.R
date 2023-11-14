### MODEL 2 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(
  model_name = 'model_2',
  y1 = ANTsSST,
  y2 = MMSE_loss)

get_model_summary(
  model_name = 'model_2')

get_results_table(
  model_name = 'model_2')

get_run_report(
  model_name = 'model_2')

get_folds(
  y1 = ANTsSST,
  y2 = MMSE_loss,
  model_name = 'model_2')

get_mmse_lepd_2(
  y1 = ANTsSST, 
  y2 = MMSE_loss,
  model_name = 'model_2',
  transformed_MMSE = FALSE) # -5529.918
