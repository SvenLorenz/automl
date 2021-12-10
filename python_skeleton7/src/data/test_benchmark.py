import ConfigSpace
import numpy as np

from data.problem import Problem


class TestBenchmark(Problem):
    def __init__(self, seed, *args, **kwargs):
        super().__init__()
        self.seed = seed
        np.random.seed(seed)
        self.rng = np.random.RandomState(seed)

        self.X = []
        self.y = []
        self.c = []

    def objective_function(self, config, budget):
        # 'Evaluate' the function
        y = np.random.uniform(0.1, 3.0) / budget
        # 'Estimate' the runtime
        rt = np.random.uniform(0.001, 0.01) * budget

        self.X.append(config)
        self.y.append(y)
        self.c.append(rt)
        return y, rt

    def get_results(self):
        regret_validation = []
        runtime = []
        rt = 0

        inc_valid = np.inf

        for i in range(len(self.X)):

            if inc_valid > self.y[i]:
                inc_valid = self.y[i]

            regret_validation.append(float(inc_valid))
            rt += self.c[i]
            runtime.append(float(rt))

        res = dict()
        res['regret_validation'] = regret_validation
        res['runtime'] = runtime

        return res

    @staticmethod
    def get_configuration_space():
        cs = ConfigSpace.ConfigurationSpace()

        cs.add_hyperparameter(ConfigSpace.OrdinalHyperparameter("hyp_1", [16, 32, 64, 128, 256, 512]))
        cs.add_hyperparameter(ConfigSpace.OrdinalHyperparameter("hyp_2", [16, 32, 64, 128, 256, 512]))
        return cs
