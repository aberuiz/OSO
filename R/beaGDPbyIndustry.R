#' Retrieve GDP by Industry data from the Bureau of Economic Analysis (BEA) API
#'
#' This function fetches GDP by Industry data from the BEA API based on the specified parameters.
#'
#' @param TableID Character string specifying the desired table ID.
#' @param Industry Character string specifying the industry code.
#' @param Frequency Character string specifying the frequency of the data (e.g., "A" for annual, "Q" for quarterly).
#' @param Year Character string specifying the year(s) for which data is requested.
#' @param ResultFormat Character string specifying the format of the results (default is "json").
#' @param beaKey Character string containing the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A data frame containing the requested GDP by Industry data. If an error occurs, it returns an error message.
#'
#' @details This function requires a valid BEA API key. If not provided, it attempts to retrieve the key using `getbeaKey()`.
#' The function will display a warning and return an error message if the API key is invalid.
#'
#' @note The function prints the statistic description and any notes returned by the API.
#'
#' @examples
#' \dontrun{
#' # Fetch annual GDP data for all industries in 2022
#' data <- beaGDPbyIndustry(TableID = "1", Industry = "ALL", Frequency = "A", Year = "2022")
#' }
#'
#' @seealso
#' \url{https://apps.bea.gov/API/signup/} for BEA API registration
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaGDPbyIndustry <- function(TableID = "", Industry = "", Frequency = "", Year = "", ResultFormat = "json", beaKey = NULL){
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
      'Method' = "GETDATA",
      'DatasetName' = "GDPbyIndustry",
      'TableID' = TableID,
      'Industry' = Industry,
      'Frequency' = Frequency,
      'Year' = Year,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  data <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][[1]][["Data"]])
  notes <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][[1]][["Notes"]])
  message(response[["BEAAPI"]][["Results"]][[1]][["Statistic"]])
  print(notes)
  return(data)
}
