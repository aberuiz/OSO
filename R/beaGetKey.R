#' @export
#' @family OSO-utils
#' @rdname bea-api-key
beaGetKey <- function(){
  key <- Sys.getenv(beaKey)
  if (is.na(key)){
    return(NULL)
  }
  return(key)
}
