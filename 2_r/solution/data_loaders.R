# Loads data stored in McNemarTest.csv
# @param fl (`character(1)`): Path of csv file
# @return (`data.table()`): labels, prediction1, prediction2
load_data_MNTest = function(fl = "../../src/MCTestData.csv") {
  data = read.csv(fl, header = FALSE)
  data.table(
    labels = data[, 1L],
    prediction1 = data[, 2L],
    prediction2 = data[, 3L]
  )
}

# Loads data stored in TMStTestData.csv
# @param fl (`character(1)`): Path of csv file
# @return (`data.table()`) with columns y1, y2
load_data_TMStTest = function(fl = "../../src/TMStTestData.csv") {
  data = read.csv(fl, header = FALSE)
  data.table(
    y1 = data[, 1L],
    y2 = data[, 2L]
  )
}

# Loads data stored in FTestData.csv
# @param fl (`character(1)`): Path of csv file
# @return (`matrix(numeric())`) with datasets in rows and algorithms in columns
load_data_FTestData = function(fl = "../../src/FTestData.csv") {
  data = read.csv(fl, header = FALSE)
  unname(as.matrix(data))
}

