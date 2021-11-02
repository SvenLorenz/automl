# Loads data stored in McNemarTest.csv
# @param fl (`character(1)`): Path of csv file
# @return (`data.table()`): labels, prediction1, prediction2
load_data_MNTest = function(fl = "../../data/MCTestData.csv") {
  as.matrix(read.csv(fl, header = FALSE))
}

# Loads data stored in TMStTestData.csv
# @param fl (`character(1)`): Path of csv file
# @return (`data.table()`) with columns y1, y2
load_data_TMStTest = function(fl = "../../data/TMStTestData.csv") {
  as.matrix(read.csv(fl, header = FALSE))
}

# Loads data stored in FTestData.csv
# @param fl (`character(1)`): Path of csv file
# @return (`matrix(numeric())`) with datasets in rows and algorithms in columns
load_data_FTestData = function(fl = "../../data/FTestData.csv") {
  as.matrix(read.csv(fl, header=FALSE))
}
