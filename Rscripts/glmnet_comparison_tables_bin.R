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

dsr <- dsr[grepl("_en_", dsr)]
dsr <- dsr[!grepl("TRUE|0.75|auc", dsr)]

bin_data <- NULL
for(i in 1:length(dsr)) {
  tmp <- read.csv(dsr[i])
  bin_data <- rbind(bin_data, tmp)
}

head(bin_data)
tail(bin_data)
dim(bin_data)

bin_results <- dplyr::group_by(bin_data, data, package, method, optimizer,
                               assess, tuned_on) %>%
  dplyr::summarise(acc = median(acc_rmse, na.rm = TRUE),
                   auc = median(auc_mae, na.rm = TRUE),
                   time = median(time, na.rm = TRUE))

bin2 <- select(bin_results, -tuned_on, -auc)

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
mod <- gsub("glmnet min cross-validation",
            "Glmnet Min", mod)
mod <- gsub("glmnet 1se cross-validation",
            "Glmnet 1-SE", mod)
bin3 <- as.data.frame(cbind(bin2$data, bin2$method, mod, bm))
colnames(bin3) <- c("data", "model", "method", "bm")
bin_tab <- pivot_wider(bin3, names_from = method, values_from = bm)
bin_tab <- bin_tab[order(bin_tab$model), ]
bin_tab

write.csv(bin_tab, "../tables/glmnet_bin.csv", row.names = FALSE, quote = FALSE)

# make a table with only accuracy
bin_acc <- data.frame(Data = bin2$data, mod = mod, acc = bin2$acc)
bin_acc <- pivot_wider(bin_acc, names_from = mod, values_from = acc)
bin_acc

bin_time <- data.frame(Data = bin2$data, mod = mod, time = bin2$time)
bin_time <- pivot_wider(bin_time, names_from = mod, values_from = time)
bin_time

write.csv(bin_acc, "../data/tables/glmnet_bin_acc.csv", row.names = FALSE, quote = FALSE)
write.csv(bin_time, "../data/tables/glmnet_bin_time.csv", row.names = FALSE, quote = FALSE)


