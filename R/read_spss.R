#' Read data via R foreign
#' @description
#' wrapper for foreign::read.spss.
#' 
#' read SPSS data files
#' 
#' internal function for i_read_spss
#' 
#' @param file file path
#' @param trim_values trim trailing spaces from value labels
#' @param to.data.frame convert list to data.frame
#' @param use.value.labels convert to factor when data has value labels
#' @param warn show warnings
#' @param ... arguments passed to foreign::read.spss
#' @importFrom foreign read.spss
#' @returns data as list or data.frame
#' @export
.read_foreign <- function(file, trim_values = TRUE, to.data.frame = FALSE, use.value.labels = FALSE, warn = TRUE, ...){
  if(warn){
    foreign::read.spss(file, use.value.labels = use.value.labels, to.data.frame = to.data.frame, trim_values = trim_values, ...)  
  }else{
    suppressWarnings(foreign::read.spss(file, use.value.labels = use.value.labels, to.data.frame = to.data.frame, trim_values = trim_values, ...))  
  }
}


#' Read SPSS file
#' @description
#' read SPSS data files and add class i_labelled.
#' 
#' wrapper for foreign::read.spss.
#' 
#' @param file file path
#' @param trim_values trim trailing spaces from value labels
#' @param sort_value_labels sort value labels
#' @param fix_duplicate_labels duplicate value labels will be fixed: replace "" with value; replace duplicate labels with label + '_duplicated_' + value
#' @param return_data_frame return data as data.frame or list
#' @param warn show warnings
#' @param ... arguments passed to foreign::read.spss
#' @importFrom ilabelled i_labelled
#' @importFrom stats setNames
#' @returns data as list or data.frame
#' @export
i_read_spss <- function(file, trim_values = TRUE, sort_value_labels = TRUE, fix_duplicate_labels = TRUE, return_data_frame = TRUE, warn = TRUE, ...){
  
  # read spss data file
  data <- .read_foreign(file, trim_values = trim_values, warn = warn, to.data.frame = FALSE, use.value.labels = FALSE, ...)
  
  # get metadata via attributes
  label <- attr(data, "variable.labels", exact = TRUE)
  labels <- attr(data, "label.table", exact = TRUE)
  na <- attr(data, "missings", exact = TRUE)
  na_values <- lapply(na, function(x){ if(x$type == "one"){ x$value }else{ NULL } })
  na_range <- lapply(na, function(x){ if(x$type == "range"){ x$value }else{ NULL } })
  
  # apply metadata for each variable
  for(i in names(data)){
    
    # get metadata for current var
    label_i <- label[[i]]
    labels_i <- labels[[i]]
    na_values_i <- na_values[[i]]
    na_range_i <- na_range[[i]]
    
    # make value-labels correct format for i_labelled
    if(is.numeric(data[[i]])){
      labels_i <- stats::setNames(as.numeric(labels_i), names(labels_i))
    }else{
      labels_i <- stats::setNames(as.character(labels_i), names(labels_i))
    }
    
    # fix value-labels
    if(fix_duplicate_labels && any(empty_labels <- names(labels_i) %in% "")){
      names(labels_i)[empty_labels] <- unname(labels_i[empty_labels])  
    }
    if(fix_duplicate_labels && any(dup_labels <- duplicated(names(labels_i)))){
      names(labels_i)[dup_labels] <- paste0(names(labels_i)[dup_labels], "_duplicated_", labels_i[dup_labels])
    }
    
    # sort value-labels
    if(sort_value_labels){
      labels_i <- sort(labels_i, decreasing = FALSE) 
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