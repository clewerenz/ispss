library(devtools)
# devtools::install_github("https://github.com/clewerenz/ilabelled")
library(ilabelled)

devtools::load_all()

x <- i_read_spss("tests/testdata/iSpssData.sav")

x$test <- i_labelled(LETTERS[1:11], labels = c("AA" = "A", "BB" = "B"))

i_write_spss(x = x, data = "output/myData.dat", syntax = "output/myData.sps")
