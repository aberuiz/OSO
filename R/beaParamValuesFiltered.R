#' Filter and retrieve parameter values from BEA datasets
#'
#' @description
#' This function queries the Bureau of Economic Analysis (BEA) API to retrieve a filtered set of parameter values
#' for a specified dataset. It allows for filtering based on table name and line code.
#'
#' @param DatasetName Character string. The name of the BEA dataset to query (e.g., "Regional").
#' @param TargetParameter Character string. The name of the parameter for which to retrieve values.
#' @param TableName Character string. Optional. Specific BEA table name to filter the results.
#' @param LineCode Character string. Optional. Specific line code to further filter the results.
#' @param ResultFormat Character string. The format of the API response. Currently only supports "json".
#' @param beaKey Character string. Optional. Your BEA API key. If not provided, it will be retrieved from the environment.
#'
#' @return A data frame containing the filtered parameter values for the specified dataset and criteria.
#'
#' @examples
#' \dontrun{
#' # Retrieve filtered line codes for the Regional dataset, table CAGDP9
#' result <- beaParamValuesFiltered(
#'   DatasetName = "Regional",
#'   TargetParameter = "LineCode",
#'   TableName = "CAGDP9"
#' )
#'
#' # Retrieve parameter values with additional line code filter
#' result <- beaParamValuesFiltered(
#'   DatasetName = "Regional",
#'   TargetParameter = "GeoFips",
#'   TableName = "CAGDP2",
#'   LineCode = "1"
#' )
#' }
#'
#' @details
#' This function interacts with the BEA API to retrieve filtered parameter values. It requires a valid BEA API key,
#' which can be obtained from \url{https://apps.bea.gov/API/signup/}. The API key can be provided directly to the
#' function or set in the environment using the `setbeaKey` function.
#'
#' If an error occurs during the API request, the function will return a data frame with error information.
#'
#' @seealso
#' \code{\link{setbeaKey}} for setting the BEA API key
#' \code{\link{getbeaKey}} for retrieving the stored BEA API key
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
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
