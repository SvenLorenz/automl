library(data.table)
library(ggplot2)

source("wsv.R")  # weight space view
source("fsv.R")  # function space view
source("runtime.R") # code for runtime comparison
source("mll.R") # code for optimizing MLL

# data
x = seq(0, to = 2 * pi, length.out = 64L)
train_data = cbind(x = x, y = sin(x) + 0.1 * cos(10 * x))

# weight space view 2.11
preds_a = gp_prediction_a(train_data, X = train_data[, 1L], phi = phi, sigma_n = 1.0, Sigma_p = diag(2L))

preds_a_plot = copy(preds_a)
preds_a_plot[, x := x]  # add x for easy plotting
ggplot() +
  geom_point(aes(x = x, y = y), data = as.data.table(train_data)) +
  geom_line(aes(x = x, y = mean), data = preds_a_plot) +
  geom_line(aes(x = x, y = mean + 2 * sqrt(var)), data = preds_a_plot, lty = 2) +
  geom_line(aes(x = x, y = mean - 2 * sqrt(var)), data = preds_a_plot, lty = 2)

# function space view 2.12
preds_b = gp_prediction_b(train_data, X = train_data[, 1L], phi = phi, sigma_n = 1.0, Sigma_p = diag(2L))

# identical predictions
all.equal(preds_a, preds_b)

# runtime comparison
ns = 2^(1:12)
times = compare_runtimes(ns, data = train_data, X = train_data[, 1L])
ggplot(times, mapping = aes(x = n, y = a - b)) +
  geom_point() +
  geom_line()

# MLL
# Data, initial prediction and negative log likelihood
set.seed(666)
n_train = 9L
x = runif(n_train, min = 0, max = 2 * pi)
train_data = cbind(x = x, y = sin(x) + 0.5 * runif(n_train, min = 0, max = 1))
X = seq(0, 2 * pi, length.out = 128L)
l_init = 0.2
sigma_f_init = 0.7
sigma_n_init = 1.0
pred_init = gp_prediction_b_kernel(train_data, X = X, l = l_init, sigma_n = sigma_n_init, sigma_f = sigma_f_init)
nll = negative_log_likelihood(train_data)
nll(theta = c(l_init, sigma_n_init, sigma_f_init))

# optimize negative log likelihood using optim and predict
optres = optim(c(l_init, sigma_n_init, sigma_f_init), fn = nll)
l_opt = optres$par[1L]
sigma_f_opt = optres$par[2L]
sigma_n_opt = optres$par[3L]
pred_opt = gp_prediction_b_kernel(train_data, X = X, l = l_opt, sigma_n = sigma_n_opt, sigma_f = sigma_f_opt)

# visualize
train_data_plot = as.data.table(train_data)
pred_plot = copy(pred_init)
pred_init_plot = copy(pred_init)
pred_opt_plot = copy(pred_opt)
pred_init_plot[, x := X]
pred_opt_plot[, x := X]
ggplot() +
  geom_point(aes(x = x, y = y), data = train_data_plot) +
  geom_line(aes(x = x, y = mean), data = pred_init_plot) +
  geom_ribbon(aes(x = x, ymin = mean - sqrt(var), ymax = mean + sqrt(var)),
    alpha = 0.5, data = pred_init_plot) +
  geom_line(aes(x = x, y = mean), data = pred_opt_plot, color = "darkgreen") +
  geom_ribbon(aes(x = x, ymin = mean - sqrt(var), ymax = mean + sqrt(var)),
    color = NA, fill = "darkgreen", alpha = 0.5, data = pred_opt_plot)

