beaGetKey <- function(){
  beaKey <- Sys.getenv("beaKey")
  if (is.na(beaKey)){
    return(NULL)
  }
  return(beaKey)
}
