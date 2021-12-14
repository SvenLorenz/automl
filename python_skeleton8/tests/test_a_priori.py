import unittest
import logging
from sklearn.datasets import load_wine
import numpy as np

from src.apriori import apriori


class TestAPriori(unittest.TestCase):

    def setUp(self):  # This Method is executed once before each test
        logging.basicConfig(level=logging.DEBUG)
        wine = load_wine()
        X = wine['data']  # 1, 2, 6 as features
        # metric contains "malic acid", "ash", "nonflavanoid phenols"
        self.metrics2D = X[:, [1, 6]]
        self.metrics3D = X[:, [1, 2, 6]]
        self.X = X

    def test_weighted_sum(self):
        elem_idA = apriori(self.metrics2D, weights=[0, 1])
        self.assertEqual(elem_idA, np.argmin(self.X[:, 6]))
        elem_idB = apriori(self.metrics2D, weights=[1, 0])
        self.assertTrue(elem_idB, np.argmin(self.X[:, 1]))
        self.assertNotEqual(elem_idA, elem_idB)

    def test_weighted_sum_full(self):
        elem_idA = apriori(self.X, weights=[0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0])
        self.assertEqual(elem_idA, np.argmin(self.X[:, 5]))
        elem_idB = apriori(self.X, weights=[0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0])
        self.assertEqual(elem_idB, np.argmin(self.X[:, 8]))
        self.assertNotEqual(elem_idA, elem_idB)
        elem_idC = apriori(self.X, weights=[0.1, 0.1, 0.2, 0.3, 0, 0, 0, 0, .3, 0, 0, 0, 0])
        self.assertEqual(elem_idC, 59)
        self.assertNotEqual(elem_idA, elem_idC)

    def test_lexicographical(self):
        elem_idA = apriori(self.metrics2D, order=[0, 1])
        self.assertEqual(elem_idA, np.argmin(self.X[:, 1]))
        elem_idB = apriori(self.metrics2D, order=[1, 0])
        self.assertEqual(elem_idB, np.argmin(self.X[:, 6]))
        self.assertNotEqual(elem_idA, elem_idB)

    def test_lexicographical_full(self):
        elem_idA = apriori(self.X, order=[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
        self.assertEqual(elem_idA, np.argmin(self.X[:, 0]))
        elem_idB = apriori(self.X, order=[12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0])
        self.assertEqual(elem_idB, np.argmin(self.X[:, -1]))
        self.assertNotEqual(elem_idA, elem_idB)
        elem_idC = apriori(self.X, order=[7, 6, 5, 4, 12, 11, 10, 9, 8, 3, 2, 1, 0])
        self.assertEqual(elem_idC, np.argmin(self.X[:, 7]))
        self.assertNotEqual(elem_idA, elem_idC)


if __name__ == '__main__':
    unittest.main()
