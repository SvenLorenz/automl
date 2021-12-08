import unittest

import matplotlib
import numpy as np
from sklearn.gaussian_process import GaussianProcessRegressor as GPR
from sklearn.gaussian_process.kernels import Matern
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from src.main import f, LCB

matplotlib.use('Agg')


class TestLowerConfidenceBound(unittest.TestCase):

    def test_lower_confidence_bound(self):
        """
        Test lower confidence bound.
        """
        np.random.seed(0)
        x = np.linspace(-15, 10, 10).reshape(-1, 1)
        y = [f([i, ]) for i in x]
        gp = Pipeline([["standardize", StandardScaler()],
                      ["GP", GPR(kernel=Matern(nu=2.5), alpha=1.e-4, normalize_y=True, n_restarts_optimizer=10)],
                      ])
        gp.fit(x, y)  # fit the model

        x_axis = np.linspace(-15, 10, 10)

        lcb = np.array([LCB(i, gp, min(y), 1) for i in x_axis]).flatten()
        self.assertTrue(
            np.allclose(lcb.tolist(), [15.93409352, 21.17581312, 10.4529669 ,  4.59195362,  3.28877953,
                                       1.21268212,  0.23226244,  1.28790492,  3.6071361, 10.55681337]))


if __name__ == '__main__':
    unittest.main()
