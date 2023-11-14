### MODEL 7 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(
  model_name = 'model_7',
  y1 = ECTavg,
  y2 = transformed_MMSE_loss)

get_model_summary(
  model_name = 'model_7')

get_results_table(
  model_name = 'model_7')

get_run_report(
  model_name = 'model_7')

get_folds(
  y1 = ECTavg,
  y2 = transformed_MMSE_loss,
  model_name = 'model_7')

get_mmse_lepd_2(
  y1 = ECTavg, 
  y2 = transformed_MMSE_loss,
  model_name = 'model_7',
  transformed_MMSE = TRUE) # 
