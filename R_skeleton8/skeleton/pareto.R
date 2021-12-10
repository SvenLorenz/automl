# Find the pareto-optimal points
# @param costs (`data.table()`): data.table of dimension (n_points, m_costs)
# @param return (`logical()`): (n_points) indicator if point is on pareto front or not
pareto = function(costs) {
  mcosts = as.matrix(costs)
  # first assume all points are pareto optimal
  is_pareto = rep(TRUE, nrow(mcosts))

  stop("To Implement")

  is_pareto
}
