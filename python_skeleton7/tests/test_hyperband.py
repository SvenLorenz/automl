import json
import os
import unittest

import matplotlib
import numpy as np

from src.data.test_benchmark import TestBenchmark
from src.hyperband import hyperband

matplotlib.use('Agg')


class TestSuccessiveHalving(unittest.TestCase):

    def test_expected_result(self):
        problem = TestBenchmark(seed=0)
        configs_dicts = hyperband(problem=problem, eta=2, random_seed=0, max_budget_per_model=100,
                                  min_budget_per_model=2)
        res = problem.get_results()
        test_sh_data = json.load(open('tests/data/test_hb_data.json', 'r'))
        self.assertTrue(np.allclose(res['regret_validation'], test_sh_data))


if __name__ == '__main__':
    unittest.main()
