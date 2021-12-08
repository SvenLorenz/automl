library(data.table)
library(ggplot2)
source("ea.R")
source("helpers.R")
source("mutators.R")
source("objective.R")
source("parent_selectors.R")
source("recombinators.R")

dimensionality = 2  # 2d problem

# Upper and lower bounds
upper = rep(32.768, dimensionality) 
lower = -upper

plot_ackley()

set.seed(123)
ea(ackley, lower = lower, upper = upper, n_eval = 1000L)  # test

# Construct grid
# grid = ...
# grid[, best := NA]

set.seed(456)
# For each point in the grid, run the newly configured EA and store the best solution
for (i in seq_len(nrow(grid))) {
  # ...
  tmp = ea(ackley, lower = lower, upper = upper, n_eval = 1000,
           select_parents = selector, mutate = mutator, recombine = recombinator)

  grid$best[i] = min(tmp$y)
}

