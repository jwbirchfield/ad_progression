### MODEL 7 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(model_7); beep() # done
get_model_summary(model_7); beep() # done
get_model_results_table(model_7); beep() # done
get_model_run_report(model_7); beep() # done
get_cv_fit(model_7, seed = 20240121); beep() # done
get_cv_elpd(model_7); beep() # done
get_lov_fit(model_7); beep() 
get_lov_elpd(model_7); beep() 
# get_cv_marginal_elpd(model_2); beepr::beep(8) # not ready


