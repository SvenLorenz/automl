from collections import defaultdict
from typing import List, Tuple, Dict

# TODO load a regressor from sklearn to solve exercise 2
# TODO load a classifier from sklearn to solve exercise 3

import numpy as np
import pandas as pd


def get_stats(aslib_data: List, cutoff: float, par: int = 10) -> (float, float):
    """
    Simple method to determine Virtual best and Single best performance.
    Expects input data in the ASLib data format.
    :param aslib_data: List of ASlib data.
                       Entries are as follows:
                       [('instance_id', 'STRING'),
                        ('repetition', 'NUMERIC'),
                        ('algorithm', 'STRING'),
                        ('runtime', 'NUMERIC'),
                        ('runstatus', ['ok', 'timeout', 'memout', 'not_applicable', 'crash', 'other'])]
    :param cutoff: The used cutoff as a float
    :param par: The penalization factor (default = 10) if runtime >= cutoff then runtime = PAR * cutoff
    :return: oracle_perf (float), single_best_perf(float)
    """
    df = pd.DataFrame(aslib_data)  # pandas data frames allow for easy data handling
    df.columns = ['instance_id', 'repetition', 'algorithm', 'runtime', 'runstatus']  # correctly name the entries
    algos = defaultdict(list)  # track individual algorithm performances
    insts = defaultdict(lambda: np.inf)  # track individual instance performances

    df.loc[df.runtime >= cutoff, "runtime"] = cutoff * par
    mean_par10 = df.groupby(by="algorithm").mean("runtime")
    
    single_best = float(mean_par10[min(mean_par10.runtime) == mean_par10.runtime].runtime)
    
    virtual_best = df.iloc[df.groupby('instance_id').idxmin()["runtime"]].runtime.mean()

    return virtual_best, single_best


def hybrid_model(test_instances: List[str], algos: List[str], run_df: pd.DataFrame,
                 feature_df: pd.DataFrame, test_feature_df: pd.DataFrame) -> List[int]:
    """
    Use pairwise classification to predict which algorithm will outperform the others.
    Based on that, build your selection.
    :param test_instances: List of instance ids (str)
    :param algos: List of algorithms (str)
    :param run_df: Pandas Dataframe containing all training runtime data (i.e. y_train)
    :param feature_df: Pandas Dataframe containing all training feature data (i.e. X_train)
    :param test_feature_df: Pandas Dataframe containing all test feature data (i.e. X_test)
    :return: List of selected algorithms per test instance. I.e index of element in algos that should be used to solve
             an instance in test_instances
    """
    y_predictions = np.zeros((len(test_instances), len(algos)))
    X_train = feature_df.values[:, 1:]
    # TODO for each pair of algorithms, fit a model that classifies if outer outperforms inner.
    # Use voting to decide which algorithm solves which instance
    for idx_outer, algo_outer in enumerate(algos):
        for idx_inner, algo_inner in enumerate(algos):
            raise NotImplementedError
    selection = y_predictions.argmax(axis=1)
    return selection


def individual_model(test_instances: List[str], algos: List[str], run_df: pd.DataFrame,
                     feature_df: pd.DataFrame, test_feature_df: pd.DataFrame) -> List[int]:
    """
    Use any regression model you like to predict the performance for each algorithm individually.
    Based on this you should build your selection
    :param test_instances: List of instance ids (str)
    :param algos: List of algorithms (str)
    :param run_df: Pandas Dataframe containing all training runtime data (i.e. y_train)
    :param feature_df: Pandas Dataframe containing all training feature data (i.e. X_train)
    :param test_feature_df: Pandas Dataframe containing all test feature data (i.e. X_test)
    :return: List of selected algorithms per test instance. I.e index of element in algos that should be used to solve
             an instance in test_instances
    """
    y_predictions = np.zeros((len(test_instances), len(algos)))
    # TODO for each algorithm, fit a model and predict the performance on the test instances
    for idx, algo in enumerate(algos):
        raise NotImplementedError
    selection = y_predictions.argmin(axis=1)
    return selection


