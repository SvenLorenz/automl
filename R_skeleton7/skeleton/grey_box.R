library(data.table)
library(ggplot2)

source("objective.R")
source("successive_halving.R")
source("hyperband.R")

set.seed(1)
res_sh = successive_halving(objective, n_models = 40L, min_budget_per_model = 10L, max_budget_per_model = 100L, eta = 2)

ggplot(res_sh, aes(x = as.factor(budget), y = y, group = x, color = x)) +
  geom_line() +
  geom_point()

res_hb = hyperband(objective, min_budget_per_model = 2L, max_budget_per_model = 100L, eta = 2)

ggplot(res_hb, aes(x = as.factor(budget), y = y, group = x, color = x)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ s)
