### MODEL 5 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(
  model_name = 'model_5',
  y1 = FSLong,
  y2 = transformed_MMSE_loss)

get_model_summary(
  model_name = 'model_5')

get_results_table(
  model_name = 'model_5')

get_run_report(
  model_name = 'model_5')

get_folds(
  y1 = FSLong,
  y2 = transformed_MMSE_loss,
  model_name = 'model_5')

get_mmse_lepd_2(
  y1 = FSLong, 
  y2 = transformed_MMSE_loss,
  model_name = 'model_5',
  transformed_MMSE = TRUE) # -4854.392

sum(list_c(marginal_cond_lepd_cv))
