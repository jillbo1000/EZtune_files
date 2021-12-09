# set working directory to source file

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(RColorBrewer)
library(gridExtra)

bin <- list.files("../data/tables/", pattern = "csv", full.names = TRUE)
bin <- bin[grepl("gbm|glmnet|svm", bin)]
bin <- bin[grepl("acc|rmse|time", bin)]
bin2 <- list.files("../data/tables/", pattern = "csv")
bin2 <- bin2[grepl("gbm|glmnet|svm", bin2)]
bin2 <- bin2[grepl("acc|rmse|time", bin2)]
bin2 <- gsub(".csv", "", bin2)

resultTab <- NULL
for (i in 1:length(bin)) {
  print(i)
  tmp <- read.csv(bin[i])
  mod <- strsplit(bin2[i], split = "_")
  tmp$mod <- mod[[1]][1]
  tmp$type <- mod[[1]][2]
  tmp$measure <- mod[[1]][3]
  colnames(tmp)[6:7] <- c("g1SE.tmGrid", "gMin.tmIB")
  resultTab <- rbind(resultTab, tmp)
}

unique(resultTab$Data)
resultTab$Data <- gsub("BreastCancer", "Breast Cancer", resultTab$Data)
resultTab$Data <- gsub("BostonHousing", "Boston Housing", resultTab$Data)

resultTab$mod <- ifelse(resultTab$mod == "gbm", "GBM", resultTab$mod)
resultTab$mod <- ifelse(resultTab$mod == "svm", "SVM", resultTab$mod)
resultTab$mod <- ifelse(resultTab$mod == "glmnet", "Elastic net", resultTab$mod)


#==============================================================================
# Make the accuracy plots for each binary dataset
#==============================================================================

binAcc <- dplyr::filter(resultTab, measure == "acc") %>%
  pivot_longer(EZtune.GA.CV:gMin.tmIB, names_to = "pkg", values_to = "accuracies") %>%
  select(-measure)

binTime <- dplyr::filter(resultTab, measure == "time", type == "bin") %>%
  pivot_longer(EZtune.GA.CV:gMin.tmIB, names_to = "pkg", values_to = "time") %>%
  select(-measure)

binDat <- left_join(binAcc, binTime)
binDat


binDat$pkg <- gsub("\\.", " ", binDat$pkg)

binDat$pkg[binDat$mod == "Elastic Net"] <- gsub("g1SE tmGrid", "Glmnet 1SE", binDat$pkg[binDat$mod == "Elastic Net"])
binDat$pkg[binDat$mod == "Elastic Net"] <- gsub("gMin tmIB", "Glmnet Min", binDat$pkg[binDat$mod == "Elastic Net"])
binDat$pkg <- gsub("g1SE tmGrid", "TM Grid or glmnet min", binDat$pkg)
binDat$pkg <- gsub("gMin tmIB", "TM IB or glmnet 1-SE", binDat$pkg)

bin_cols <- brewer.pal(5, "Set2")
bin_data <- unique(binDat$Data)
bin_acc_plot <- NULL
bin_time_plot <- NULL
for (i in 1:length(bin_data)) {
  bin_acc_plot[[i]] <- ggplot(binDat[binDat$Data == bin_data[i], ], aes(x = pkg, y = 1 - accuracies,
                                                                           group = factor(mod),
                                                                           linetype = factor(mod))) +
    geom_path(color = bin_cols[i], size = 1) +
    scale_linetype_manual(name = "", values = c("solid", "twodash", "dotted")) +
    labs(title = bin_data[i], x = "", y = "Classification error") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, vjust  = 1, hjust = 1))

  bin_time_plot[[i]] <- ggplot(binDat[binDat$Data == bin_data[i], ], aes(x = pkg, y = time,
                                                                        group = factor(mod),
                                                                        linetype = factor(mod))) +
    geom_path(color = bin_cols[i], size = 1) +
    scale_linetype_manual(name = "", values = c("solid", "dashed", "dotted")) +
    labs(x = "", y = "Time (sec)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, vjust  = 1, hjust = 1))

}

ggarrange(plotlist = bin_acc_plot, ncol = 5, nrow = 1)
ggarrange(plotlist = bin_time_plot, ncol = 5, nrow = 1)

