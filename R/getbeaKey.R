#' Retrieve BEA API Key
#'
#' @description
#' This function attempts to retrieve a the Bureau of Economic Analysis (BEA) API key
#' that has been set in the system environment. It's used to authenticate
#' requests to the BEA API for accessing economic data.
#'
#' @return
#' Returns a character string containing the BEA API key if it's set in
#' the environment. If the key is not set or is NA, the function returns NULL.
#'
#' @export
getbeaKey <- function() {
  beaKey <- Sys.getenv("beaKey")
  if (beaKey == "" || is.na(beaKey)) {
    return(NULL)
  }
  return(beaKey)
}
