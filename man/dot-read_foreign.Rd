% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_spss.R
\name{.read_foreign}
\alias{.read_foreign}
\title{Read data via R foreign}
\usage{
.read_foreign(
  file,
  trim_values = TRUE,
  to.data.frame = FALSE,
  use.value.labels = FALSE,
  warn = TRUE,
  ...
)
}
\arguments{
\item{file}{file path}

\item{trim_values}{trim trailing spaces from value labels}

\item{to.data.frame}{convert list to data.frame}

\item{use.value.labels}{convert to factor when data has value labels}

\item{warn}{show warnings}

\item{...}{arguments passed to foreign::read.spss}
}
\value{
data as list or data.frame
}
\description{
wrapper for foreign::read.spss.

read SPSS data files

internal function for i_read_spss
}
