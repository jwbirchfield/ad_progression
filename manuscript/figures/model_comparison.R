p_load(xtable, webshot2)

comparison_table <- tibble(
  model = 1:8,
  CV = c(
    -5580,
    -5530,
    -5534,
    -5556,
    -4852,
    -4829,
    -4843, 
    -4846),
  LOV = c(
    -2625, 
    -2604,
    -2611,
    -2615,
    -2048, 
    -2030, 
    -2052,
    -2052))

xtable(comparison_table)

comparison_table_gt <- 
  d %>% gt() %>%
  tab_header(
    title = 'Fit statistics across 8 models',
    subtitle = 'by 5-fold cross-validation, applied to MMSE outcome only') %>%
  cols_align(
    align = 'left',
    columns = everything()) %>%
  opt_stylize(
    style = 6,
    color = 'blue') %>%
  opt_table_lines('all') %>%
  opt_table_outline()

cv_comparison <- 
  comparison_table %>% 
  mutate(model = as_factor(model)) %>%
  ggplot(aes(x = model, y = CV)) + 
  theme_bw() + 
  labs(title = 'ELPD by 5-fold cross-validation', y = NULL) +
  scale_x_discrete(breaks = 1:8) + 
  scale_y_reverse() + 
  coord_cartesian(ylim = c(-4750, -5600)) +
  geom_bar(stat='identity') + 
  annotate(
    x = 1:8, y = -4750, geom = 'text', 
    label = as.character(comparison_table$CV),
    color = 'white', size = 3)

lov_comparison <- 
  comparison_table %>% 
  mutate(model = as_factor(model)) %>%
  ggplot(aes(x = model, y = LOV)) + 
  theme_bw() + 
  labs(title = 'ELPD by last-observation validation', y = NULL) +
  scale_x_discrete(breaks = 1:8) + 
  #scale_y_continuous(breaks = c(-2000, -2200, -2400, -2600)) +
  scale_y_reverse() + 
  coord_cartesian(ylim = c(-1950, -2700)) +
  geom_bar(stat='identity') +
  annotate(
    x = 1:8, y = -1950, geom = 'text', 
    label = as.character(comparison_table$LOV),
    color = 'white', size = 3)

elpd_plot <- cv_comparison + lov_comparison

ggsave(filename = 'figures/elpd_plot.pdf', width = 8, height = 4)
