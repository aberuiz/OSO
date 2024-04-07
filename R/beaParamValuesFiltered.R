#' Return a data frame of filtered parameter values
#' @description
#' Returns a data frame of available parameter values as filtered by another parameter
#'
#' @param DatasetName The name of the dataset
#' @param ParameterName Provides values for the named parameter
#' @param TableName Specific BEA table to filter
#' @param LineCode Specific line to filter
#' @param ResultFormat Currently OSO can only return data properly in json
#' @param beaKey Searches Sys.getenv by default. You may provide your API key here or save one with `setbeaKey`
#' @returns data frame of available values for the provided parameter for provided dataset
#' @examples
#' beaParamValuesFiltered(
#'   DatasetName = "Regional",
#'   TargetParameter = "linecode",
#'   TableName = "CAGDP9"
#'   )
#' @export
beaParamValuesFiltered <- function(DatasetName = "", TargetParameter = "", TableName = "", LineCode = "", ResultFormat = "json", beaKey = NULL){
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
      'Method' = "GetParameterValuesFiltered",
      'DatasetName' = DatasetName,
      'TargetParameter' = TargetParameter,
      'TableName' = TableName,
      'LineCode' = LineCode,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  return(dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["ParamValue"]]))
}
