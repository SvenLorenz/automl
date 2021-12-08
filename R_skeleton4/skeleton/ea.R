# Minimize an objective function with an EA
# @param objective (`function(xdt)`): single-criteria objective function
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @param pop_size (`integer(1)`): population size
# @param n_evals (`integer(1)`): total number of function evaluations
# @param frac_mutants (`double(1)`): fraction of mutations
# @param select_parents (`function(population, num_children, ...)`): function for selecting parents
# @param mutate (`function(parent, x_ids, lower, upper, ...)`): function for mutation
# @param recombine (`function(parent, partner, x_ids, lower, upper, ...)`): function for recombination
# @return (`data.table()`): trajectory of the optimization
ea = function(objective, lower, upper, pop_size = 20L, n_evals,
              frac_mutants = 0.5, select_parents = select_parents_fitness, mutate = mutate_uniform,
              recombine = recombine_intermediate) {
  gen = 0L  # we start with generation 0
  x_ids = paste0("x", seq_along(lower))  # names for x: x1, x2, ...
  trajectory = data.table()  # stores evaluated values as an archive
  population = generate_population(lower, upper, pop_size, x_ids)  # generate the initial population
  population = eval_fitness(population, x_ids, objective)  # evaluate the initial population
  population[, gen := gen]  # specify that this is generation 0
  trajectory = rbind(trajectory, population, fill = TRUE)  # add population to the trajectory

  while (nrow(trajectory) <= n_evals) {
    gen = gen + 1L  # next generation
    stop("To Implement")
    # parents = select_parents(...)
    # childern = either mutate(...) or recombine(...) based on frac_mutants probability
    # population = add children and trim the population
    # trajectory = add population with updated gen value to the trajectory
  }

  trajectory
}

