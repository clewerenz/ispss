library(devtools)
# devtools::install_github("https://github.com/clewerenz/ilabelled")
library(ilabelled)

devtools::load_all()

myData <- foreign::read.spss("tests/testdata/iSpssData.sav")
myData <- .read_foreign("tests/testdata/iSpssData.sav")
myData <- i_read_spss("tests/testdata/iSpssData.sav")
myData <- readRDS("tests/testdata/iSpssDataForOutput.rds")
myMeta <- .get_metainformation(myData)


i_write_spss(
  x = myData, 
  data = "/home/lnx/Documents/ispss/output/myData.dat", 
  syntax = "/home/lnx/Documents/ispss/output/myData.sps",
)