bin_acc_legend <- ggplot(binDat[binDat$Data == bin_data[1], ], aes(x = pkg, y = time,
                                                                   group = factor(mod),
                                                                   linetype = factor(mod))) +
  geom_path() +
  scale_linetype_manual(name = "", values = c("solid", "dashed", "dotted")) +
  labs(title = bin_data[i], x = "", y = "Time (sec)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust  = 1, hjust = 1))

g1 <- ggplotGrob(bin_acc_legend)
id.legend <- grep("guide", g1$layout$name)
legend <- g1[["grobs"]][[id.legend]]
lwidth <- sum(legend$width)

pdf("../plots/bin_acc_time.pdf", height = 5, width = 11)
grid.arrange(bin_acc_plot[[1]] + theme(legend.position="none", axis.text.x = element_blank()), 
             bin_acc_plot[[2]] + theme(legend.position="none", axis.text.x = element_blank(), axis.title.y = element_blank()),
             bin_acc_plot[[3]] + theme(legend.position="none", axis.text.x = element_blank(), axis.title.y = element_blank()),
             bin_acc_plot[[4]] + theme(legend.position="none", axis.text.x = element_blank(), axis.title.y = element_blank()),
             bin_acc_plot[[5]] + theme(legend.position="none", axis.text.x = element_blank(), axis.title.y = element_blank()),
             legend, 
             bin_time_plot[[1]] + theme(legend.position="none"), 
             bin_time_plot[[2]] + theme(legend.position="none", axis.title.y = element_blank()),
             bin_time_plot[[3]] + theme(legend.position="none", axis.title.y = element_blank()),
             bin_time_plot[[4]] + theme(legend.position="none", axis.title.y = element_blank()),
             bin_time_plot[[5]] + theme(legend.position="none", axis.title.y = element_blank()),
             layout_matrix = rbind(c(1,1,2,2,3,3,4,4,5,5,6), 
                                   c(1,1,2,2,3,3,4,4,5,5,6), 
                                   c(1,1,2,2,3,3,4,4,5,5,6), 
                                   c(1,1,2,2,3,3,4,4,5,5,6), 
                                   c(7,7,8,8,9,9,10,10,11,11,NA),
                                   c(7,7,8,8,9,9,10,10,11,11,NA),
                                   c(7,7,8,8,9,9,10,10,11,11,NA),
                                   c(7,7,8,8,9,9,10,10,11,11,NA),
                                   c(7,7,8,8,9,9,10,10,11,11,NA)))
dev.off()


#==============================================================================
# Make the accuracy plots for each continuous dataset
#==============================================================================

regAcc <- dplyr::filter(resultTab, measure == "rmse") %>%
  pivot_longer(EZtune.GA.CV:gMin.tmIB, names_to = "pkg", values_to = "rmse") %>%
  select(-measure)

regTime <- dplyr::filter(resultTab, measure == "time", type == "reg") %>%
  pivot_longer(EZtune.GA.CV:gMin.tmIB, names_to = "pkg", values_to = "time") %>%
  select(-measure)

regDat <- left_join(regAcc, regTime)
regDat


regDat$pkg <- gsub("\\.", " ", regDat$pkg)

regDat$pkg[regDat$mod == "Elastic Net"] <- gsub("g1SE tmGrid", "Glmnet 1SE", regDat$pkg[regDat$mod == "Elastic Net"])
regDat$pkg[regDat$mod == "Elastic Net"] <- gsub("gMin tmIB", "Glmnet Min", regDat$pkg[regDat$mod == "Elastic Net"])
regDat$pkg <- gsub("g1SE tmGrid", "TM Grid or glmnet min", regDat$pkg)
regDat$pkg <- gsub("gMin tmIB", "TM IB or glmnet 1-SE", regDat$pkg)

reg_cols <- brewer.pal(5, "Accent")[c(1:3,5)]
reg_data <- unique(regDat$Data)
reg_rmse_plot <- NULL
reg_time_plot <- NULL

for (i in 1:length(reg_data)) {
  reg_rmse_plot[[i]] <- ggplot(regDat[regDat$Data == reg_data[i], ], aes(x = pkg, y = rmse,
                                                                        group = factor(mod),
                                                                        linetype = factor(mod))) +
    geom_path(color = reg_cols[i], size = 1) +
    scale_linetype_manual(name = "", values = c("solid", "dashed", "dotted")) +
    labs(title = reg_data[i], x = "", y = "rmse") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, vjust  = 1, hjust = 1))

  reg_time_plot[[i]] <- ggplot(regDat[regDat$Data == reg_data[i], ], aes(x = pkg, y = time,
                                                                         group = factor(mod),
                                                                         linetype = factor(mod))) +
    geom_path(color = reg_cols[i], size = 1) +
    scale_linetype_manual(name = "", values = c("solid", "dashed", "dotted")) +
    labs(x = "", y = "Time (sec)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, vjust  = 1, hjust = 1))

}

ggarrange(plotlist = reg_rmse_plot, ncol = 3, nrow = 2)
ggarrange(plotlist = reg_time_plot, ncol = 3, nrow = 2)

reg_acc_legend <- ggplot(regDat[regDat$Data == reg_data[1], ], aes(x = pkg, y = time,
                                                                   group = factor(mod),
                                                                   linetype = factor(mod))) +
  geom_path() +
  scale_linetype_manual(name = "", values = c("solid", "dashed", "dotted")) +
  labs(title = reg_data[i], x = "", y = "Time (sec)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust  = 1, hjust = 1))


g1 <- ggplotGrob(bin_acc_legend)
id.legend <- grep("guide", g1$layout$name)
legend <- g1[["grobs"]][[id.legend]]
lwidth <- sum(legend$width)

pdf("../plots/reg_rmse_time.pdf", height = 5, width = 10)
grid.arrange(reg_rmse_plot[[1]] + theme(legend.position="none", axis.text.x = element_blank()), 
             reg_rmse_plot[[2]] + theme(legend.position="none", axis.text.x = element_blank(), axis.title.y = element_blank()),
             reg_rmse_plot[[3]] + theme(legend.position="none", axis.text.x = element_blank(), axis.title.y = element_blank()),
             reg_rmse_plot[[4]] + theme(legend.position="none", axis.text.x = element_blank(), axis.title.y = element_blank()),
             legend, 
             reg_time_plot[[1]] + theme(legend.position="none"), 
             reg_time_plot[[2]] + theme(legend.position="none", axis.title.y = element_blank()),
             reg_time_plot[[3]] + theme(legend.position="none", axis.title.y = element_blank()),
             reg_time_plot[[4]] + theme(legend.position="none", axis.title.y = element_blank()),
             layout_matrix = rbind(c(1,1,2,2,3,3,4,4,5), 
                                   c(1,1,2,2,3,3,4,4,5), 
                                   c(1,1,2,2,3,3,4,4,5), 
                                   c(1,1,2,2,3,3,4,4,5), 
                                   c(6,6,7,7,8,8,9,9,NA),
                                   c(6,6,7,7,8,8,9,9,NA),
                                   c(6,6,7,7,8,8,9,9,NA),
                                   c(6,6,7,7,8,8,9,9,NA),
                                   c(6,6,7,7,8,8,9,9,NA)))
dev.off()


