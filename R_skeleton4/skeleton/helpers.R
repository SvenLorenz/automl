# Generate an initial population by sampling uniformly at random
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @param pop_size (`integer(1)`): population size
# @param x_ids (`character()`): names of x
# @return (`data.table()`): initial population
generate_population = function(lower, upper, pop_size, x_ids) {
  stop("To Implement")
}

# Evaluate an objective function on a population
# @param population (`data.table()`): population
# @param x_ids (`character()`): names of x
# @param objective (`function(xdt)`): single-criteria objective function
# @return (`data.table()`): population with y values added as column
eval_fitness = function(population, x_ids, objective) {
  stop("To Implement")
}

