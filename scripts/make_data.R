devtools::load_all()
library(ilabelled)

myData <- i_read_spss("tests/testdata/iSpssData.sav")

attr(myData, "variable.labels")["gewi"] <- "Gewicht 2"

myData$geschl_fac <- i_as_factor(myData$geschl)
attr(myData, "variable.labels")["geschl_fac"] <- "Geschlecht 2"

myData$geschl <- myData$geschl |>
  i_scale("nominal")
myData$nudelmag <- myData$nudelmag |>
  i_scale("ordinal")
myData$groe <- myData$groe |>
  i_scale("scale")

saveRDS(myData, file = "tests/testdata/iSpssDataForOutput.rds")
