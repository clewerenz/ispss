#' write SPSS syntax
#' @export
#' @param x data.frame
#' @param data file path for data file
#' @param syntax file path for syntax file
#' @param delimiter delimiter used in data file
#' @param qualifier how to deal with embedded double quotes
#' @param encoding file encoding
#' @param ... not used
#' @returns no return value. writes data and spss syntax to file.
#' @importFrom utils write.table
i_write_spss <- function(x, data, syntax, delimiter = "\t", qualifier = c("double","excape"), encoding = "UTF-8", ...){
  
  # extract meta-information
  meta <- .get_metainformation(x)  
  ## remove list entries without values
  meta <- lapply(meta, function(x){ x[!unlist(lapply(x, is.null))] })
  
  # run-time-test if spss format is available for all variables
  if(!identical(names(x), names(meta$format))){
    stop("all variables must have format")
  }
  
  # convert non-character and non-numeric variables to character
  # convert factor variables to numeric
  x[] <- lapply(x, function(x){
    if(is.factor(x)){
      as.numeric(x)
    }else if(!is.numeric(x)){
      as.character(x)
    }else if(!is.character(x) && !is.numeric(x)){
      stop("missing class conversion")
    }else{
      x
    }
  })
  
  # make syntax for SPSS data import
  s <- .spss_syntax_read_data_file(
    formats = meta$format, 
    path = data, 
    delimiter = delimiter,
    qualifier = qualifier,
    encoding = encoding
  )

  # write data
  utils::write.table(
    x = x, 
    file = data, 
    sep = delimiter, 
    col.names = TRUE, 
    row.names = FALSE, 
    qmethod = "double", 
    fileEncoding = encoding,
    quote = TRUE
  )
  
  # write SPSS syntax
  writeLines(
    text = s,
    con = syntax
  )
  
}


#' prepare syntax: read data
#' @export
#' @param formats named list with spss format for each variable
#' @param path file path
#' @param delimiter delimiter used in data file
#' @param qualifier how to deal with embedded double quotes
#' @param encoding file encoding
#' @returns character vector with SPSS syntax
.spss_syntax_read_data_file <- function(formats, path, delimiter = "\t", qualifier = c("double","excape"), encoding = "UTF-8"){
  if(!is.null(qualifier)){
    qualifier <- ifelse(qualifier == "double", '"', "'")  
  }
  
  c(
    "",
    "SET DECIMAL=DOT.",
    "",
    "* IMPORT DATA FROM FILE *", 
    "",
    "GET DATA",
    " /TYPE=TXT",
    paste0(" /FILE='", path, "'"),
    paste0(" /ENCODING='", encoding, "'"),
    if(!is.null(qualifier)){sprintf(" /QUALIFIER='%s'", qualifier)},
    " /ARRANGEMENT=DELIMITED",
    sprintf(" /DELIMITERS='%s'", delimiter),
    " /DELCASE=LINE",
    " /FIRSTCASE=2",
    " /VARIABLES =",
    unlist(lapply(names(formats), function(x) paste0(" ", x, " ", formats[[x]]))),
    ".", 
    "",
    "* ---------------------------------------------------------------- *",
    ""
  )  
}


