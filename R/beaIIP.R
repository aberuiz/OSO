#' Retrieve IIP (International Investment Position) Data from BEA API
#'
#' @description
#' This function fetches International Investment Position data from the Bureau
#' of Economic Analysis (BEA) API. These accounts include the end of period value
#' of accumulated stocks of U.S. financial assets and liabilities.
#'
#' @param TypeOfInvestment A character string specifying the type of investment (e.g., "FinAssetsExclFinDeriv"). Multiple values can be supplied comma separated. Defaults to all types.
#' @param Component A character string specifying either the position ("Pos") or a component in the change of position from the previous period (e.g., "ChgPosPrice"). Defaults to all components.
#' @param Frequency A character string indicating the frequency of the data: "A" for annual, "QNSA" for quarterly not seasonally adjusted. Defaults to all frequencies.
#' @param Year A character string specifying the year(s) for which to retrieve data. Defaults to all years.
#' @param ResultFormat A character string specifying the format of the result (default is "json").
#' @param beaKey An optional character string for the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A dataframe containing the requested IIP data.
#'
#' @details More than one TypeOfInvestment can only be specified if a single Year
#' is specified, and more than one Year can only be specified if a single
#' TypeOfInvestment is specified. Valid parameter values can be discovered with
#' `beaParamValues("IIP", "TypeOfInvestment")`.
#'
#' @note Users need to register for a BEA API key at https://apps.bea.gov/API/signup/
#' and store it using `setbeaKey()` for seamless usage.
#'
#' @examples
#' \dontrun{
#' # U.S. assets excluding financial derivatives; change in position
#' # attributable to price changes for all available years
#' data <- beaIIP(TypeOfInvestment = "FinAssetsExclFinDeriv",
#'                Component = "ChgPosPrice", Frequency = "A", Year = "ALL")
#' }
#'
#' @seealso
#' \code{\link{beaParamValues}} for discovering types of investment and components.
#' \code{\link{setbeaKey}} for setting the BEA API key.
#'
#' @importFrom httr2 request req_url_query req_throttle req_retry req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaIIP <- function(TypeOfInvestment = NULL, Component = NULL, Frequency = NULL, Year = NULL, ResultFormat = "json", beaKey = NULL){
  if (is.null(beaKey)){
    beaKey <- getbeaKey()
  }
  if (nchar(beaKey)!=36){
    warning(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
    return(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
  }
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_throttle(capacity = 100, fill_time_s = 60) |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_url_query(
      'UserID' = beaKey,
      'Method' = "GETDATA",
      'DatasetName' = "IIP",
      'TypeOfInvestment' = TypeOfInvestment,
      'Component' = Component,
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
  if ("Error" %in% names(response$BEAAPI$Results)) {
    warning(paste0(response$BEAAPI$Results$Error$APIErrorCode,": ",response$BEAAPI$Results$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Results$Error))
  }
  return(dplyr::bind_rows(response$BEAAPI$Results$Data))
}
