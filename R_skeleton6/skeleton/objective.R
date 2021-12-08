# Levy 1D function to minimize
# https://www.sfu.ca/~ssurjano/levy.html
# Global minimum of 0 at 1
# @param x (`double(1)`): domain value in [-10, 10]
# @return (`double(1)`): function value
levy1d = function(x) {
  wi = 1 + (x - 1) / 4
  d = length(x)
  term1 = sin(pi * wi[1L]) ^ 2
  ind = seq(1L, to = d - 1L)
  term2 = sum(
    (wi[ind] - 1) ^ 2 * (1 + 10 * sin(pi * wi[ind] + 1) ^ 2)
  )
  term3 = (wi[d] - 1)^2 * (1 + sin(2 * pi * wi[d]) ^ 2)
  term1 + term2 + term3
}
