#' get meta-information from data
#' @param x data.frame
#' @param ... not used
#' @returns list
#' @importFrom stats setNames
#' @export
.get_metainformation <- function(x, ...){
  
  # get variable label
  label_vars <- lapply(x, function(x) attr(x, "label", exact = TRUE))
  label_data <- lapply(attr(x, "variable.labels", exact = TRUE), function(x) x)
  label_data <- label_data[names(label_data) %in% names(label_vars)]
  label_vars_miss <- which(unlist(lapply(label_vars, is.null)))
  label_vars_miss <- names(label_vars[label_vars_miss])
  label <- label_vars
  label[label_vars_miss] <- label_data[label_vars_miss]
  
  # get values labels
  labels <- lapply(x, function(x){ 
    if(is.factor(x)){
      stats::setNames(seq(levels(x)), levels(x))
    }else{
      attr(x, "labels", exact = TRUE)  
    }
  })
  
  # get missing values
  na_values <- lapply(x, function(x) attr(x, "na_values", exact = TRUE))
  
  # get missing range
  na_range <- lapply(x, function(x) sort(attr(x, "na_range", exact = TRUE)))
  
  # get scale level
  scale <- lapply(x, function(x) attr(x, "scale", exact = TRUE))
  
  # return list
  return(
    list(
      label = label,
      labels = labels, 
      na_values = na_values,
      na_range = na_range, 
      scale = scale
    )
  )
}