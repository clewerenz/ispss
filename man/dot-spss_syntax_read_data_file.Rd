% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_spss.R
\name{.spss_syntax_read_data_file}
\alias{.spss_syntax_read_data_file}
\title{prepare syntax: read data}
\usage{
.spss_syntax_read_data_file(
  formats,
  path,
  dec = c(".", ","),
  delimiter = c("\\t", ",", ";", "~"),
  qualifier = c("double", "escape"),
  encoding = "UTF-8"
)
}
\arguments{
\item{formats}{named list with spss format for each variable}

\item{path}{file path}

\item{dec}{decimal point}

\item{delimiter}{delimiter used in data file}

\item{qualifier}{how to deal with embedded double quotes}

\item{encoding}{file encoding}
}
\value{
character vector with SPSS syntax
}
\description{
prepare syntax: read data
}
