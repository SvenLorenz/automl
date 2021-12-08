# Kernel function
# @param x_1 (`matrix`): (m x d) matrix of points
# @param x_2 (`matrix`): (n x d) matrix of points
# @param l (`double(1)`): length scale
# @param sigma_f (`double(1)`): variance
# @param `matrix()`): m x n matrix of kernel values
kernel_se = function(x_1, x_2, l, sigma_f) {
  stop("To Implement")
}

# Kernelized 2.12
# @param data (`matrix`): (m x (d + 1)) data on which the model is fit, last column is y
# @param X (`matrix`): (m x d) data to predict the mean and variance
# @param l (`double(1)`): length scale
# @param sigma_n (`double(1)`): variance for points in data
# @param Sigma_p (`matrix`): (k x k) covariance matrix, k depends on features
# @return (`data.table`): mean and variance for all points in `X`
gp_prediction_b_kernel = function(data, X, l, sigma_n, sigma_f) {
  stop("To Implement")
  data.table(mean = ..., var = ...)
}

# Function to generate a negative log likelihood function based on observed data
# @param data (`matrix`): (m x (d + 1)) observed data, last column is y
# @return (`function`): negative log likelihood function depending on `theta`
#   `theta` is `l` (length scale), `sigma_f` (variance), `sigma_n` (variance for points in data)
negative_log_likelihood = function(data) {
  X_train = data[, - ncol(data), drop = FALSE]
  Y_train = data[, ncol(data), drop = TRUE]

  nll = function(theta) {
    l = theta[1L]
    sigma_f = theta[2L]
    sigma_n = theta[3L]
    K_y = kernel_se(X_train, X_train, l = l, sigma_f = sigma_f) + sigma_n ^ 2 * diag(nrow(X_train))
    L = chol.default(K_y)
    stop("To Implement")
    # ...
  }

  nll
}

