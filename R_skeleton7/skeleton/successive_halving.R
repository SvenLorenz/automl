# Successive Halving
# @param objective (`function()`): objective function to minimize (1D [0, 1]+ 1 budget parameter)
# @param n_models (`integer(1)`): number of points to evaluate (w.r.t to the domain)
# @param min_budget_per_model (`integer(1)`): minimum budget
# @param max_budget_per_model (`integer(1)`): maximum budget
# @param eta (`double(1)`): eta parameter
# @param x_id (`character(1)`): id (column name) of the domain of the objective
# @param budget_id (`character(1)`): id (column name) of the budget parameter of the objective
# @param y_id (`character(1)`): id (column name) of the codomain of the objective
# @return (`data.table()`): data.table of optimization trajectory
#   this is the output of the objective for the points to be evaluated with increasing budget values
#   contains columns x_id, budget_id, y_id and potentially other result columns of the objective
successive_halving = function(objective, n_models, min_budget_per_model, max_budget_per_model, eta, x_id = "x", budget_id = "budget", y_id = "y") {
  configs_to_eval = setnames(data.table(x = runif(n_models, min = 0, max = 1)), "x", x_id)  # initial configs to eval drawn at random
  budget = round(min_budget_per_model)  # assume integer budget
  res_xy = data.table()

  while (budget <= max_budget_per_model) {
    xdt = cbind(configs_to_eval, budget = budget)
    setnames(xdt, "budget", budget_id)
    res_y = objective(xdt)
    res_xy = rbind(res_xy, cbind(xdt, res_y))

    stop("To Implement")
    # determine the number of configs to proceed
    # select the configs to proceed
    # increase the budget
  }

  res_xy
}
