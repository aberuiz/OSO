#' Return BEA API key
#'
#' @description
#' Returns the BEA API Key set in the environment
#'
getbeaKey <- function(){
  beaKey <- Sys.getenv("beaKey")
  if (is.na(beaKey)){
    return(NULL)
  }
  return(beaKey)
}
