
library(dplyr)
library(mlbench) 

data(BostonHousing2)
bh <- mutate(BostonHousing2, lcrim = log(crim)) %>%
  select(-town, -medv, -crim)
bh <- bh[, c(4, 1:3, 5:17)]


