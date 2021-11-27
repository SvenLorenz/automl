# McNemar Test
# H0: both models have the same performance
# H1: performances of the two models are not equal
# @param A (`integer(1)`): cell A as defined on the slides
# @param B (`integer(1)`): cell B as defined on the slides
# @param C (`integer(1)`): cell C as defined on the slides
# @param D (`integer(1)`): cell D as defined on the slides
# @return (`list()`) of critical value, test statistic, p-value
mcnemar = function(A, B, C, D) {
  chi2_095 = qchisq(0.95, df = 1)
  chi2_mc = ((abs(B - C) -1) ^ 2 ) / (B + C)
  p = 1 - pchisq(chi2_mc, df = 1L)
  list(crit_val = chi2_095, test_stat = chi2_mc, p = p)
}

# Two-Matched-Samples t-Test
# H0: both models have the same performance
# H1: performances of the two models are not equal
# @param diff (`numeric()`): vector of observationwise differences
# @return (`list()`) of critical value, test statistic, p-value
ttest = function(diff) {
  df = length(diff) - 1L
  t_0975 = qt(0.975, df = df)
  diff_mean = mean(diff)
  sigma_d = sqrt(sum((diff - diff_mean) ^ 2) / df)
  t = sqrt(length(diff)) * diff_mean / sigma_d 
  p = 2 * (pt(-abs(t), df = df)) 
  list(crit_val = t_0975, test_stat = t, p = p)
}

# Friedman Test
# H0: all algorithms are equivalent in performance and their average rank is equal
# H1: at least one average rank of an algorithm is different
# @param ranks (`matrix(numeric())`): k x n matrix containing ranks of algorithms on datasets
# @param n (`integer(1)`): number of datasets
# @param k (`integer(1)`): number of algorithms
# @return (`list()`) of critical value, test statistic, p-value
friedman = function(ranks, n, k) {
  chi2_095 = qchisq(0.95, df = k - 1L) 
  ranks_mean_all = mean(ranks) 
  ranks_mean_models = rowMeans(ranks)
  ss_total = n * sum((ranks_mean_models - ranks_mean_all) ^ 2) 
  ss_error = sum((ranks_mean_all - ranks) ^ 2) / (n *(k - 1L)) 
  chi2_F = ss_total / ss_error
  p = 1 - pchisq(chi2_F, df = k - 1L)
  list(crit_val = chi2_095, test_stat = chi2_F, p = p)
}

# Post-hoc Nemenyi Test
# Determines which pairs of algorithms differ significantly in their performance
# @param ranks_mean_models (`numeric()`): numeric vector of mean ranks of algorithms
# @param n (`integer(1)`): number of datasets
# @param k (`integer(1)`): number of algorithms
# @return (`list()`) critical value, test statistics (matrix), p-values (matrix)
nemenyi = function(ranks_mean_models, n, k) {
  qnemenyi = qtukey(0.95, nmeans = k, df = Inf) / sqrt(2L)  # critical value 
  ranks_expand_h = ranks_mean_models %*% t(rep(1, k)) 
  q = (ranks_expand_h - t(ranks_expand_h)) / sqrt(k * (k + 1L) / (6L * n)) 
  q[lower.tri(q)] = 0 
  p  = 1 - ptukey(abs(q) * sqrt(2), nmeans = k, df = Inf)
  list(crit_val = qnemenyi, test_stat = q, p = p)
}

