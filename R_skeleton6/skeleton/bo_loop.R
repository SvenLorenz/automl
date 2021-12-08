# Bayesian optimization loop for minimizing a 1D continuous function
# @param objective (`function()`): objective function to minimize
# @param lower (`double(1)`): lower bound of domain
# @param upper (`double(1)`): upper bound of domain
# @param acquisition (`function()`): acquisition function to maximize
# @param max_iter (`integer(1)`): maximum number of function calls
# @param n_init (`integer(1)`): number of points to build initial model
# @param random_init (`logical(1)`): if TRUE initial points are sampled uniformly at random otherwise equidistant within bounds
# @return (`data.table()`): data.table with all evaluated points and their objective value
run_bo = function(objective, lower = 0, upper = 1, acquisition, max_iter, n_init = 25L, random_init = TRUE) {
  # create and evaluate initial design
  x = if (random_init) {
    stop("To Implement")
  } else {
    stop("To Implement")
  }
  y = sapply(x, FUN = objective)
  
  # Gaussian process ("kriging") with nugget stability set (more stable) and scaling
  gp = lrn("regr.km", nugget.stability = 1e-4, scaling = TRUE)
  gp$predict_type = "se"  # we need uncertainty estimates
  
  # main BO loop
  while (length(x) <= max_iter) {
    # create a regression task and fit the gp
    task = TaskRegr$new("design", backend = data.table(x = x, y = y), target = "y")
    gp$train(task)

    # partially initialize the acquisition function to work with the optim interface
    acq_fun = function(x) {
      -1 * acquisition(x, model = gp, eta = min(y))  # optim minimizes by default
    }

    # optimize acquisition using random restarts (prevents getting stuck in local optima)
    stop("To Implement")
    # replicate the following with random par values
    # optim(par = ..., fn = acq_fun, lower = lower, upper = upper, method = "L-BFGS-B")
   
    # evaluate next candidate and append
    # x = c(x, x_new)
    # y = c(y, y_new)
  }

  data.table(x = x, y = y)
}

