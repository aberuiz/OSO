#' Return data frame of parameter values
#' @description
#' Returns a data frame of available values for the provided parameter for provided dataset
#'
#' @param DatasetName The name of the dataset
#' @param ParameterName Provides values for the named parameter
#' @param ResultFormat Currently OSO can only return data properly in json
#' @param beaKey Searches Sys.getenv by default. You may provide your API key here or save one with `setbeaKey`
#' @returns data frame of available values for the provided parameter for provided dataset
#' @examples
#' beaParamValues(DataSetName = "Regional", ParameterName = "TableName")
#'
#' beaParamValues(DataSetName = "Regional", ParameterName = "GeoFips")
beaParamValues <- function(DatasetName = "", ParameterName = "", ResultFormat = "json", beaKey = NULL){
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
      'Method' =  "GETParameterValues",
      'DatasetName' = DatasetName,
      'ParameterName' = ParameterName,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI$Results)) {
    warning(paste0(response$BEAAPI$Results$Error$APIErrorCode,": ",response$BEAAPI$Results$Error$APIErrorDescription, " Use beaParamList function to get a list of Parameters"))
    return(dplyr::bind_rows(response$BEAAPI$Results$Error))
  }
  return(dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["ParamValue"]]))
}
