#' Get Parameter Values for BEA Dataset
#'
#' @description
#' Retrieves a data frame of available values for a specified parameter
#' within a given Bureau of Economic Analysis (BEA) dataset.
#'
#' @param DatasetName character. The name of the BEA dataset to query.
#' @param ParameterName character. The name of the parameter for which to retrieve values.
#' @param ResultFormat character. The format of the API response. Currently only "json" is supported. Default is "json".
#' @param beaKey character. Optional. The BEA API key. If NULL (default), it will be retrieved using `getbeaKey()`.
#'
#' @return A data frame containing available values for the specified parameter in the given dataset.
#'         If an error occurs, it returns a data frame with error information.
#'
#' @details
#' This function interacts with the BEA API to fetch parameter values for a specified dataset.
#' It requires a valid BEA API key, which can be set using the `setbeaKey()` function or
#' provided directly as an argument.
#'
#' @examples
#' # Get table names for the Regional dataset
#' beaParamValues(DatasetName = "Regional", ParameterName = "TableName")
#'
#' # Get available FIPS codes for the Regional dataset
#' beaParamValues(DatasetName = "Regional", ParameterName = "GeoFips")
#'
#' @seealso
#' \code{\link{setbeaKey}} for setting the BEA API key
#' \code{\link{getbeaKey}} for retrieving the stored BEA API key
#' \code{\link{beaParamList}} for getting a list of available parameters for a dataset
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
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
