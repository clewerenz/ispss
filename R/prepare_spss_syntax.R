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
  
  qualifier <- match.arg(qualifier)
  
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
  s_read_data <- .spss_syntax_read_data_file(
    formats = meta$format, 
    path = data, 
    delimiter = delimiter,
    qualifier = qualifier,
    encoding = encoding
  )
  
  # make syntax for variable-labels
  s_add_var_labs <- .spss_syntax_variable_labels(meta$label)
  
  # make syntax for varlue-labels
  s_add_val_labs <- .spss_syntax_value_labels(meta$labels)
  
  # concatenate syntax parts
  s <- c(
    s_read_data,
    s_add_var_labs,
    s_add_val_labs
  )
  
  # write data
  utils::write.table(
    x = x, 
    file = data, 
    sep = delimiter, 
    col.names = TRUE, 
    row.names = FALSE, 
    qmethod = qualifier, # "double"
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
  
  bn <- basename(path)
  dataset_name <- sub("\\.", "", bn)
  
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
    "",
    paste0("DATASET NAME ", dataset_name, "."),
    paste0("DATASET ACTIVATE ", dataset_name, "."), 
    "",
    "* ---------------------------------------------------------------- *",
    ""
  )
}



#' prepare syntax: set variable-labels
#' @param label named list with variable-labels
#' @returns character vector with SPSS syntax
#' @export
.spss_syntax_variable_labels <- function(label){
  if(length(label) > 0){
    c(
      "* SET VARIABLE LABELS *",
      "",
      "VARIABLE LABELS",
      unlist(lapply(names(label), function(x){paste0(" ", x, ' "', label[[x]], '"')})),
      ".",
      "EXECUTE.",
      "",
      "* ---------------------------------------------------------------- *",
      ""
    )  
  }  
}



#' prepare syntax: set value-labels
#' @param label named list with variable-labels
#' @returns character vector with SPSS syntax
#' @export
.spss_syntax_value_labels <- function(labels){
  if(length(labels) > 0){
    c(
      "* SET VALUE LABELS *",
      "",
      unlist(lapply(names(labels), function(x){
        c(paste("VALUE LABELS", x),
          unlist(lapply(seq(labels[[x]]), function(y){
            paste0(" ", unname(labels[[x]][y]), ' "', names(labels[[x]][y]), '"')
          })),
          ".",
          ""
        )
      })),
      "EXECUTE.",
      "",
      "* ---------------------------------------------------------------- *",
      ""
    )  
  }
}
