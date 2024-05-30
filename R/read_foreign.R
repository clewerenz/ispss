#' Read data via R foreign
#' @description
#' Wrapper for foreign::read.spss.
#' Read SPSS Daten files before adding class i_labelled.
#' 
#' @param file file path
#' @param trim_values trim trailing spaces from value labels
#' @param to.data.frame convert list to data.frame
#' @param use.value.labels convert to factor when data has value labels
#' @param ... arguments passed to foreign::read.spss
#' @importFrom foreign read.spss
#' @return List with Data
.read_foreign <- function(file, trim_values = T, to.data.frame = F, use.value.labels = F, ...){
  foreign::read.spss(file, use.value.labels = F, to.data.frame = F, trim_values = trim_values, ...)
}


#' Read SPSS file
#' @description
#' Read SPSS data files and add class i_labelled.
#' Wrapper for foreign::read.spss.
#' 
#' @param file file path
#' @param trim_values trim trailing spaces from value labels
#' @param sort_value_labels sort value labels
#' @param return_data_frame return data as data.frame or list
#' @param ... arguments passed to foreign::read.spss
#' @importFrom ilabelled i_labelled
#' @importFrom stats setNames
#' @return data.frame
#' @export
i_read_spss <- function(file, trim_values = T, sort_value_labels = T, return_data_frame = T, ...){
  
  data <- .read_foreign(file, trim_values = trim_values)
  
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
    data[[i]] <- ilabelled::i_labelled(
      x = data[[i]], 
      label = label_i,
      labels = labels_i, 
      na_values = na_values_i,
      na_range = na_range_i,
    )    
  }
  
  if(return_data_frame){
    return(as.data.frame(data))
  }else{
    return(data)  
  }
}