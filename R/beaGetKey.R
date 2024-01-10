beaGetKey <- function(){
  beaKey <- Sys.getenv("beaKey", unset = NA)
  if (is.na(beaKey)){
    return(NULL)
  }
  return(beaKey)
}
