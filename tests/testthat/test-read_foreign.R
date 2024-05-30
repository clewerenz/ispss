test_that("read spss data from file: .read_foreign", {
  # just read file successfully
  expect_no_error(.read_foreign("../testdata/iSpssData.sav"))
})

test_that("read spss data from file: i_read_spss", {
  # just read file successfully
  expect_no_error(myData <- i_read_spss("../testdata/iSpssData.sav"))
})


test_that("check metadata after loading spss data", {
  expect_no_error(myData <- i_read_spss("../testdata/iSpssData.sav"))
  
  # geschl
  expect_true(
    identical(class(myData$geschl), c("i_labelled","double"))
  )
  expect_true(
    identical(as.numeric(myData$geschl), c(1,1,1,1,1,1,2,2,2,2,2))
  )
  expect_true(
    identical(attr(myData$geschl, "label", TRUE), "Geschlecht")
  )
  expect_true(
    identical(attr(myData$geschl, "labels", TRUE), setNames(c(1,2), c("männlich","weiblich")))
  )
  
  # nudelso
  expect_true(
    identical(class(myData$geschl), c("i_labelled","double"))
  )
  expect_true(
    identical(as.numeric(myData$nudelso), c(1,1,2,1,1,1,1,1,1,2,-9))
  )
  expect_true(
    identical(attr(myData$nudelso, "label", TRUE), "Nudeln und Sosse")
  )
  expect_true(
    identical(attr(myData$nudelso, "labels", TRUE), setNames(c(-9,1,2), c("MFR","ja","nein")))
  )
  expect_true(
    identical(attr(myData$nudelso, "na_values", TRUE), -9)
  )
  
  # alter
  expect_true(
    identical(attr(myData$alter, "na_values", TRUE), NULL)
  )
  expect_true(
    identical(attr(myData$alter, "na_range", TRUE), c(-9,-1))
  )
})
