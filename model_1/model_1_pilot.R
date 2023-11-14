### MODEL 1 PILOT SCRIPT

source('../project_files/project_packages.R')

get_model_fit(
  y1 = FSLong,
  y2 = MMSE_loss,
  model_name = 'model_1')

get_model_summary(
  model_name = 'model_1')

get_results_table(
  model_name = 'model_1')

get_run_report(
  model_name = 'model_1')

get_folds(
  y1 = FSLong,
  y2 = MMSE_loss,
  model_name = 'model_1')

get_mmse_lepd_2(
  y1 = FSLong, 
  y2 = MMSE_loss,
  model_name = 'model_1',
  transformed_MMSE = FALSE) # -5586.287
