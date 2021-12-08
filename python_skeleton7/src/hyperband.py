import numpy as np
from tqdm import tqdm

from src.data.fcnet_benchmark import FCNetProteinStructureBenchmark
from src.successive_halving import successive_halving
from src.utils import plot_grey_box_optimization


def hyperband(problem, min_budget_per_model, max_budget_per_model, eta, random_seed):
    """ The hyperband algorithm

    Parameters
    ----------
    problem : instance of Problem
    min_budget_per_model : int
    max_budget_per_model : int
    eta : float
    random_seed : int

    Returns
    -------

    """
    # Todo: Compute s_max
    # s_max =
    raise NotImplementedError()
    configs_dicts = []
    for s in tqdm(reversed(range(s_max + 1)), desc='Hyperband iter'):
        # Todo: Compute the number of models to evaluate in the HB iteration
        # n_models = ...
        raise NotImplementedError()
        # Todo: Compute the min budget per model in the current HB iteration
        # min_budget_per_model_iter = ...
        raise NotImplementedError()

        configs_dict = successive_halving(problem=problem, n_models=n_models,
                                          min_budget_per_model=min_budget_per_model_iter,
                                          max_budget_per_model=max_budget_per_model, eta=eta, random_seed=random_seed)
        configs_dicts.append(configs_dict)

    return configs_dicts


if __name__ == '__main__':
    problem = FCNetProteinStructureBenchmark(data_dir="data/fcnet_tabular_benchmarks/")
    configs_dicts = hyperband(problem=problem, eta=2, random_seed=0, max_budget_per_model=100,
                              min_budget_per_model=2)
    plot_grey_box_optimization(configs_dicts, min_budget_per_model=2)
