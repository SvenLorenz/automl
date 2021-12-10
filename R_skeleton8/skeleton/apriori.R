# Implement the two example apriori methods presented in the lecture
# @param costs (`data.table()`): data.table of dimension (n_points, m_costs)
# @param weights (`double()`): vector of length (m_costs). Determines the weighting of the costs. If NULL use lexical ordering
# @param order (`double()`): vector of length (m_costs). Determines the lexicograpical order. If NULL use weighted sum
# @return (`integer(1)`): Index of optimal element according to apriori method
apriori = function (costs, weights = NULL, order = NULL) {
  mcosts = as.matrix(costs)
  if (!is.null(weights) && !is.null(order)) {
    stop("You can only specify weight or order but not both")
  }
  if (!is.null(weights)) {
    stop("To Implement")
  }
  if (!is.null(order)) {
    stop("To Implement")
  }
  arg
}
