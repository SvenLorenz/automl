import argparse
import logging

import numpy as np
import pandas as pd
import scipy.stats as stats
import matplotlib.pyplot as plt


def load_data_MNTest(fl="./data/MCTestData.csv"):
    """
    Loads data stored in McNemarTest.csv
    :param fl: filename of csv file
    :return: labels, prediction1, prediction2
    """
    data = pd.read_csv(fl, header=None).to_numpy()
    labels = data[:, 0]
    prediction_1 = data[:, 1]
    prediction_2 = data[:, 2]
    return labels, prediction_1, prediction_2


def load_data_TMStTest(fl="./data/TMStTestData.csv"):
    """
    Loads data stored in fl
    :param fl: filename of csv file
    :return: y1, y2
    """
    data = np.loadtxt(fl, delimiter=",")
    y1 = data[:, 0]
    y2 = data[:, 1]
    return y1, y2


def load_data_FTest(fl="./data/FTestData.csv"):
    """
    Loads data stored in fl
    :param fl: filename of csv file
    :return: evaluations
    """
    errors = np.loadtxt(fl, delimiter=",")
    return errors


def McNemar_test(labels, prediction_1, prediction_2):
    """
    TODO
    :param labels: the ground truth labels
    :param prediction_1: the prediction results from model 1
    :param prediction_2:  the prediction results from model 2
    :return: the test statistic chi2_Mc
    """
    
    pred_1_log = labels == prediction_1
    pred_2_log = labels == prediction_2
    
    c_1 = (pred_1_log & np.logical_not(pred_2_log)).sum()
    c_2 = (np.logical_not(pred_1_log) & pred_2_log).sum()
    
    chi2_Mc = (np.abs(c_1 - c_2) - 1)**2 / (c_1 + c_2)
    
    return chi2_Mc


def TwoMatchedSamplest_test(y1, y2):
    """
    TODO
    :param y1: runs of algorithm 1
    :param y2: runs of algorithm 2
    :return: the test statistic t-value
    """
    d = y1 - y2
    d_mean = d.mean()
    d_sd = d.std()
    
    t_value = np.sqrt(len(y1)) * d_mean / d_sd
    return t_value


def Friedman_test(errors):
    """
    TODO
    :param errors: the error values of different algorithms on different datasets
    :return: chi2_F: the test statistic chi2_F value
    :return: FData_stats: the statistical data of the Friedan test data, you can add anything needed to facilitate
    solving the following post hoc problems
    """
    rank_errors = np.array([stats.rankdata(error) for error in errors])
    mean_rank_models = np.mean(rank_errors, axis=0)
    mean_rank = np.mean(rank_errors)
    
    ss_total = np.sum((mean_rank_models - mean_rank)**2) * len(errors)
    ss_error = np.sum((rank_errors - mean_rank)**2) / (len(errors) * (errors.shape[1] - 1))
    
    chi2_F = ss_total / ss_error
    FData_stats = {"errors": errors,
                   "mean_rank_models": mean_rank_models}
    return chi2_F, FData_stats


def Nemenyi_test(FData_stats):
    """
    TODO
    :param FData_stats: the statistical data of the Friedan test data to be utilized in the post hoc problems
    :return: the test statisic Q value
    """
    n = FData_stats['errors'].shape[0]
    k = FData_stats['errors'].shape[1]
    
    Q_value = np.array([(FData_stats['mean_rank_models'] - FData_stats['mean_rank_models'][i]) / np.sqrt(k*(k+1)/(6*n)) for i in range(k)])
    
    return np.triu(Q_value)


def box_plot(FData_stats):
    """
    TODO
    :param FData_stats: the statistical data of the Friedan test data to be utilized in the post hoc problems
    """
    best_index = np.argmax(FData_stats['mean_rank_models'])
    worst_index = np.argmin(FData_stats['mean_rank_models'])
    
    plt.hist(FData_stats['errors'][:,best_index],
             alpha=0.5, # the transaparency parameter
             label='Best average Model errors')

    plt.hist(FData_stats['errors'][:,worst_index],
             alpha=0.5,
             label='Worst average Model errors')

    plt.legend(loc='upper right')
    plt.title('Best and worst average Model compared')
    plt.show()


def main(args):
    # (a)
    labels, prediction_A, prediction_B = load_data_MNTest()
    chi2_Mc = McNemar_test(labels, prediction_A, prediction_B)

    # (b)
    y1, y2 = load_data_TMStTest()
    t_value = TwoMatchedSamplest_test(y1, y2)

    # (c)
    errors = load_data_FTest()
    chi2_F, FData_stats = Friedman_test(errors)

    # (d)
    Q_value = Nemenyi_test(FData_stats)

    # (e)
    box_plot(FData_stats)


if __name__ == "__main__":
    cmdline_parser = argparse.ArgumentParser("ex03")

    cmdline_parser.add_argument(
        "-v", "--verbose", default="INFO", choices=["INFO", "DEBUG"], help="verbosity"
    )
    cmdline_parser.add_argument(
        "--seed", default=12345, help="Which seed to use", required=False, type=int
    )
    args, unknowns = cmdline_parser.parse_known_args()
    np.random.seed(args.seed)
    log_lvl = logging.INFO if args.verbose == "INFO" else logging.DEBUG
    logging.basicConfig(level=log_lvl)

    if unknowns:
        logging.warning("Found unknown arguments!")
        logging.warning(str(unknowns))
        logging.warning("These will be ignored")
    main(args)
