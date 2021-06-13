### Functions:

fUniqVars <- function(x) {
  # takes DF returns string vector of unique strings in DF
  # unlist collapses list which then can be pased to unique
  y <- unique(unlist(c(x)))
  return(y)
}
