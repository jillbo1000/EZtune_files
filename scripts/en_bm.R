#!/usr/bin/env Rscript
library("R.utils")
library(EZtune)
library(EZtuneTest)
library(glmnet)

num <- cmdArgs()
num
data_name <- as.character(num[[1]])
data_name
loss <- as.character(num[[2]])
loss
num1 <- as.numeric(num[[3]])
num1

source("/data_load.R")

res <- en_benchmark(x = x, y = y, name = data_name, loss = loss)

path <- paste("/eztune_tests/tidymodels/out/",
              data_name, "/", sep = "")

f <- paste(data_name, "en", loss, num1, "glmnet.csv", sep = "_")

write.csv(res, paste0(path, f), row.names = FALSE, quote = FALSE)


