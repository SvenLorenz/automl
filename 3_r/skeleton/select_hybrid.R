# Use pairwise classification to predict which algorithm will outperform the others.
# Select the algorithm with the most wins.
# @param test_instances (`character()`): Instance names to predict
# @param run_df (`data.table()`): data.table containing all instance runtime data
# @param feature_df (`data.table()`): data.table containing all trainings instance feature data
# @param test_feature_df (`data.table()`): data.table containing all test instance feature data
# @return (`data.table(instance_id, algorithm)`): data.table with selected algorithm per instance
select_hybrid = function(test_instances, run_df, feature_df, test_feature_df) {
  data = run_df[feature_df, on = 'instance_id']
  data$runstatus = NULL
  data$repetition = NULL
  data$i.repetition = NULL
  data$instance_id = NULL
  data$algorithm = as.factor(data$algorithm)

  combinations = expand.grid(unique(run_df$algorithm), unique(run_df$algorithm))
  combinations = combinations[!combinations[, 1] == combinations[, 2],]
  run_df$wins <- numeric(nrow(run_df))

  data_split = split(data, data$algorithm)

  algorithms = as.character(unique(data$algorithm))

  data_test = run_df[test_feature_df, on = 'instance_id']
  data_test$runstatus = NULL
  data_test$repetition = NULL
  data_test$i.repetition = NULL
  data_test$instance_id = NULL
  data_test$algorithm = as.factor(data_test$algorithm)

  data_test_split = split(data_test, data$algorithm)

  learner = lrn("regr.rpart")

  for (i in seq_len(nrow(combinations))) {
    data1 = data_split[[combinations[i,1]]]
    data2 = data_split[[combinations[i,2]]]
    data1$runtime = data1$runtime - data2$runtime

    data1_test = data_test_split[[combinations[i,1]]]
    data2_test = data_test_split[[combinations[i,2]]]
    data1_test$runtime = data1_test$runtime - data2_test$runtime

    task = as_task_regr(data1, target = "runtime", id = "automl")

    learner$train(task)
    prediction <- learner$predict_newdata(data1_test)
    run_df[combinations[i, 1] == algorithm][instance_id %in% test_instances$instance_id, "wins"] <- 
      run_df[combinations[i, 1] == algorithm][instance_id %in% test_instances$instance_id, "wins"] + 
      as.numeric(prediction$data$response > 0)
    run_df[combinations[i, 2] == algorithm][instance_id %in% test_instances$instance_id, "wins"] <- 
      run_df[combinations[i, 2] == algorithm][instance_id %in% test_instances$instance_id, "wins"] + 
      as.numeric(prediction$data$response < 0)
  }

  wins = run_df[instance_id %in% test_instances$instance_id][, .SD[max(wins) == wins], 
                                                              by = instance_id]
  wins = wins[, .SD[.N >= 2 | .N == 1][1, ], by = instance_id]
  return(data.table(instance_id = wins$instance_id,
                    algorithm = wins$algorithm))
}
