### MODEL 8 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(
  y1 = FSLong,
  y2 = ANTsSST,
  y3 = transformed_MMSE_loss,
  model_name = 'model_8')

get_model_summary(
  model_name = 'model_8')

get_results_table(
  model_name = 'model_8')

get_run_report(
  model_name = 'model_8')

get_folds(
  y1 = FSLong,
  y2 = ANTsSST,
  y3 = transformed_MMSE_loss,
  model_name = 'model_8')

get_mmse_lepd_3(
  y1 = FSLong,
  y2 = ANTsSST,
  y3 = transformed_MMSE_loss,
  model_name = 'model_8',
  transformed_MMSE = TRUE) # 
