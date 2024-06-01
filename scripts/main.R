library(devtools)
# devtools::install_github("https://github.com/clewerenz/ilabelled")
library(ilabelled)

devtools::load_all()

myData <- readRDS("tests/testdata/iSpssDataForOutput.rds")
myMeta <- .get_metainformation(myData)
myMeta$label

