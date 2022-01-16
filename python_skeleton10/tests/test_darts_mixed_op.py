import os
import unittest

import matplotlib
import numpy as np
import torch
from src.model_search import PRIMITIVES, MixedOp
from torch.autograd import Variable

print('\nWORKING_DIR', os.getcwd())
print('\nPYTHONPATH', os.environ['PYTHONPATH'])

matplotlib.use('Agg')


class TestDARTS(unittest.TestCase):

    def test_ex1_a_mixed_op(self):
        """
        Test your implementation of the mixed-op
        """
        # Seed the environment
        np.random.seed(0)
        torch.manual_seed(0)
        num_ops = len(PRIMITIVES)

        # Create an example mixed op
        mixed_op = MixedOp(C=2, stride=1)
        alphas = Variable(1e-3 * torch.randn(1, num_ops), requires_grad=True)

        # Run the mixed op
        input_example = torch.randn(size=(1, 2, 2, 2))
        output_example = mixed_op(input_example, alphas)

        output_agg = torch.sum(output_example).detach().numpy()
        self.assertTrue(np.isclose(output_agg, 1.9001899, rtol=1e-2))


if __name__ == '__main__':
    unittest.main()
