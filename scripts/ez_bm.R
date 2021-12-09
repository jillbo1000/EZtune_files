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
optimizer <- as.character(num[[3]])
optimizer
fast <- as.numeric(num[[4]])
fast
cross <- as.character(num[[5]])
cross
loss <- as.character(num[[6]])
loss
num1 <- as.numeric(num[[7]])
num1

if(fast == 0) fast <- FALSE
if(fast == 1) fast <- TRUE

source("/data_load.R")

res <- ez_benchmark(x = x, y = y, name = data_name, method = method,
                    optimizer = optimizer, fast = fast, cross = cross,
                    loss = loss)

path <- paste("/eztune_tests/tidymodels/out/", 
              data_name, "/", sep = "")

f <- paste(data_name, method, optimizer, fast, cross, loss, num1, "eztune.csv",
           sep = "_") 

write.csv(res, paste0(path, f), row.names = FALSE, quote = FALSE)


