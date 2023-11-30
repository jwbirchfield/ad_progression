library(tidyverse)
library(patchwork)

d <- read_csv('../project_files/data.csv')

histogram_mmse <- 
  ggplot(d, aes(x=MMSE)) + 
  theme_bw() +
  labs(
    x = 'MMSE', y = 'proportion') +
  geom_histogram(
    aes(y = after_stat(count / sum(count))),
    breaks=seq(from=.5, to=30.5, by=1)); histogram_mmse

qqplot_mmse <- 
  ggplot(d, aes(sample=MMSE)) + 
  theme_bw() +
  labs(
    x = 'normal quantile', y = 'observed quantile') +
  geom_qq() +
  geom_qq_line(); qqplot_mmse

histogram_mmse_loss_exponential <- 
  ggplot(d, aes(x=30-MMSE+.5)) +
  theme_bw() +
  labs(
    x = '30 - MMSE + .5', 
    y = 'proportion') +
  geom_histogram(
    aes(y = after_stat(count / sum(count))),
    breaks=0:30) +
  geom_function(
    fun = ~ dexp(.x, rate=.236),
    size = 1); histogram_mmse_loss_exponential

histogram_transformed_mmse_normal <- 
  ggplot(d, aes(x=transformed_MMSE_loss)) +
  theme_bw() +
  labs(
    x = 'transformed MMSE loss',
    y = 'proportion') +
  geom_histogram(
    aes(y = after_stat(count / sum(count))),
    breaks = c(-2:3)) +
  geom_function(
    xlim = c(-2,3),
    size = 1,
    fun = ~ dnorm(.x, mean = 0, sd = 1)); histogram_transformed_mmse_normal

qqplot_transformed_mmse_loss <- 
  ggplot(d, aes(sample = transformed_MMSE_loss)) + 
  theme_bw() + 
  labs(
    x = 'normal quantile',
    y = 'observed quantile') + 
  geom_qq() + 
  geom_qq_line(); qqplot_transformed_mmse_loss

plots1 <- 
  histogram_mmse | qqplot_mmse
plots1

plots2 <- 
  histogram_mmse_loss_exponential | histogram_transformed_mmse_normal | qqplot_transformed_mmse_loss
plots2

ggsave('figures/mmse_before.pdf', plots1, width=8, height=4)
ggsave('figures/mmse_after.pdf', plots2, width=8, height=4)
