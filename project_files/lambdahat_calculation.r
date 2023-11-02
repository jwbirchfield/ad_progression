## Calculating transformation, ML function, inverse function

library(tidyverse)

d <- read_csv('../project_files/data.csv')

y <- d$MMSE_loss

f1 <- function(lambda){
  sum(log( exp(-lambda*y)-exp(-lambda*(y + offset)) ))
}

lambdahat <- optimize(f1, c(0,1), maximum=T)$maximum %>% round(3)
lambdahat 

# turn MMSE loss (0 - 30 scale) into transformed MMSE loss 
mmse_transform <- function(y){
  qnorm(1 - exp(-.236*(y + .5)))
}

# turn transformed MMSE loss (roughly standard normal) into MMSE loss (0 - 30 scale)
inverse_mmse_transform <- function(z){
  -1/.236 * log(1-pnorm(z)) - .5
}

# the log-likelihood of MMSE loss is the log likelihood of transformed MMSE loss plus this
transformation_constant <- function(z){
  -log(dnorm(z)) + log(.236) + log(1-pnorm(z))
}
