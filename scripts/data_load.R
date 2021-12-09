f1 <- "/rafalab/jill/tuning/data/"
f2 <- "_Data.R"

source(paste(f1, data_name, f2, sep = ""))
source("/rafalab/jill/tuning/functions/dummy.R")

dat <- switch(data_name, 
              "BreastCancer" = bc, 
              "Ionosphere" = Ionosphere, 
              "Lichen" = lichen, 
              "Mullein" = mullein, 
              "Pima" = pid,
              "Sonar" = Sonar, 
              "Abalone" = abalone, 
              "BostonHousing" = bh, 
              "CO2" = CO2, 
              "Crime" = crime, 
              "AmesHousing" = oh, 
              "Union" = union, 
              "Wage" = wage)

colnames(dat)[1] <- "y"

y <- dat$y
x <- dat[, -1]

