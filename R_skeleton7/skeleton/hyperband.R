# Hyperband
# @param objective (`function()`): objective function to minimize (1D [0, 1]+ 1 budget parameter)
# @param min_budget_per_model (`integer(1)`): minimum budget
# @param max_budget_per_model (`integer(1)`): maximum budget
# @param eta (`double(1)`): eta parameter of Hyperband
# @return (`data.table()`): data.table of optimization trajectory
#   essentially the output of successive halving for different brackets (s)
hyperband = function(objective, min_budget_per_model, max_budget_per_model, eta) {
  s_max = stop("To Implement")
  res_xy = data.table()
  for (s in seq(from = s_max, to = 0)) {
    n_models = stop("To Implement")
    min_budget_per_model_iter = stop ("To Implement")
    res = successive_halving(
      objective = objective,
      n_models = n_models,
      min_budget_per_model = min_budget_per_model_iter,
      max_budget_per_model = max_budget_per_model,
      eta = eta
    )
    res_xy = rbind(res_xy, cbind(res, s = s))
  }

  res_xy
}
