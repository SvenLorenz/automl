import os
import unittest

import matplotlib
import numpy as np

from src.main import run_random_search, run_grid_search

matplotlib.use('Agg')


class TestRandomGridSearch(unittest.TestCase):

    def test_random_search(self):
        """
        Test random search
        """
        n_samples = 100000
        random_samples = run_random_search(n_samples)

        # Check that all samples lie in the correct interval
        binned_random_samples = np.digitize(random_samples, [0, 30])
        self.assertTrue(np.sum(binned_random_samples == 1), n_samples)

    def test_grid_search(self):
        """
        Test upper confidence bound.
        """
        n_samples = 100000
        grid_samples = run_grid_search(n_samples)

        # Check that you all samples lie in the correct interval
        binned_grid_samples = np.digitize(grid_samples, [0, 30])
        self.assertTrue(np.sum(binned_grid_samples == 1), n_samples)


if __name__ == '__main__':
    unittest.main()
