
myData <- readRDS("../testdata/iSpssDataForOutput.rds")

test_that(".get_metainformation does not throw error", {
  expect_no_error(.get_metainformation(myData))
})

myMeta <- .get_metainformation(myData)


###################################################################


test_that("alle requires meta-information should be names of list return value", {
  expect_true( identical(names(myMeta), c("label","labels","na_values","na_range","scale")) )
})


test_that("every list element of return value ist same length as sum of data.frame columns", {
  expect_true( all(unlist(lapply(myMeta, function(x){ identical(length(names(myData)), length(x)) }))) )
})


test_that("every list element of return value has the column names of data.frame", {
  expect_true( all(unlist(lapply(myMeta, function(x){ identical(names(myData), names(x)) }))) )
})



