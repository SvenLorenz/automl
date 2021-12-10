# Implementation of the crowding distance
# @param front (`data.table()`): data.table of dimension (n_points, m_costs)
# @return (`list()`): `sorted_front`: `data.table()` of dimension (n_points, m_costs)
#                     `dists`: `double()` of dimension (n_points) with corresponding distance values
crowdingDist = function(front) {
  mfront = as.matrix(front)
  sorted_front = as.matrix(setorder(copy(front)))

  normalized_front = sorted_front

  stop("To Implement")

  list(sorted_front = sorted_front, dists = dists)
}

