# McNemar Test
# H0: both models have the same performance
# H1: performances of the two models are not equal
# @param A (`integer(1)`): cell A as defined on the slides
# @param B (`integer(1)`): cell B as defined on the slides
# @param C (`integer(1)`): cell C as defined on the slides
# @param D (`integer(1)`): cell D as defined on the slides
# @return (`list()`) of critical value, test statistic, p-value
mcnemar <- function(A, B, C, D) {
  chi2_mc <- (abs(B - C) - 1)^2 / (B + C)
  chi2_095 <- qchisq(0.95, df = 1)
  p <- 1 - pchisq(chi2_mc, 1)

  list(crit_val = chi2_095, test_stat = chi2_mc, p = p)
}

# Two-Matched-Samples t-Test
# H0: both models have the same performance
# H1: performances of the two models are not equal
# @param diff (`numeric()`): vector of observationwise differences
# @return (`list()`) of critical value, test statistic, p-value
ttest <- function(diff) {
  d_mean <- mean(diff)
  d_sd <- sd(diff)
    
  t <- sqrt(length(diff)) * d_mean / d_sd
  t_0975 <- qt(0.95, df = length(diff) - 1)
  p <- 2 * pt(-abs(t), length(diff) - 1)

  list(crit_val = t_0975, test_stat = t, p = p)
}

# Friedman Test
# H0: all algorithms are equivalent in performance and their average rank is equal
# H1: at least one average rank of an algorithm is different
# @param ranks (`matrix(numeric())`): k x n matrix containing ranks of algorithms on datasets
# @param n (`integer(1)`): number of datasets
# @param k (`integer(1)`): number of algorithms
# @return (`list()`) of critical value, test statistic, p-value
friedman <- function(ranks, n, k) {
  mean_rank_models <- colMeans(ranks)
  mean_rank <- mean(ranks)

  ss_total <- sum((mean_rank_models - mean_rank)^2) * n
  ss_error <- sum((ranks - mean_rank)^2) / (n * (k - 1))

  chi2_F <- ss_total / ss_error
  chi2_095 <- qchisq(0.95, df = k - 1)
  p <- 1 - pchisq(chi2_F, k - 1)

  list(crit_val = chi2_095, test_stat = chi2_F, p = p)
}

# Post-hoc Nemenyi Test
# Determines which pairs of algorithms differ significantly in their performance
# @param ranks_mean_models (`numeric()`): numeric vector of mean ranks of algorithms
# @param n (`integer(1)`): number of datasets
# @param k (`integer(1)`): number of algorithms
# @return (`list()`) critical value, test statistics (matrix), p-values (matrix)
nemenyi <- function(ranks_mean_models, n, k) {
  q <- matrix(NA_real_, nrow = k, ncol = k)
  p <- matrix(NA_real_, nrow = k, ncol = k)

  for (i in seq_len(k)) {
    q[i, ] <- (ranks_mean_models - ranks_mean_models[i]) /
               sqrt(k * (k + 1) / (6 * n))
    
  }
  Q_value = np.array([(FData_stats['mean_rank_models'] - FData_stats['mean_rank_models'][i]) / np.sqrt(k*(k+1)/(6*n)) for i in range(k)])
    
  list(crit_val = qnemenyi, test_stat = q, p = p)
}

