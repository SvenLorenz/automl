The skeleton is structured as follows:

* ea.R: main function to run the EA
* helpers.R: contains two helpers: generate_population and eval_fitness
  eval_fitness relies on an objective, i.e., the ackley function
* hpo.R: basic code to run a grid search on the EA's hyperparameter
* mutate.R: contains mutators to be used in EA
* objective.R: contains the ackley objective and a plot function
* parent_selector.R: contains selectors to be used in EA
* recombinators.R: contains recombinators to be used in EA
