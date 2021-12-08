# Random search for optimizing a 1D continuous function
# @param objective (`function()`): objective function to minimize
# @param lower (`double(1)`): lower bound of domain
# @param upper (`double(1)`): upper bound of domain
# @param max_iter (`integer(1)`): maximum number of function calls
# @return (`data.table()`): data.table with all evaluated points and their objective value
run_random_search = function(objective, lower = 0, upper = 1, max_iter) {
  stop("To Implement")
  # x = ...
  y = sapply(x, FUN = objective)
  data.table(x = x, y = y)
}

# Grid search for optimizing a 1D continuous function
# @param objective (`function()`): objective function to minimize
# @param lower (`double(1)`): lower bound of domain
# @param upper (`double(1)`): upper bound of domain
# @param max_iter (`integer(1)`): maximum number of function calls
# @return (`data.table()`): data.table with all evaluated points and their objective value
run_grid_search = function(objective, lower = 0, upper = 1, max_iter) {
  stop("To Implement")
  # x = ...
  y = sapply(x, FUN = objective)
  data.table(x = x, y = y)
}
