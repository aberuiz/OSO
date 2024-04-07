#' Set a BEA API key
#'
#'  @description
#'  Every request requires a BEA API key to be set in order to complete a request.
#'
setbeaKey <- function(APIkey, install = FALSE, overwrite = FALSE){

  if (!rlang::is_string(APIkey)){
    stop("'APIkey` must be a string.")
  }
  if (nchar(APIkey)!=36){
    stop(paste0("'Invalid API Key: ",APIkey," Register @ <https://apps.bea.gov/API/signup/>'"))
  }

  if (install) {
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if(file.exists(renv)){
      # Backup original .Renviron
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if(!file.exists(renv)){
      file.create(renv)
    }
    else{
      if(isTRUE(overwrite)){
        message("Your original .Renviron will be backed up in R HOME directory.")
        oldenv = read.table(renv, stringsAsFactors = FALSE)
        newenv <- oldenv[-grep("beaKey", oldenv),]
        write.table(newenv, renv, quote = FALSE, sep = "\n",
                    col.names = FALSE, row.names = FALSE)
      }
      else{
        tv <- readLines(renv)
        if(any(grepl("beaKey",tv))){
          stop("beaKey has previously been set. Overwrite it with the argument 'overwrite=TRUE'", call.=FALSE)
        }
      }
    }

    newKey <- paste0("beaKey='", APIkey, "'")
    # Append API key to .Renviron file
    write(newKey, renv, sep = "\n", append = TRUE)
    message('Your BEA API key has been stored in your .Renviron and can be accessed by Sys.getenv("beaKey"). \nTo use now, restart R or run `readRenviron("~/.Renviron")`')
    return(beaKey)
  } else {
    message("To install your BEA API key for future sessions, run this function with `install = TRUE`.")
    Sys.setenv(beaKey = APIkey)
  }

}
