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
worst_idx <- which(max(ranks_mean_models) == ranks_mean_models)
best_idx <- which(min(ranks_mean_models) == ranks_mean_models)
data_best_worst <- data.frame(
    model_error = c(data[, best_idx], data[, worst_idx]),
    which_model = c(rep("best", nrow(data)), rep("worst", nrow(data)))
)
ggplot(data_best_worst) +
    geom_histogram(aes(model_error, fill = which_model),
                   alpha = 0.5) +
    xlab("Error of Models") +
    scale_fill_discrete(name = "Model",
                        breaks = c("best", "worst"),
                        labels = c("Best model", "Worst model")) +
    ggtitle("Best vs worst Model errors") +
    theme_bw()
