### MODEL 4 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(
  y1 = FSLong,
  y2 = ANTsSST,
  y3 = MMSE_loss,
  model_name = 'model_4')

get_model_summary(
  model_name = 'model_4')

get_results_table(
  model_name = 'model_4')

get_run_report(
  model_name = 'model_4')

get_folds(
  y1 = FSLong,
  y2 = ANTsSST,
  y3 = MMSE_loss,
  model_name = 'model_4')

get_mmse_lepd_3(
  y1 = FSLong,
  y2 = ANTsSST,
  y3 = MMSE_loss,
  model_name = 'model_4',
  transformed_MMSE = FALSE) # -5561.115
