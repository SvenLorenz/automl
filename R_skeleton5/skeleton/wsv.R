# Basis function, here just c(1, x)
# @param X (`matrix`): (m x d) matrix of original X values
# @return (`matrix`): ((d + 1) x m) matrix of generated features
phi = function(X) {
  rbind(1, X)
}

# Implementation of 2.11
# @param data (`matrix`): (m x (d + 1)) data on which the model is fit, last column is y
# @param X (`matrix`): (m x d) data to predict the mean and variance
# @param phi (`function`): basis function
# @param sigma_n (`double(1)`): variance for points in data
# @param Sigma_p (`matrix`): (k x k) covariance matrix, k depends on output of `phi`
# @return (`data.table`): mean and variance for all points in `X`
gp_prediction_a = function(data, X, phi = phi, sigma_n, Sigma_p) {
  stop("To Implement")
  data.table(mean = ..., var = ...)
}

