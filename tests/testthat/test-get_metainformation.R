
###################################################################
#
# .get_metainformation
#
###################################################################

myData <- readRDS("../testdata/iSpssDataForOutput.rds")

test_that(".get_metainformation does not throw error", {
  expect_no_error(.get_metainformation(myData))
})

myMeta <- .get_metainformation(myData)

test_that("alle requires meta-information should be names of list return value", {
  expect_true( identical(names(myMeta), c("label","labels","na_values","na_range","scale","format")) )
})

test_that("every list element of return value ist same length as sum of data.frame columns", {
  expect_true( all(unlist(lapply(myMeta, function(x){ identical(length(names(myData)), length(x)) }))) )
})

test_that("every list element of return value has the column names of data.frame", {
  expect_true( all(unlist(lapply(myMeta, function(x){ identical(names(myData), names(x)) }))) )
})

test_that("no duplicated variable names in meta-inforamtions", {
  expect_true(!any(duplicated(names(myMeta))))
  expect_true(all(unlist(lapply(myMeta, function(x) !any(duplicated(names(x)))))))
})

test_that("check format of meta-information", {
  # variable label
  expect_true(identical(myMeta$label$geschl, "Geschlecht"))
  expect_true(identical(myMeta$label$geschl_fac, "Geschlecht 2"))
  # value labels
  expect_true(all.equal(myMeta$labels$filmemag, setNames(1:4, c("sehr gerne","gerne","geht so","überhaupt nicht gerne"))))
  expect_null(myMeta$labels$gewi)
  # missing values
  expect_true(identical(myMeta$na_values$nudelso, -9))
  expect_null(myMeta$na_values$alter)
  # missing range
  expect_true(identical(myMeta$na_range$alter, c(-9,-1)))
  expect_null(myMeta$na_range$groe)
  # scale level
  expect_true(identical(myMeta$scale$geschl, "nominal"))
  expect_true(identical(myMeta$scale$nudelmag, "ordinal"))
  expect_true(identical(myMeta$scale$groe, "scale"))
  expect_true(identical(myMeta$scale$gewi, NULL))
})

###################################################################
#
# .get_spss_format
#
###################################################################

myData <- readRDS("../testdata/iSpssDataForOutput.rds")

test_that(".get_spss_format does not throw error", {
  expect_no_error(.get_spss_format(myData))
})

myFormat <- .get_spss_format(myData)

test_that("all variable-names are names of return-value", {
  expect_true(identical(names(myData), names(myFormat)))
})

test_that("format is calculated correctly", {
  expect_true(all.equal(unname(unlist(myFormat)), c("F8.0","F8.0","F8.2","F8.0","F8.0","F8.0","F8.0","A26","F8.0")))
})


