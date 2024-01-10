beaSetKey <- function(APIkey){
  if (!rlang::is_string(APIkey)){
    rlang::abort("'APIkey` must be a string.")
    }
  if (nchar(APIkey)!=36){
    warning(paste0("'Invalid API Key: ",APIkey,". Register @ <https://apps.bea.gov/API/signup/>'"))
    return(paste0("'Invalid API Key: ",APIkey,". Register @ <https://apps.bea.gov/API/signup/>'"))
    }
  Sys.setenv(beaKey = APIkey)
}
