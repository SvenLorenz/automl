# Compare runtimes of `gp_prediction_a` and `gp_prediction_b`
# @param ns (`integer()`): number of features > 2
# @param data (`matrix`): (m x (d + 1)) data on which the model is fit, last column is y
# @param X (`matrix`): (m x d) data to predict the mean and variance
# @return (`data.table`): for each n in `ns` the runtime of `gp_prediction_a` and `gp_prediction_b`
compare_runtimes = function(ns, data, X) {
  result = lapply(ns, function(n) {
    # Basis function for individual n
    phin = function(x) {
      x = lapply(seq(0, n - 1L), function(i) x^i)
      do.call(cbind, x)
    }

    # Covariance matrix
    Sigma_p = diag(n)

    # Run both gp_prediction_a and gp_prediction_b
    stop("To Implement")
    c(a = runtime_a, b = runtime_b)
  })

  # ...
}
