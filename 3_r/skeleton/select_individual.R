# Use any regression model to predict the performance for each algorithm individually.
# Select the algorithm with smallest predicted runtime.
# @param test_instances (`character()`): Instance names to predict
# @param run_df (`data.table()`): data.table containing all instance runtime data
# @param feature_df (`data.table()`): data.table containing all trainings instance feature data
# @param test_feature_df (`data.table()`): data.table containing all test instance feature data
# @return (`data.table(instance_id, algorithm)`): data.table with selected algorithm per instance
select_individual <- function(test_instances, run_df, feature_df, test_feature_df) {
  data = run_df[feature_df, on = 'instance_id']
  data$runstatus = NULL
  data$repetition = NULL
  data$i.repetition = NULL
  data$instance_id = NULL
  data$algorithm = as.factor(data$algorithm)

  data_split = split(data, data$algorithm)

  algorithms = as.character(unique(data$algorithm))

  data_test = run_df[test_feature_df, on = 'instance_id']
  data_test$runstatus = NULL
  data_test$repetition = NULL
  data_test$i.repetition = NULL
  data_test$instance_id = NULL
  data_test$algorithm = as.factor(data_test$algorithm)

  data_test_split = split(data_test, data$algorithm)

  prediction <- list()
  learner = lrn("regr.rpart")

  for (i in seq_along(data_split)) {
    task = as_task_regr(data_split[[i]], target = "runtime", id = "automl")

    learner$train(task)
    prediction[[i]] <- learner$predict_newdata(data_test_split[[i]])
  }

  pred_df <- as.data.table(lapply(prediction, function(x) x$data$response))

  best_algo <- algorithms[apply(pred_df, 1, function(x) which(min(x) == x))]

  return(data.table(instance_id = test_instances, algorithm = best_algo))
}
