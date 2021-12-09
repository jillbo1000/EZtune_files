#!/usr/bin/env Rscript
library("R.utils")
library(EZtune)
library(EZtuneTest)

num <- cmdArgs()
num
data_name <- as.character(num[[1]])
data_name
method <- as.character(num[[2]])
method
test <- as.character(num[[3]])
test
grid_size <- as.numeric(num[[4]])
grid_size
bayes_iter <- as.character(num[[5]])
bayes_iter
num1 <- as.numeric(num[[6]])
num1

if(fast == 0) fast <- FALSE
if(fast == 1) fast <- TRUE

source("/data_load.R")

res <- tm_benchmark(x = x, y = y, name = data_name, method = method,
                    test = test, grid_size = grid_size, 
					bayes_iter = 10)

path <- paste("/eztune_tests/tidymodels/out/", 
              data_name, "/", sep = "")

f <- paste(data_name, method, test, grid_size, bayes_iter, num1, "tidymodels.csv",
           sep = "_") 

write.csv(res, paste0(path, f), row.names = FALSE, quote = FALSE)


