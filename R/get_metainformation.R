#' get meta-information from data
#' @description
#' returns list with variable informations for script processing
#' 
#' label: variable-labels
#' 
#' labels: value-labels
#' 
#' na_values: missing-values
#' 
#' na_range: missing-range
#' 
#' scale: scale-level
#' 
#' format: spss-format (e.g. F8.0, A25)
#' 
#' @param x data.frame
#' @param ... not used
#' @returns list
#' @importFrom stats setNames
#' @export
.get_metainformation <- function(x, ...){
  
  # get variable label from variables
  ## fill variable when attribute "label" is missing 
  ## and data.frame attribute "variable.labels" is available
  label_vars <- lapply(x, function(y) attr(y, "label", exact = TRUE))
  label_data <- lapply(attr(x, "variable.labels", exact = TRUE), function(y) y)
  label_data <- label_data[names(label_data) %in% names(label_vars)]
  label_vars_miss <- unlist(lapply(label_vars, is.null))
  if(length(label_vars_miss) > 0){
    label_vars_miss <- which(unlist(lapply(label_vars, is.null)))  
  }else{
    label_vars_miss <- NULL
  }
  label_vars_miss <- names(label_vars[label_vars_miss])
  label <- label_vars
  label[label_vars_miss] <- label_data[label_vars_miss]
  
  # get values labels
  labels <- lapply(x, function(y){ 
    if(is.factor(y)){
      stats::setNames(seq(levels(y)), levels(y))
    }else{
      attr(y, "labels", exact = TRUE)  
    }
  })
  
  # get missing values
  na_values <- lapply(x, function(y) attr(y, "na_values", exact = TRUE))
  
  # get missing range
  na_range <- lapply(x, function(y) sort(attr(y, "na_range", exact = TRUE)))
  
  # get scale level
  scale <- lapply(x, function(y) attr(y, "scale", exact = TRUE))
  
  # spss format  
  format <- .get_spss_format(x)
  
  # return list
  return(
    list(
      label = label,
      labels = labels, 
      na_values = na_values,
      na_range = na_range, 
      scale = scale,
      format = format
    )
  )
}


#' calculate spss format from data
#' @param x data.frame
#' @param ... not used
#' @importFrom ilabelled is_decimal
#' @returns list
#' @export
.get_spss_format <- function(x, ...){
  lapply(x, function(x){
    if(is.factor(x)){
      "F8.0"
    }else if(is.numeric(x)){
      if(ilabelled::is_decimal(x)){
        "F8.2"
      }else{
        "F8.0"
      }
    }else if(is.character(x)){
      fmt_len <- max(nchar(x, keepNA = FALSE), na.rm = TRUE)
      fmt_len <- ifelse(fmt_len <= 20, "A25", paste0("A", fmt_len + 5))
      fmt_len
    }else{
      stop("cannot extract spss format for class ", class(x), " - transform to character, factor or i_labelled and try again.")
    }
  })
}

