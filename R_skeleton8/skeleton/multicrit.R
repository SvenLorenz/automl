library(data.table)
library(mlr3)
library(ggplot2)

source("apriori.R")
source("pareto.R")
source("non_dominated.R")
source("crowding.R")
source("hypervolume.R")

# Data
wine = tsk("wine")$data()
metrics2D = wine[, .(malic, flavanoids)]
metrics3D = wine[, .(malic, ash, flavanoids)]

# A-priori weights
apriori(metrics2D, weights = c(1, 0)) == which.min(wine$malic)
apriori(metrics2D, weights = c(0, 1)) == which.min((wine$flavanoids))
w_seq = seq(0, 0.9, by = 0.1)
bests = sapply(w_seq, function(weight) apriori(metrics3D, weights = c(weight, 0.1, 0.9 - weight)))

# A-priori lexicographical order
apriori(metrics2D, order = c(1, 2)) == which.min(wine$malic)
apriori(metrics2D, order = c(2, 1)) == which.min(wine$flavanoids)
apriori(wine[magnesium >= 78, ], order = c(9, 8, 7)) == 68

# Pareto front
metrics2D_plot = copy(metrics2D)
metrics2D_plot[, is_pareto := pareto(metrics2D)]
ggplot(metrics2D_plot, mapping = aes(x = malic, y = flavanoids, colour = is_pareto)) +
  geom_point()

is_pareto_3D = pareto(metrics3D)
all.equal(which(is_pareto_3D), c(59, 76, 113, 138, 141, 145, 146, 165, 170, 171) + 1)

# Non-Dominated Sorting
sort_2d = nDS(metrics2D)
ggplot(sort_2d, aes(x = malic, y = flavanoids, color = front, group = front)) +
  geom_step() +
  geom_point(size = 1)

sort_3d = nDS(metrics3D)

# Crowding Distance
front = metrics2D[pareto(metrics2D), ]
crowdingDist(front)

# Hypervolume
front = metrics2D[pareto(metrics2D),]
ref = t(apply(metrics2D, MARGIN = 2L, FUN = max))
computeHV2D(front, ref = ref)
