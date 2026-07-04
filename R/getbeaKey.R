#' Retrieve BEA API Key
#'
#' @description
#' This function attempts to retrieve a the Bureau of Economic Analysis (BEA) API key
#' that has been set in the system environment. It's used to authenticate
#' requests to the BEA API for accessing economic data.
#'
#' @return
#' Returns a character string containing the BEA API key if it's set in
#' the environment. If the key is not set, returns an empty string ("").
#'
#' @export
getbeaKey <- function() {
  Sys.getenv("beaKey")
}
