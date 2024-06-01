#' write SPSS syntax
#' @export
#' @param x data.frame
#' @param data file path for data file
#' @param syntax file path for syntax file
#' @param dec decimal point
#' @param delimiter delimiter used in data file
#' @param qualifier how to deal with embedded double quotes
#' @param encoding file encoding
#' @param ... not used
#' @returns no return value. writes data and spss syntax to file.
#' @importFrom utils write.table
#' @importFrom ilabelled is.i_labelled
#' @importFrom ilabelled i_to_base_class
i_write_spss <- function(x, data, syntax, dec = c(".",","), delimiter = c("\t",",",";","~"), qualifier = c("double","escape"), encoding = "UTF-8", ...){
  
  delimiter <- match.arg(delimiter)
  dec <- match.arg(dec)
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
    }else if(dec != "." && ilabelled::is.i_labelled(x)){
      ilabelled::i_to_base_class(x, missing_to_na = F, as_factor = F, keep_attributes = F)
    }else if(!is.numeric(x)){
      as.character(x)
    }else if(!is.character(x) && !is.numeric(x)){
      stop("class conversion not yet implemented")
    }else{
      x
    }
  })
  
  # make syntax for SPSS data import
  s_read_data <- .spss_syntax_read_data_file(
    formats = meta$format, 
    path = data, 
    dec = dec,
    delimiter = delimiter,
    qualifier = qualifier,
    encoding = encoding
  )
  
  # make syntax for variable-labels
  s_add_var_labs <- .spss_syntax_variable_labels(meta$label)
  
  # make syntax for varlue-labels
  s_add_val_labs <- .spss_syntax_value_labels(meta$labels)
  
  # make syntax for missing-range
  s_add_na_range <- .spss_syntax_missing_range(meta$na_range)
  
  # make syntax for missing-values
  s_add_na_values <- .spss_syntax_missing_values(meta$na_values)
  
  # make syntax for variable-level
  s_add_var_level <- .spss_syntax_variable_level(meta$scale)
  
  # concatenate syntax parts
  s <- c(
    s_read_data,
    s_add_var_labs,
    s_add_val_labs,
    s_add_na_range,
    s_add_na_values,
    s_add_var_level
  )
  
  # write data
  utils::write.table(
    x = x, 
    file = data, 
    sep = delimiter, 
    dec = dec,
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
#' @param dec decimal point
#' @param delimiter delimiter used in data file
#' @param qualifier how to deal with embedded double quotes
#' @param encoding file encoding
#' @returns character vector with SPSS syntax
.spss_syntax_read_data_file <- function(formats, path, dec = c(".", ","), delimiter = c("\t",",",";","~"), qualifier = c("double","escape"), encoding = "UTF-8"){

  delimiter <- match.arg(delimiter)
    
  dec <- match.arg(dec)
  dec <- ifelse(dec == ".", "DOT", "COMMA")
  
  qualifier <- match.arg(qualifier)  
  qualifier <- ifelse(qualifier == "double", '"', "'")  
  
  bn <- basename(path)
  dataset_name <- sub("\\.", "", bn)
  
  c(
    "",
    paste0("SET DECIMAL=", dec, "."),
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
#' @param labels named list with value-labels
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



#' prepare syntax: set missing-range
#' @param na_range named list with missing-ranges
#' @returns character vector with SPSS syntax
#' @export
.spss_syntax_missing_range <- function(na_range){
  if(length(na_range)){
    c(
      "* SET MISSING RANGE",
      "",
      unlist(lapply(names(na_range), function(x){
        paste0("MISSING VALUES ", x, " (", na_range[[x]][1], " THRU ", na_range[[x]][2], ").")
      })),
      "",
      "EXECUTE.",
      "",
      "* ---------------------------------------------------------------- *",
      ""
    )  
  }
}



#' prepare syntax: set missing-values
#' @param na_values named list with missing-values
#' @returns character vector with SPSS syntax
#' @export
.spss_syntax_missing_values <- function(na_values){
  if(length(na_values) > 0){
    c(
      "* SET MISSING VALUES *",
      "",
      unlist(lapply(names(na_values), function(x){
        if(is.character(na_values[[x]])){
          paste0("MISSING VALUES ", x, " (\'", paste0(na_values[[x]], collapse = "\', \'"), "\').")
        }else{
          paste0("MISSING VALUES ", x, " (", paste0(na_values[[x]], collapse = ", "), ").") 
        }
      })),
      "",
      "EXECUTE.",
      "",
      "* ---------------------------------------------------------------- *",
      ""
    )
  }
}



#' prepare syntax: set variable-level
#' @param scale named list with variable-level
#' @returns character vector with SPSS syntax
#' @export
.spss_syntax_variable_level <- function(scale){
  if(length(scale) > 0){
    c(
      "* SET VARIABLE LEVELS *",
      "",
      unlist(lapply(names(scale), function(x){
        paste0("VARIABLE LEVEL ", x, " (", toupper(scale[[x]]), ").")
      })),
      "",
      "EXECUTE.",
      "",
      "* ---------------------------------------------------------------- *",
      ""
    )
  }
}
