# setwd("2_r/skeleton")

library(data.table)
library(ggplot2)
source("data_loaders.R")
source("tests.R")

# McNemar Test
data <- load_data_MNTest()
A <- sum((data[, 1] == data[, 2]) & (data[, 1] == data[, 3]))
B <- sum((data[, 1] == data[, 2]) & (data[, 1] != data[, 3]))
C <- sum((data[, 1] != data[, 2]) & (data[, 1] == data[, 3]))
D <- sum((data[, 1] != data[, 2]) & (data[, 1] != data[, 3]))
mcnemar(A = A, B = B, C = C, D = D)

# Two-Matched-Samples t-Test
data <- load_data_TMStTest()
diff <- data[, 1] - data[, 2]
ttest(diff)

# Friedman Test
data <- load_data_FTestData()
n <- nrow(data)
k <- ncol(data)
ranks <- t(apply(data, 1, rank))
friedman(ranks = ranks, n = n, k = k)

# Post-hoc Nemenyi Test
ranks_mean_models <- colMeans(ranks)
nemenyi(ranks_mean_models, n = n, k = k)

# Boxplot
# ...

