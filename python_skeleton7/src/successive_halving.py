import numpy as np
import json

from data.fcnet_benchmark import FCNetProteinStructureBenchmark
from utils import plot_grey_box_optimization
from data.test_benchmark import TestBenchmark

def successive_halving(problem, n_models, min_budget_per_model, max_budget_per_model, eta, random_seed):
    """
    The successive halving algorithm, called as subroutine in hyperband.
    :param problem: An instance of problem
    :param n_models: int;  The number of configs to evaluate
    :param min_budget_per_model: int
    :param max_budget_per_model: int
    :param eta: float
    :param random_seed: int
    :return:
    """
    np.random.seed(random_seed)
    configs_dict = {i: {'config': problem.get_configuration_space().sample_configuration(),
                        'f_evals': {}} for i in range(n_models)}

    configs_to_eval = list(range(n_models))
    b = np.int(min_budget_per_model)
    while b <= max_budget_per_model:
        # Evaluate the configs selected for this budget
        for config_id in configs_to_eval:
            configs_dict[config_id]['f_evals'][b] = problem.objective_function(configs_dict[config_id]['config'],
                                                                               budget=b)
        # Todo: Compute number of configs to proceed to next higher budget
        num_configs_to_proceed = int(len(configs_dict) / eta)
        

        # Todo: Select the configs from the configs_dict which have been evaluated on the current budget b
        eval_configs_curr_budget = np.argsort([configs_dict[i]['f_evals'][b][0] for i in configs_to_eval])

        # Todo: Out of these configs select the ones to proceed to the next higher budget and assign this
        # list to configs_to_eval
        configs_to_eval = eval_configs_curr_budget[eval_configs_curr_budget < num_configs_to_proceed]

        # Todo: Increase the budget for the next SH iteration.
        b = int(np.round(b * eta))
        
    return configs_dict


if __name__ == '__main__':
    problem = FCNetProteinStructureBenchmark(data_dir="python_skeleton7/src/data/fcnet_tabular_benchmarks/")
    configs_dict = successive_halving(problem=problem, n_models=40, eta=2, random_seed=0, max_budget_per_model=100,
                                      min_budget_per_model=10)
    plot_grey_box_optimization([configs_dict], min_budget_per_model=10)

    
    problem = TestBenchmark(seed=0)
    configs_dict = successive_halving(problem=problem, n_models=40, eta=2, random_seed=0, max_budget_per_model=100,
                                  min_budget_per_model=10)
    res = problem.get_results()
    test_sh_data = json.load(open('python_skeleton7/tests/data/test_sh_data.json', 'r'))
    np.allclose(res['regret_validation'], test_sh_data)