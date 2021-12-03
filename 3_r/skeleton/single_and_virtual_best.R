# Get the performance of the single best algorithm
# @param run_df (`data.table`): data.table containing all training runtime data (i.e. y_train)
# @param cutoff (`double(1)`): The used cutoff as a double
# @param par (`integer(1)`): The penalization factor (default = 10) if runtime >= cutoff then runtime = PAR * cutoff
# @return single_best_perf (`double(1)`)
get_single_best <- function(run_df, cutoff, par = 10L) {
  run_df[runtime >= cutoff, "runtime"] <- cutoff * par
  average_par10 <- run_df[, .(mean_par10 = mean(runtime)), by = "algorithm"]
  return(average_par10[min(mean_par10) == mean_par10, "mean_par10"])
}

# Get the virtual best performance
# @param run_df (`data.table`): data.table containing all training runtime data (i.e. y_train)
# @param cutoff (`double(1)`): The used cutoff as a double
# @param par (`integer(1)`): The penalization factor (default = 10) if runtime >= cutoff then runtime = PAR * cutoff
# @return oracle_perf (`double(1)`)
get_virtual_best <- function(run_df, cutoff, par = 10L) {
  run_df[runtime >= cutoff, "runtime"] <- cutoff * par
  return(min(run_df[, "runtime"]))
}
