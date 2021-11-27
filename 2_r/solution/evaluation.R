library(data.table)
library(ggplot2)
source("data_loaders.R")
source("tests.R")

# McNemar Test
data = load_data_MNTest()
A = sum(data[, prediction1 != labels & prediction2 != labels])
B = sum(data[, prediction1 != labels & prediction2 == labels])
C = sum(data[, prediction1 == labels & prediction2 != labels])
D = sum(data[, prediction1 == labels & prediction2 == labels])
mcn = mcnemar(A = A, B = B, C = C, D = D)
cat(sprintf("McNemar Test: Critical Value: %f, Test Statistic: %f, p-Value: %f\n\n", mcn$crit_val, mcn$test_stat, mcn$p))


data = load_data_TMStTest()
diff = data[, y1 - y2]
tst = ttest(diff)
cat(sprintf("Two-Matched-Samples t-Test: Critical Value: %f, Test Statistic: %f, p-Value: %f\n\n", tst$crit_val, tst$test_stat, tst$p))

# Friedman Test
data = load_data_FTestData()
n = nrow(data)
k = ncol(data)
ranks = apply(data, MARGIN = 1L, FUN = rank)
frm = friedman(ranks = ranks, n = n , k = k)
cat(sprintf("Friedmann Test: Critical Value: %f, Test Statistic: %f, p-Value: %f\n\n", frm$crit_val, frm$test_stat, frm$p))

# Post-hoc Nemenyi Test
ranks_mean_models = rowMeans(ranks)
nmy = nemenyi(ranks_mean_models, n = n , k = k)
cat(sprintf("Post-hoc Nemenyi Test:\nCritical Value: %f\n", nmy$crit_val))
print.listof(list("Test Statistic:" = nmy$test_stat))
print.listof(list("p-Values:" = nmy$p))

# Boxplot
id_best = which.min(ranks_mean_models) 
id_worst = which.max(ranks_mean_models)
best = data.table(error = data[, id_best], type = "best")
worst = data.table(error = data[, id_worst], type = "worst")
ggplot(rbind(best, worst), mapping = aes(x = type, y = error)) +
  geom_boxplot() +
  xlab("") +
  ylab("Error")

