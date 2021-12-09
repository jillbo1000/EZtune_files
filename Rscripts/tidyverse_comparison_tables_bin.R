# set working directory to source file

library(dplyr)
library(tidyr)
library(ggplot2)
library(EZtuneTest)
library(EZtune)

bc <- list.files("../data/benchmark_results/BreastCancer", full.names = TRUE)
li <- list.files("../data/benchmark_results/Lichen", full.names = TRUE)
mu <- list.files("../data/benchmark_results/Mullein", full.names = TRUE)
pi <- list.files("../data/benchmark_results/Pima", full.names = TRUE)
so <- list.files("../data/benchmark_results/Sonar", full.names = TRUE)
dsr <- c(bc, li, mu, pi, so)

dsr <- dsr[!grepl("bayes_5_5|grid_10|_en_|TRUE|0.75", dsr)]

bin_data <- NULL
for(i in 1:length(dsr)) {
  tmp <- read.csv(dsr[i])
  bin_data <- rbind(bin_data, tmp)
}

bin_data <- bin_data[grepl("accuracy", bin_data$tuned_on), ]
head(bin_data)
tail(bin_data)
dim(bin_data)

bin2 <- dplyr::group_by(bin_data, data, package, method, optimizer,
                        assess) %>%
  dplyr::summarise(acc = median(acc_rmse, na.rm = TRUE),
                   time = median(time, na.rm = TRUE))


bm <- paste0(as.character(round(bin2$acc, digits = 4)), " (",
             as.character(round(bin2$time, digits = 1)), ")")
mod <- paste(bin2$package, bin2$optimizer, bin2$assess)
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
bin3 <- as.data.frame(cbind(bin2$data, bin2$method, mod, bm))
colnames(bin3) <- c("data", "model", "method", "bm")
bin_tab <- pivot_wider(bin3, names_from = method, values_from = bm)
bin_tab <- bin_tab[order(bin_tab$model), ]
bin_tab

write.csv(bin_tab, "../data/tables/tidyverse_bin.csv", row.names = FALSE, quote = FALSE)

# make a table with only accuracy
bin_acc <- data.frame(Data = bin2$data, method = bin2$method, mod = mod,
                      acc = bin2$acc)
bin_acc <- pivot_wider(bin_acc, names_from = mod, values_from = acc)
bin_acc

bin_time <- data.frame(Data = bin2$data, method = bin2$method, mod = mod,
                       time = bin2$time)
bin_time <- pivot_wider(bin_time, names_from = mod, values_from = time)
bin_time

bin_acc_svm <- dplyr::filter(bin_acc, bin_acc$method == "svm") %>%
  select(-method)
write.csv(bin_acc_svm, "../data/tables/svm_bin_acc.csv", row.names = FALSE, quote = FALSE)

bin_acc_gbm <- dplyr::filter(bin_acc, bin_acc$method == "gbm") %>%
  select(-method)
write.csv(bin_acc_gbm, "../data/tables/gbm_bin_acc.csv", row.names = FALSE, quote = FALSE)


bin_time_svm <- dplyr::filter(bin_time, bin_time$method == "svm") %>%
  select(-method)
write.csv(bin_time_svm, "../data/tables/svm_bin_time.csv", row.names = FALSE, quote = FALSE)

bin_time_gbm <- dplyr::filter(bin_time, bin_time$method == "gbm") %>%
  select(-method)
write.csv(bin_time_gbm, "../data/tables/gbm_bin_time.csv", row.names = FALSE, quote = FALSE)




