library(devtools)
# devtools::install_github("https://github.com/clewerenz/ilabelled")
library(ilabelled)

devtools::load_all()

x <- i_read_spss("tests/testdata/iSpssData.sav")

i_write_spss(x = x, data = "output/myData.dat", syntax = "output/myData.sps")
