# Select parents random / neutral
# @param population (`data.table()`): population
# @param num_children (`integer(1)`): number of children to select
# @return (`data.table()`): data.table of selected parents
select_parents_neutral = function(population, num_children = 10L) {
  stop("To Implement")
}

# Select parents based on their fitness
# @param population (`data.table()`): population
# @param num_children (`integer(1)`): number of children to select
# @return (`data.table()`): data.table of selected parents
select_parents_fitness = function(population, num_children = 10L) {
  stop("To Implement")
}

# Selection via tournament
# @param population (`data.table()`): population
# @param num_children (`integer(1)`): number of children to select
# @param tournament_size (`integer(1)`): size of the tournament, i.e., how many parents compete
# @return (`data.table()`): data.table of selected parents
select_parents_tournament = function(population, num_children = 10L, tournament_size = 3L) {
  stop("To Implement")
}

