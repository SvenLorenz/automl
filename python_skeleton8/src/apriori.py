from typing import Optional
import numpy as np
import copy


def apriori(costs: np.ndarray, weights: Optional = None, order: Optional = None):
    """
    Implement the two example apriori methods presented in the lecture
    Parameters
    ----------
    costs   (n_points, m_costs) array
    weights (m_costs, ) array. Determines the weighting of the costs. If None use lexical ordering
    order   (m_costs, ) array. Determines the lexicograpical order. If None use weighted sum

    Returns
    -------
    Index of optimal element according to apriori method
    """
    if weights is not None and order is not None:
        raise Exception('You can only specify weight or order but not both')
    if weights:
        cost = np.dot(costs, weights)
        arg = np.argmin(cost)
    if order:
        order = np.array(order)
        costs_temp = copy.copy(costs)
        arg = np.arange(costs.shape[0])
        for ord in order:
            arg = np.argmin(costs_temp[:,ord])
            costs_temp[~np.isin(np.arange(costs_temp.shape[0]), arg),:] = np.Inf
        
    return arg
