import unittest

import matplotlib
import numpy as np
from sklearn.gaussian_process import GaussianProcessRegressor as GPR
from sklearn.gaussian_process.kernels import Matern
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from src.main import f, EI

matplotlib.use('Agg')


class TestExpectedImprovement(unittest.TestCase):

    def test_expected_improvement(self):
        """
        Test that expected improvement yields the expected result
        """
        np.random.seed(0)
        x = np.linspace(-15, 10, 10).reshape(-1, 1)
        y = [f([i, ]) for i in x]
        gp = Pipeline([["standardize", StandardScaler()],
                       ["GP", GPR(kernel=Matern(nu=2.5), alpha=1.e-4, normalize_y=True, n_restarts_optimizer=10)],
                       ])
        gp.fit(x, y)  # fit the model

        x_axis = np.linspace(-15, 10, 10)

        ei = np.array([EI(i, gp, min(y)) for i in x_axis]).flatten()
        self.assertTrue(
            np.allclose(ei.tolist(), [-0.0, -0.0, -0.0, -0.0, -0.0, -2.53433968e-51, -2.64141079e-02, -8.07334916e-59,
                                      -0.0, -0.0]))

if __name__ == '__main__':
    unittest.main()
