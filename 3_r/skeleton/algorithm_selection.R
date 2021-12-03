library(farff)
library(data.table)
library(mlr3)
library(mlr3learners)
library(mlr3pipelines)

source("3_r/skeleton/single_and_virtual_best.R")
source("3_r/skeleton/select_individual.R")
source("3_r/skeleton/select_hybrid.R")
source("3_r/skeleton/utils.R")

cutoff <- 5000
par <- 10L

data <- readARFF(path = "data/SAT11-INDU/algorithm_runs.arff")
features <- readARFF(path = "data/SAT11-INDU/feature_values.arff")
cv <- readARFF(path = "data/SAT11-INDU/cv.arff")

setDT(data)
setDT(features)
setDT(cv)



performance_single_best <- get_single_best(data, cutoff, par)
cat(sprintf("Performance of Single Best: %f\n", performance_single_best))

performance_virtual_best <- get_virtual_best(data, cutoff, par)
cat(sprintf("Performance of Virtual Best: %f\n", performance_virtual_best))

selected_individual <- select_algorithms(data, features, cv, selector_fun = select_individual)
performance_indiviual <- calculate_performance(selected_individual, data, cutoff)
cat(sprintf("Performance of Individual Models: %f\n", performance_indiviual))

selected_hybrid <- select_algorithms(data, features, cv, selector_fun = select_hybrid)
performance_hybrid <- calculate_performance(selected_hybrid, data, cutoff)
cat(sprintf("Performance of Hybrid Models: %f\n", performance_hybrid))
