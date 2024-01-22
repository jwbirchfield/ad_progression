### get_y_vars
# requires: rlang
# get character vector of outcome variables (ordered) from model name
# to change model definitions, just edit this file
# usage: y_vars <- get_y_vars(model_1)

get_y_vars <- function(model_name) {
  model_list <- list2(
    model_1 = c('MMSE_loss', 'FSLong'),
    model_2 = c('MMSE_loss', 'ANTsSST'),
    model_3 = c('MMSE_loss', 'ECTavg'),
    model_4 = c('MMSE_loss', 'FSLong', 'ANTsSST'),
    model_5 = c('transformed_MMSE_loss', 'FSLong'),
    model_6 = c('transformed_MMSE_loss', 'ANTsSST'),
    model_7 = c('transformed_MMSE_loss', 'ECTavg'),
    model_8 = c('transformed_MMSE_loss', 'FSLong', 'ANTsSST'))
  model_name <- enexpr(model_name) %>% as_string()
  if(!model_name %in% names(model_list)) abort('Unknown model.')
  return(model_list[[model_name]])
}

