# Uniform mutation, replace one random value with runif
# @param parent (`data.table()`): data.table with one row holding the parent
# @param x_ids (`character()`): names of x
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @return (`data.table()`): data.table with mutated parent
mutate_uniform = function(parent, x_ids, lower, upper) {
  stop("To Implement")
}

# Gaussian mutation, x + rnorm, runif if out of bounds
# @param parent (`data.table()`): data.table with one row holding the parent
# @param x_ids (`character()`): names of x
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @param sigma (`double(1)`): standard deviation of the Gaussian
# @return (`data.table()`): data.table with mutated parent
mutate_gaussian = function(parent, x_ids, lower, upper, sigma = 1) {
  stop("To Implement")
}

# No mutation
# @param parent (`data.table()`): data.table with one row holding the parent
# @param x_ids (`character()`): names of x
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @return (`data.table()`): data.table with mutated parent
mutate_none = function(parent, x_ids, lower, upper) {
  stop("To Implement")
}

