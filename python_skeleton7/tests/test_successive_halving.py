import json
import os
import unittest

print('\nWORKING_DIR', os.getcwd())
print('\nPYTHONPATH', os.environ['PYTHONPATH'])
import matplotlib
import numpy as np

from src.data.test_benchmark import TestBenchmark
from src.successive_halving import successive_halving

matplotlib.use('Agg')


class TestSuccessiveHalving(unittest.TestCase):

    def test_expected_result(self):
        problem = TestBenchmark(seed=0)
        configs_dict = successive_halving(problem=problem, n_models=40, eta=2, random_seed=0, max_budget_per_model=100,
                                          min_budget_per_model=10)
        res = problem.get_results()
        test_sh_data = json.load(open('tests/data/test_sh_data.json', 'r'))
        self.assertTrue(np.allclose(res['regret_validation'], test_sh_data))


if __name__ == '__main__':
    unittest.main()
