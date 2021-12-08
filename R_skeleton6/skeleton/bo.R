library(data.table)
library(mlr3)
library(mlr3learners)
library(ggplot2)
library(future.apply)
future::plan("multicore")

source("objective.R")
source("bo_loop.R")
source("acquisitions.R")
source("utils.R")

run_bo(levy1d, lower = -10, upper = 10, acquisition = expected_improvement, max_iter = 12L, n_init = 8L)
run_bo(levy1d, lower = -10, upper = 10, acquisition = lower_confidence_bound, max_iter = 12L, n_init = 8L)

# To Implement: benchmark ei, lcb, random and grid search
