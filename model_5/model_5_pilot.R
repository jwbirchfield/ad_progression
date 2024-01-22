### MODEL 5 PILOT SCRIPT

source('../project_files/project_functions.R')

get_model_fit(model_5); beepr::beep(8) # done
get_model_summary(model_5); beepr::beep(8) # done
get_model_results_table(model_5); beepr::beep(8) # done
get_model_run_report(model_5); beepr::beep(8) # done
get_cv_fit(model_5); beepr::beep(8) # done
get_cv_elpd(model_5); beepr::beep(8) # done
get_lov_fit(model_5); beepr::beep(8) # done
get_lov_elpd(model_5); beepr::beep(8) # done
# get_cv_marginal_elpd(model_2); beepr::beep(8) # not ready

