import pickle
import unittest

import matplotlib
import numpy as np


class TestNB101(unittest.TestCase):
    def setUp(self):
        # Load the student's data
        self.results = pickle.load(open("python_skeleton9/src/logs/results.obj", "rb"))


class TestRE(TestNB101):
    def test_re(self):
        # Test RE results
        re_results = np.array(self.results["re"])
        final_mean, final_std = np.mean(re_results[:, -1]), np.std(re_results[:, -1])
        # Check that the re result lies within one standard deviation of the expected value
        self.assertTrue(
            0.05954026579856873 - 0.002533369563780998
            < final_mean
            < 0.05954026579856873 + 0.002533369563780998
        )


class TestNonRE(TestNB101):
    def test_non_re(self):
        # Test Non-RE results
        non_re_results = np.array(self.results["non_re"])
        final_mean, final_std = (
            np.mean(non_re_results[:, -1]),
            np.std(non_re_results[:, -1]),
        )
        # Check that the re result lies within one standard deviation of the expected value
        self.assertTrue(
            0.058563700318336485 - 0.0028880384844857847
            < final_mean
            < 0.058563700318336485 + 0.0028880384844857847
        )


class TestRS(TestNB101):
    def test_rs(self):
        # Test RS results
        rs_results = np.array(self.results["rs"])
        final_mean, final_std = np.mean(rs_results[:, -1]), np.std(rs_results[:, -1])
        # Check that the re result lies within one standard deviation of the expected value
        self.assertTrue(
            0.05908454656600952 - 0.0020750128579245424
            < final_mean
            < 0.05908454656600952 + 0.0020750128579245424
        )


if __name__ == "__main__":
    unittest.main()
