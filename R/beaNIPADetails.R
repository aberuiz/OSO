#' Retrieve NIPA (National Income and Product Accounts) Details from BEA API
#'
#' @description
#' This function fetches NIPA details from the Bureau of Economic Analysis (BEA) API
#'
#' @param TableName A character string specifying the NIPA table name.
#' @param Frequency A character string indicating the frequency of the data (e.g., "A" for annual, "Q" for quarterly).
#' @param Year A character string or numeric value representing the year(s) for which data is requested.
#' @param ResultFormat A character string specifying the format of the result. Default is "json".
#' @param beaKey An optional character string containing the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A dataframe containing the requested NIPA data.
#'
#' @details
#' This function requires a valid BEA API key. If not provided, it attempts to retrieve one using `getbeaKey()`.
#' Users can register for an API key at https://apps.bea.gov/API/signup/
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @examples
#' \dontrun{
#' # Fetch annual data for a specific table and year
#' data <- beaNIPADetails(TableName = "T10101", Frequency = "A", Year = "2022")
#'
#' # Fetch quarterly data for a specific table and multiple years
#' data <- beaNIPADetails(TableName = "T10101", Frequency = "Q", Year = "2021,2022")
#' }
#'
#' @export
beaNIPADetails <- function(TableName = "", Frequency = "", Year = "", ResultFormat = "json", beaKey = NULL){
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
      'DatasetName' = "NIUnderlyingDetail",
      'TableName' = TableName,
      'Frequency' = Frequency,
      'Year' = Year,
      'Result' = ResultFormat,
      'Method' =  "GETDATA"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  return(dplyr::bind_rows(response$BEAAPI$Results$Data))
}
