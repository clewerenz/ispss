library(devtools)
# devtools::install_github("https://github.com/clewerenz/ilabelled")
library(ilabelled)

devtools::load_all()

x <- i_read_spss("tests/testdata/iSpssData.sav",return_data_frame = F)
