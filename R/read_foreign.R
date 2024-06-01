#' Read data via R foreign
#' @description
#' Wrapper for foreign::read.spss.
#' 
#' Read SPSS Daten files before adding class i_labelled.
#' 
#' @param file file path
#' @param trim_values trim trailing spaces from value labels
#' @param to.data.frame convert list to data.frame
#' @param use.value.labels convert to factor when data has value labels
#' @param warn show warnings
#' @param ... arguments passed to foreign::read.spss
#' @importFrom foreign read.spss
#' @returns data as list or data.frame
.read_foreign <- function(file, trim_values = TRUE, to.data.frame = FALSE, use.value.labels = FALSE, warn = TRUE, ...){
  if(warn){
    foreign::read.spss(file, use.value.labels = use.value.labels, to.data.frame = to.data.frame, trim_values = trim_values, ...)  
  }else{
    suppressWarnings(foreign::read.spss(file, use.value.labels = use.value.labels, to.data.frame = to.data.frame, trim_values = trim_values, ...))  
  }
}


#' Read SPSS file
#' @description
#' Read SPSS data files and add class i_labelled.
#' 
#' Wrapper for foreign::read.spss.
#' 
#' @param file file path
#' @param trim_values trim trailing spaces from value labels
#' @param sort_value_labels sort value labels
#' @param return_data_frame return data as data.frame or list
#' @param warn show warnings
#' @param ... arguments passed to foreign::read.spss
#' @importFrom ilabelled i_labelled
#' @importFrom stats setNames
#' @returns data as list or data.frame
#' @export
i_read_spss <- function(file, trim_values = T, sort_value_labels = T, return_data_frame = T, warn = TRUE, ...){
  
  data <- .read_foreign(file, trim_values = trim_values, warn = warn, ...)
  
  # get metadata
  label <- attr(data, "variable.labels", exact = TRUE)
  labels <- attr(data, "label.table", exact = TRUE)
  na <- attr(data, "missings", exact = TRUE)
  na_values <- lapply(na, function(x){ if(x$type == "one"){ x$value }else{ NULL } })
  na_range <- lapply(na, function(x){ if(x$type == "range"){ x$value }else{ NULL } })
  
  # apply metadata
  for(i in names(data)){
    label_i <- label[[i]]
    labels_i <- labels[[i]]
    na_values_i <- na_values[[i]]
    na_range_i <- na_range[[i]]
    
    if(is.numeric(data[[i]])){
      labels_i <- stats::setNames(as.numeric(labels_i), names(labels_i))
    }else{
      labels_i <- stats::setNames(as.character(labels_i), names(labels_i))
    }
    
    if(sort_value_labels){
      labels_i <- sort(labels_i, decreasing = F) 
    }
    
    # add class i_labelled
    if(is.numeric(data[[i]])){
      data[[i]] <- ilabelled::i_labelled(
        x = data[[i]], 
        label = label_i,
        labels = labels_i, 
        na_values = na_values_i,
        na_range = na_range_i,
      )      
    }else{
      data[[i]] <- ilabelled::i_labelled(
        x = trimws(data[[i]]), 
        label = label_i,
        labels = labels_i, 
        na_values = na_values_i,
        na_range = na_range_i,
      )  
    }
  }
  
  if(return_data_frame){
    return(as.data.frame(data))
  }else{
    return(data)  
  }
}