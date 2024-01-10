beaGetKey <- function(){
  key <- Sys.getenv(beaKey)
  if (is.na(key)){
    return(NULL)
  }
  return(key)
}
