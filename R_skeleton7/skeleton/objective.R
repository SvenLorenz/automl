# Test function to minimize
# Don't take this one to seriously
# @param xdt (`data.table()`): points to evaluate, should contain columns: x in [0, 1] and budget [1, 100]
# @return (`data.table()`): data.table with columns y and rt evaluated for all points in xdt
objective = function(xdt) {
  n = nrow(xdt)
  y = xdt$x + runif(n, min = 0.1, max = 3.0) / xdt$budget
  rt = runif(n, min = 0.001, max = 0.01) * xdt$budget
  data.table(y = y, rt = rt)
}
