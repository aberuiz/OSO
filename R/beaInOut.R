#' Retrieve Input-Output Data from the Bureau of Economic Analysis (BEA) API
#'
#' @description
#' This function fetches Input-Output data from the BEA API for a specified table and year.
#'
#' @param TableID A character string specifying the ID of the table to retrieve.
#' @param Year A character string specifying the year for which to retrieve data.
#' @param ResultFormat A character string specifying the format of the results. Default is "json".
#' @param beaKey An optional character string containing the BEA API key. If NULL, the function will attempt to retrieve the key using `getbeaKey()`.
#'
#' @return A data frame containing the requested Input-Output data. If an error occurs, it returns a data frame with error information.
#'
#' @details This function requires a valid BEA API key. If not provided, it attempts to retrieve one using getbeaKey().
#' The function will issue a warning if the API key is invalid or if the API request results in an error.
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Retrieve data for a specific table and year
#' data <- beaInOut(TableID = "59", Year = "2022")
#'
#' # Use a specific API key
#' data <- beaInOut(TableID = "262", Year = "2022", beaKey = "YOUR_API_KEY")
#' }
#'
#' @seealso
#' \url{https://apps.bea.gov/API/signup/} for BEA API registration
#' \code{\link{getbeaKey}} for retrieving a stored BEA API key
beaInOut <- function(TableID = "", Year = "", ResultFormat = "json", beaKey = NULL){
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
      'DatasetName' = "InputOutput",
      'TableID' = TableID,
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
  return(dplyr::bind_rows(response[["BEAAPI"]][["Results"]][[1]][["Data"]]))

}
