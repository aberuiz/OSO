#' Retrieve NIPA (National Income and Product Accounts) Data from BEA API
#'
#' @description
#' This function fetches NIPA data from the Bureau of Economic Analysis (BEA) API.
#'
#' @param TableName A character string specifying the NIPA table name.
#' @param Frequency A character string indicating the frequency of the data (e.g., "A" for annual, "Q" for quarterly).
#' @param Year A character string specifying the year(s) for which to retrieve data.
#' @param ShowMillions A character string, either "Y" or "N", to display values in millions (default is "N").
#' @param ResultFormat A character string specifying the format of the result (default is "json").
#' @param beaKey An optional character string for the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A dataframe containing the requested NIPA data.
#'
#' @details This function makes an API call to the BEA to retrieve NIPA data based on the specified parameters.
#' If no API key is provided, it attempts to retrieve one using `getbeaKey()`.
#' The function will display a warning and return an error message if the API key is invalid.
#'
#' @note Users need to register for a BEA API key at https://apps.bea.gov/API/signup/
#' and store it using `setbeaKey()` for seamless usage.
#'
#' @examples
#' \dontrun{
#' # Retrieve annual data for Table 1.1.5 for the year 2022
#' data <- beaNIPA(TableName = "T10105", Frequency = "A", Year = "2022")
#' }
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaNIPA <- function(TableName = "", Frequency = "", Year = "", ShowMillions = "N", ResultFormat = "json", beaKey = NULL){
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
      'Method' =  "GETDATA",
      'DatasetName' = "NIPA",
      'TableName' = TableName,
      'Frequency' = Frequency,
      'Year' = Year,
      'ShowMillions' = ShowMillions,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  message(response$BEAAPI$Results$Statistic)
  print(paste(response[["BEAAPI"]][["Results"]][["Notes"]][[1]][["NoteText"]]))
  return(dplyr::bind_rows(response$BEAAPI$Results$Data))
}
