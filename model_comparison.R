library(tidyverse)
library(gt)
library(patchwork)
library(webshot2)

d <- tibble(
model = 1:8,
`other outcomes` = c(
  'FSLong',
  'ANTsSST',
  'ECTavg',
  'FSLong, ANTsSST',
  'FSLong',
  'ANTsSST',
  'ECTavg',
  'FSLong, ANTsSST'),
`transformed MMSE` = c(
  rep(FALSE, 4),
  rep(TRUE, 4)),
`conditional LEPD` = c(
  -5586.3,
  -5529.9, # best untransformed
  -5531.8,
  -5561.1,
  -4854.4,
  -4829.2, # best transformed
  -5003.5,
  -4845.2),
`marginal conditional LEPD` = c(
  -5086.1, # best untransformed
  -5149.0,
  -5103.1,
  -5091.8,
  -4536.1, # best transformed
  -4583.6, 
  -4543.9, 
  -4539.3)
)

comparison_table <- 
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

conditional_lepd_comparison <- 
  d %>% mutate(
  model = as_factor(model)) %>%
  ggplot(aes(x=model, y = `conditional LEPD`)) + 
  theme_bw() + 
  scale_x_discrete(breaks = c(1,2,3,4,5,6,7,8)) + 
  scale_y_reverse() + 
  coord_cartesian(ylim = c(-4500, -5600)) +
  geom_bar(stat='identity')

marginal_conditional_lepd_comparison <- 
  d %>% mutate(
  model = as_factor(model)) %>%
  ggplot(aes(x=model, y = `marginal conditional LEPD`)) + 
  theme_bw() + 
  scale_x_discrete(breaks = c(1,2,3,4,5,6,7,8)) + 
  scale_y_reverse() + 
  coord_cartesian(ylim = c(-4500, -5600)) +
  geom_bar(stat='identity')

comparison_chart <- (conditional_lepd_comparison + marginal_conditional_lepd_comparison)

gtsave(comparison_table, 'comparison_table.png')
ggsave('comparison_chart.png', comparison_chart)
