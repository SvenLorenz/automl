# Compute the Hypervolume for the pareto front (only implement it for 2D)
# @param front (`data.table()`): data.table of dimension (n_points, 2)
# @param ref (`matrix()`): coordinates of the reference point in the form of a matrix of dimension (1, 2)
# @return (`double(1)`): Hypervolume of the polygon spanned by all points in the front + the reference point
computeHV2D = function(front, ref) {
  mfront = as.matrix(front)
  # sort all points
  sorted_front = as.matrix(setorder(copy(front)))
  # add reference point
  sorted_front = rbind(sorted_front, ref)
  # add intermediate points
  stop("To Implement")
  # use shoelace to compute area as we constrain ourselves to 2D (https://en.wikipedia.org/wiki/Shoelace_formula)
  as.vector(hpv)
}
