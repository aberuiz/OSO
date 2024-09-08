#' Fetch Underlying GDP by Industry Data from BEA API
#'
#' This function retrieves Underlying GDP by Industry data from the Bureau of Economic Analysis (BEA) API.
#'
#' @param TableID A character string specifying the TableID for the desired data.
#' @param Industry A character string specifying the Industry code.
#' @param Year Year for which data is requested.
#' @param ResultFormat Default is "json".
#' @param beaKey A character string containing the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A data frame containing the requested Underlying GDP by Industry data.
#'
#' @details This function makes a request to the BEA API to fetch Underlying GDP by Industry data.
#' It requires a valid BEA API key, which can be obtained from https://apps.bea.gov/API/signup/.
#' If the API key is not provided, the function attempts to retrieve it using `getbeaKey()`.
#'
#' @note The function will display a warning message if an invalid API key is used.
#' It also prints the statistic description and any notes returned by the API.
#'
#' @examples
#' \dontrun{
#' # Fetch data for a specific industry and year
#' data <- beaUnderlyingGDPbyIndustry(TableID = "1", Industry = "11", Year = "2022")
#' }
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaUnderlyingGDPbyIndustry <- function(TableID = "", Industry = "", Year = "", ResultFormat = "json", beaKey = NULL){
  if (is.null(APIkey)){
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
      'DatasetName' = "UnderlyingGDPbyIndustry",
      'TableID' = TableID,
      'Industry' = Industry,
      'Frequency' = "A",
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
  print(paste(notes))
  return(data)
}
