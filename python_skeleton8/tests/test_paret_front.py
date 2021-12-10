import unittest
import logging
from sklearn.datasets import load_wine
import numpy as np

from master_solution.pareto import pareto, nDS, crowdingDist, computeHV2D


class TestParetoFront(unittest.TestCase):

    def setUp(self):  # This Method is executed once before each test
        logging.basicConfig(level=logging.DEBUG)
        wine = load_wine()
        X = wine['data']  # 1, 2, 6 as features
        # metric contains "malic acid", "ash", "nonflavanoid phenols"
        self.metrics2D = X[:, [1, 6]]
        self.metrics3D = X[:, [1, 2, 6]]

    def test_2D(self):
        # Simple test for pareto front
        true_indices = [59, 113, 138, 141, 146, 165, 170, 171]
        pareto_front = pareto(self.metrics2D)
        self.assertListEqual(np.argwhere(pareto_front).flatten().tolist(), true_indices)

    def test_3D(self):
        # Simple test for pareto front
        true_indices = [59, 76, 113, 138, 141, 145, 146, 165, 170, 171]
        pareto_front = pareto(self.metrics3D)
        self.assertListEqual(np.argwhere(pareto_front).flatten().tolist(), true_indices)

    def test_NDS_2D(self):
        # Test the non-dominating sorting method
        true_indices = self.metrics2D[[59, 113, 138, 141, 146, 165, 170, 171]].tolist()
        fronts = nDS(self.metrics2D)
        self.assertListEqual(fronts[0].tolist(), true_indices)  # the first front should be the pareto front
        self.assertListEqual(fronts[-1].tolist(), [[2.05, 5.08]])  # last is only a single point

    def test_NDS_3D(self):
        # Test the non-dominating sorting method in 3D
        true_indices = self.metrics3D[[59, 76, 113, 138, 141, 145, 146, 165, 170, 171]].tolist()
        fronts = nDS(self.metrics3D)
        self.assertListEqual(fronts[0].tolist(), true_indices)  # the first front should be the pareto front
        self.assertListEqual(fronts[-1].tolist(), [[2.05, 3.23, 5.08]])  # last is only a single point

    def test_CD_2D(self):
        # Test the crowding distance method
        front = self.metrics2D[[59, 113, 138, 141, 146, 165, 170, 171]]
        sfront = self.metrics2D[[113, 59, 171, 141, 170, 138, 165, 146]]
        sorted_front, distances = crowdingDist(front)
        print(distances)
        self.assertListEqual(sorted_front.tolist(), sfront.tolist())
        self.assertTrue(np.allclose(distances,
                                    [np.inf, 1.20264686, 0.37910368, 0.14945202,
                                     0.23983638, 0.30954001, 0.3554306, np.inf]))

    def test_HV_2D(self):
        # test the hypervolume computation
        sfront = self.metrics2D[[59, 113, 138, 141, 146, 165, 170, 171]]
        # Compute the volume when the reference point is the the largest value from the data
        volume = computeHV2D(sfront, [np.max(self.metrics2D[:, 0]), np.max(self.metrics2D[:, 1])])
        self.assertAlmostEqual(volume, 22.9, 1)

    def test_HV_2DB(self):
        # test if hypervolume gets smaller and smaller the more dominated a front is
        fronts = nDS(self.metrics2D)
        prev = np.inf
        for sfront in fronts[:1]:
            vol = computeHV2D(sfront, [np.max(self.metrics2D[:, 0]), np.max(self.metrics2D[:, 1])])
            print(prev, vol)
            self.assertTrue(prev >= vol)
            prev = vol


if __name__ == '__main__':
    unittest.main()
