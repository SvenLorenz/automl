import numpy as np
import copy

def pareto(costs: np.ndarray):
    """
    Find the pareto-optimal points
    :param costs: (n_points, m_cost_values) array
    :return: (n_points, 1) boolean array indicating if point is on pareto front or not.
    """
    # first assume all points are pareto optimal
    is_pareto = np.ones(costs.shape[0], dtype=bool)
    # Stepwise eliminate all elements that are dominated by any other point
    costs_logical = np.zeros((costs.shape[0], costs.shape[1], costs.shape[0]-1), dtype=bool)
    for i in range(len(is_pareto)):
        for j in range(costs.shape[1]):
            costs_logical[i,j,:] = costs[i,j] >= np.delete(costs[:,j], i)
        is_pareto[i] = np.logical_not(np.any(np.sum(costs_logical[i,:,:], axis=0) == costs.shape[1]))
    return is_pareto


def nDS(costs):
    """
    Implementation of the non-dominated sorting method
    :param costs: (n_points, m_cost_values) array
    :return: list of all fronts
    """
    costs_remaining = copy.copy(costs)
    fronts = []
    while len(costs_remaining) > 0:
        curr_pareto = pareto(costs_remaining)
        fronts.append(costs_remaining[curr_pareto,:])
        costs_remaining = np.delete(costs_remaining, np.where(curr_pareto), axis=0)
    return fronts


def crowdingDist(front):
    """
    Implementation of the crowding distance
    :param front: (n_points, m_cost_values) array
    :return: sorted_front and corresponding distance value of each element in the sorted_front
    """
    # TODO
    # first sort the front (first sort the first column then the second, third, ...)
    sorted_front = front[np.argsort(front[:,0]),:]
    
    # TODO
    # on the sorted front compute the distance of all points to its neighbors
    dists = np.array([np.abs((sorted_front[i,:] - sorted_front[i+1,:])) for i in range(len(sorted_front)-1)])
    dists = np.sum(dists, axis=1)
    dists /= np.max(dists) - np.min(sorted_front)
    dists[[0,-1]] = np.Inf
    
    return sorted_front, dists


def computeHV2D(front, ref):
    """
    Compute the Hypervolume for the pareto front  (only implement it for 2D)
    :param front: (n_points, m_cost_values) array for which to compute the volume
    :param ref: coordinates of the reference point
    :returns: Hypervolume of the polygon spanned by all points in the front + the reference point
    """
    # TODO
    # sort front to get "outline" of polygon (don't forget to add the reference point to that outline)
    sorted_front, _ = crowdingDist(np.vstack((front, ref)))
    # TODO
    # You can use the shoelace formula to compute area as we constrain ourselves to 2D
    # (https://en.wikipedia.org/wiki/Shoelace_formula)
    x = sorted_front[:,0]
    y = sorted_front[:,1]
    n = len(x)
    shoelace = 0.5*np.abs(np.sum(x[0:n-1] * y[1:n]) + x[n-1] * y[0] - np.sum(x[1:n] * y[0:n-1]) - x[0] * y[n-1])
    return shoelace


if __name__ == '__main__':
    # We prepared some plotting code for you to check your pareto front implementation and the non-dominating sorting
    from sklearn.datasets import load_boston, load_wine
    from matplotlib import pyplot as plt
    import seaborn as sb
    sb.set_style('darkgrid')

    wine = load_wine()
    X = wine['data']  # 1, 2, 6 as features
    # metric contains "malic acid", "ash", "nonflavanoid phenols"
    costs2D = X[:, [1, 2]]
    costs3D = X[:, [1, 2, 6]]

    plt.scatter(costs2D[:, 0], costs2D[:, 1])
    pareto_front = costs2D[pareto(costs2D)]

    # sort for plotting
    pareto_front = np.sort(pareto_front.view([('', pareto_front.dtype)] * pareto_front.shape[1]),
                           order=['f1'],  # order by first element then second and so on
                           axis=0).view(np.float)
    plt.scatter(pareto_front[:, 0], pareto_front[:, 1], marker='.', c='orange')
    plt.plot(pareto_front[:, 0], pareto_front[:, 1], marker='.', c='orange')
    plt.title('Pareto Front on partial Wine Dataset')
    plt.xlabel('malic acid')
    plt.ylabel('ash')
    plt.show()

    # metric contains malic acid and nonflavoid phenoms
    costs2D = X[:, [1, 6]]

    plt.scatter(costs2D[:, 0], costs2D[:, 1])

    fronts = nDS(costs2D)
    for pareto_front in fronts:
        # sort for plotting
        pareto_front = np.sort(pareto_front.view([('', pareto_front.dtype)] * pareto_front.shape[1]),
                               order=['f1'],  # order by first element then second and so on
                               axis=0).view(np.float)
        plt.plot(pareto_front[:, 0], pareto_front[:, 1], marker='.')
    plt.title('Pareto Front on partial Wine Dataset')
    plt.xlabel('malic acid')
    plt.ylabel('nonflavanoid phenols')
    plt.show()

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    xs = costs3D[:, 0]
    ys = costs3D[:, 1]
    zs = costs3D[:, 2]
    pareto_front = pareto(costs3D)

    ax.scatter(xs, ys, zs)
    ax.scatter(xs[pareto_front], ys[pareto_front], zs[pareto_front], c='orange', marker='X', alpha=1)
    ax.set_xlabel('malic acid')
    ax.set_ylabel('ash')
    ax.set_zlabel('nonflavanoid phenols')
    ax.view_init(10, -15)
    plt.show()
