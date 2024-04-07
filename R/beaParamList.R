#' Return dataset parameters
#' @description
#' Returns a data frame of all required and optional parameters for provided dataset
#'
#' @param DatasetName The name of the dataset
#' @param ResultFormat Currently OSO can only return data properly in json
#' @param beaKey Searches Sys.getenv by default. You may provide your API key here or save one with `setbeaKey`
#' @returns returns a list of all required and optional parameters for the dataset
#' @examples
#' beaParamList(DataSetName = "Regional")
#'
beaParamList <- function(DatasetName = "", ..., ResultFormat = "json", beaKey = NULL){
  if (is.null(beaKey)){
    beaKey <- getbeaKey()
  }
  if (nchar(beaKey)!=36){
    warning(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
    return(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
  }
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = beaKey,
      'Method' =  "GetParameterList",
      'DatasetName' = DatasetName,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  return(dplyr::bind_rows(response$BEAAPI$Results$Parameter))
}
