#' Retrieve Fixed Assets Data from the Bureau of Economic Analysis (BEA) API
#'
#' This function fetches fixed assets data from the BEA API based on the specified parameters.
#'
#' @param TableName A character string specifying the table name for the fixed assets data.
#' @param Year A character string specifying the year(s) for which to retrieve data.
#' @param ResultFormat A character string specifying the format of the results. Default is "json".
#' @param beaKey An optional character string containing the BEA API key. If NULL, the function will attempt to retrieve the key using `getbeaKey()`.
#'
#' @return A tibble containing the retrieved fixed assets data. If an error occurs, it returns a tibble with error information.
#'
#' @details This function requires a valid BEA API key. If not provided, it attempts to retrieve one using `getbeaKey()`.
#' If the API key is invalid, a warning is issued and an error message is returned.
#'
#' @examples
#' \dontrun{
#' # Fetch fixed assets data for a specific table and year
#' data <- beaFixedAssets(TableName = "FAAt201", Year = 2020)
#'
#' # Fetch data with a custom API key
#' data <- beaFixedAssets(TableName = "FAAt201", Year = "2019-2020", beaKey = "your-api-key-here")
#' }
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaFixedAssets <- function(TableName = "", Year = "", ResultFormat = "json", beaKey = NULL){
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
      'Method' = "GetData",
      'DatasetName' = "FixedAssets",
      'TableName' = TableName,
      'Year' = Year,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  message(response[["BEAAPI"]][["Results"]][["Statistic"]])
  return(dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Data"]]))
}
