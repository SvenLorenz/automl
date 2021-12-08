# Ackley objective function
# https://www.sfu.ca/~ssurjano/ackley.html
# @param xdt (`data.table()`): data.table with points as rows
# @return (`data.table()`): data.table with one column y being the ackley function evaluated row-wise at xdt
ackley = function(xdt) {
  d = ncol(xdt)
  a = 20
  b = 0.2
  c = 2 * pi
  y = - a * exp(- b * sqrt((1 / d) *  rowSums(xdt ^ 2))) -
    exp((1 / d) * rowSums(cos(c * xdt))) + a + exp(1)
  data.table(y = y)
}

# plot 2d Ackley objective function
# @param xdt (`data.table()`): data.table with points as rows
# @return (`ggplot`): plot of the 2d Ackley function
plot_ackley = function(resolution = 1000) {

  dimensionality = 2  # 2d problem

  # Upper and lower bounds
  upper = rep(32.768, dimensionality)
  lower = -upper

  xdt = setDT(expand.grid(x1 = seq(lower[1L], upper[1L], length.out = resolution),
                          x2 = seq(lower[2L], upper[2L], length.out = resolution)))
  xdt[, y := ackley(xdt)]
  ggplot(data = xdt, aes(x1, x2, z = y)) +
    geom_contour_filled()
}

