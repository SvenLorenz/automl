# Executes the algorithm selection for each fold, defined in `cv`.
# @param run_df (`data.table`): data.table containing all training runtime data (i.e. y_train)
# @param features (`data.table`): feature values of the instances
# @param cv (`data.table`): Predefined splits
# @param selector_fun (`function(test_instances, run_df, feature_df, test_feature_df)`): either `select_individual` or `select_hybrid`
# @return (`character()`): named character vector of selected algorithm per instance
select_algorithms <- function(run_df, features, cv, selector_fun) {
  max_folds <- max(cv$fold)
  instances <- character(0)
  best_algos <- character(0)

  for (i in seq_len(max_folds)) {
    test_instances <- cv[cv$fold == i, "instance_id"]
    train_features <- features[!instance_id %in% test_instances$instance_id, ]
    test_features <- features[instance_id %in% test_instances$instance_id, ]
    temp = selector_fun(test_instances, run_df, train_features, test_features)
    instances <- c(instances, temp$instance_id)
    best_algos <- c(best_algos, temp$algorithm)
  }
  names(best_algos) <- instances
  return(best_algos)
}

# Calculate Performance of Selection strategy
# @param selected (`character()`): named character vector of selected algorithm per instance
# @param run_df (`data.table`): data.table containing all training runtime data (i.e. y_train)
# @param cutoff (`double(1)`): The used cutoff as a double
# @param par (`integer(1)`): The penalization factor (default = 10) if runtime >= cutoff then runtime = PAR * cutoff
# @return (`double(1)`): Average perfromance of the selected algorithms
calculate_performance <- function(selected, run_df, cutoff, par = 10L) {
  run_df[runtime >= cutoff, "runtime"] <- cutoff * par
  average_par10 <- run_df[, .(mean_par10 = mean(runtime)), by = "instance_id"]
  split_df <- split(run_df, run_df$instance_id)
  best_perform <- numeric(length(unique(run_df$instance_id)))
  for (i in seq_along(split_df)) {
    name <- names(split_df)[i]
    best_algo <- selected[names(selected) == name]
    best_perform[i] <- split_df[[i]][algorithm == best_algo, "runtime"]
  }
  return(mean(abs(average_par10$mean_par10 - unlist(best_perform))))
}
