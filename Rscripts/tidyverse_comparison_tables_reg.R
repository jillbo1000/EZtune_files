# set working directory to source file

library(dplyr)
library(tidyr)
library(ggplot2)
library(EZtuneTest)
library(EZtune)

abalone <- list.files("../data/benchmark_results/Abalone", full.names = TRUE)
bost <- list.files("../data/benchmark_results/BostonHousing", full.names = TRUE)
co2 <- list.files("../data/benchmark_results/CO2", full.names = TRUE)
crime <- list.files("../data/benchmark_results/Crime", full.names = TRUE)
dsr <- c(abalone, bost, co2, crime)

dsr <- dsr[!grepl("bayes_5_5|grid_10|_en_|TRUE|0.75", dsr)]

reg_data <- NULL
for(i in 1:length(dsr)) {
  tmp <- read.csv(dsr[i])
  reg_data <- rbind(reg_data, tmp)
}

reg_data <- reg_data[grepl("rmse", reg_data$tuned_on), ]
head(reg_data)
tail(reg_data)
dim(reg_data)

reg2 <- dplyr::group_by(reg_data, data, package, method, optimizer, assess) %>%
  dplyr::summarise(rmse = median(acc_rmse, na.rm = TRUE),
                   time = median(time, na.rm = TRUE))

bm <- paste0(as.character(round(reg2$rmse, digits = 2)), " (",
            as.character(round(reg2$time, digits = 1)), ")")
mod <- paste(reg2$package, reg2$optimizer, reg2$assess)
mod <- gsub("EZtune Genetic algorithm 10-fold cross-validation",
            "EZtune GA CV", mod)
mod <- gsub("EZtune Hooke-Jeeves 10-fold cross-validation",
            "EZtune HJ CV", mod)
mod <- gsub("EZtune Genetic algorithm fast = 0.5",
            "EZtune GA Fast", mod)
mod <- gsub("EZtune Hooke-Jeeves fast = 0.5",
            "EZtune HJ Fast", mod)
mod <- gsub("tidymodels Grid cross-validation",
            "Tidymodels Grid", mod)
mod <- gsub("tidymodels Iterative Bayes cross-validation",
            "Tidymodels IB", mod)
reg3 <- as.data.frame(cbind(reg2$data, reg2$method, mod, bm))
colnames(reg3) <- c("data", "model", "method", "bm")
reg_tab <- pivot_wider(reg3, names_from = method, values_from = bm)
reg_tab <- reg_tab[order(reg_tab$model), ]
reg_tab

write.csv(reg_tab, "../tables/tidyverse_reg.csv", row.names = FALSE, quote = FALSE)


# make a table with only rmse
reg_rmse <- data.frame(Data = reg2$data, method = reg2$method, mod = mod,
                      rmse = reg2$rmse)
reg_rmse <- pivot_wider(reg_rmse, names_from = mod, values_from = rmse)
reg_rmse

reg_time <- data.frame(Data = reg2$data, method = reg2$method, mod = mod,
                       time = reg2$time)
reg_time <- pivot_wider(reg_time, names_from = mod, values_from = time)
reg_time

reg_rmse_svm <- dplyr::filter(reg_rmse, reg_rmse$method == "svm") %>%
  select(-method)
write.csv(reg_rmse_svm, "../data/tables/svm_reg_rmse.csv", row.names = FALSE, quote = FALSE)

reg_rmse_gbm <- dplyr::filter(reg_rmse, reg_rmse$method == "gbm") %>%
  select(-method)
write.csv(reg_rmse_gbm, "../data/tables/gbm_reg_rmse.csv", row.names = FALSE, quote = FALSE)


reg_time_svm <- dplyr::filter(reg_time, reg_time$method == "svm") %>%
  select(-method)
write.csv(reg_time_svm, "../data/tables/svm_reg_time.csv", row.names = FALSE, quote = FALSE)

reg_time_gbm <- dplyr::filter(reg_time, reg_time$method == "gbm") %>%
  select(-method)
write.csv(reg_time_gbm, "../data/tables/gbm_reg_time.csv", row.names = FALSE, quote = FALSE)