def select(aslib_run_data: List, aslib_feature_data: List, aslib_cv_splits: List,
           cutoff: int, parx: int, test_split_index: int = 10, algos: List = None,
           individual: bool = True
           ) -> (float, List[int]):
    """
    Method that trains individual regression models for each algorithm and predicts the performance on the final
    cv split.
    :param aslib_run_data: List of ASlib run data.
                           Entries are as follows:
                           [('instance_id', 'STRING'),
                            ('repetition', 'NUMERIC'),
                            ('algorithm', 'STRING'),
                            ('runtime', 'NUMERIC'),
                            ('runstatus', ['ok', 'timeout', 'memout', 'not_applicable', 'crash', 'other'])]
    :param aslib_feature_data: List of ASlib feature data.
                       Entries are as follows:
                       [('instance_id', 'STRING'),
                        ('feature_1', 'NUMERIC'),
                        ('feature_2', 'NUMERIC'),
                        ...,
                        ('feature_N', 'NUMERIC')]
    :param aslib_cv_splits: List of ASlib cv splits.
                       Entries are as follows:
                       [('instance_id', 'STRING'),
                        ('repetitions', 'NUMERIC'),
                        ('split_id', 'NUMERIC')]
    :param cutoff: int -> the maximum allowed runtime value
    :param parx: the penalization factor for timed-out runs.
    :param test_split_index: Which CV index is left out for evaluation purposes
    :param algos: List of algorithms to consider. If using the ASLib data is too expensive with all algorithms, you
                  can specify (as a list of strings) which algorithms you want to consider to speed up computation.
                  If set to None, all algorithms are considered
    :param individual: Boolean to determine if the individual method or the hybrid method should be used.
    :return: Mean performance on the split and corresponding selections
    """
    run_df = pd.DataFrame(aslib_run_data)  # pandas data frames allow for easy data handling
    run_df.columns = ['instance_id', 'repetition', 'algorithm', 'runtime', 'runstatus']  # correctly name the entries
    # replace timeouts with penalized runtime
    run_df['runtime'] = run_df['runtime'].apply(lambda runtime: runtime if runtime < cutoff else cutoff * parx)

    feature_df = pd.DataFrame(aslib_feature_data)
    cols = ['instance_id']
    for i in range(feature_df.shape[1] - 1):
        cols.append('feat_%d' % i)
    feature_df.columns = cols

    cv_df = pd.DataFrame(aslib_cv_splits)
    cv_df.columns = ['instance_id', 'repetition', 'split']

    if test_split_index:
        assert 0 < test_split_index < 11, 'Invalid split index. Only values from 1-10 are valid'
        # determine train and test instances
        train_instances = cv_df[cv_df['split'] != test_split_index]['instance_id'].values
        test_instances = cv_df[cv_df['split'] == test_split_index]['instance_id'].values
    else:  # train = test used for test purposes
        test_instances = train_instances = cv_df['instance_id'].unique()

    if not algos:
        algos = run_df['algorithm'].unique()  # all algorithms we need to fit models for
    else:
        run_df = run_df[run_df['algorithm'].isin(algos)]

    # we sort all entries according to the instances such that we have an easy match from run-data to feature-data
    test_run_df = run_df[run_df['instance_id'].isin(test_instances)].sort_values(['instance_id', 'algorithm'])
    run_df = run_df[run_df['instance_id'].isin(train_instances)].sort_values(['instance_id', 'algorithm'])
    test_feature_df = feature_df[feature_df['instance_id'].isin(test_instances)].sort_values('instance_id')
    feature_df = feature_df[feature_df['instance_id'].isin(train_instances)].sort_values('instance_id')

    # impute missing feature values (nan values) with mean values
    test_feature_df = test_feature_df.fillna(feature_df.mean())
    feature_df = feature_df.fillna(feature_df.mean())

    if individual:  # TODO complete the following methods
        selection = individual_model(test_instances, algos, run_df, feature_df, test_feature_df)
    else:
        selection = hybrid_model(test_instances, algos, run_df, feature_df, test_feature_df)

    performance = []
    for instance, sel in zip(test_instances, selection):
        row = test_run_df[(test_run_df['algorithm'] == algos[sel]) & (test_run_df['instance_id'] == instance)]
        performance.append(row['runtime'].iloc[0])
    mean = np.mean(performance)  # type: float
    # print(mean)
    return mean, selection



data = [['a', 1., 'A', 1., 'ok'],
                ['a', 1., 'B', 3., 'ok'],

                ['b', 1., 'A', 2., 'ok'],
                ['b', 1., 'B', 1., 'ok'],

                ['c', 1., 'A', 3., 'ok'],
                ['c', 1., 'B', 1., 'ok'],

                ['d', 1., 'A', 1., 'ok'],
                ['d', 1., 'B', 3., 'ok'],

                ['e', 1., 'A', 1., 'ok'],
                ['e', 1., 'B', 4., 'timeout'],

                ['f', 1., 'A', 5., 'timeout'],  # even though a 5 is recorded as runtime value, the penalized value
                ['f', 1., 'B', 3., 'ok']]       # will be 4*2 instead of 5*2
        # O = 1+1+1+1+1+3   =  8/6 = 1.333333
        # A = 1+2+3+1+1+4*2 = 16/2 = 2.666666
        # B = 3+1+1+3+4*2+3 = 19/6 = 3.166666
o, s = get_stats(data, cutoff=4, par=2)
