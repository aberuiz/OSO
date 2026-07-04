#' Retrieve ITA (International Transactions Accounts) Data from BEA API
#'
#' @description
#' This function fetches International Transactions (balance of payments) data
#' from the Bureau of Economic Analysis (BEA) API. These accounts include all
#' transactions between U.S. and foreign residents.
#'
#' @param Indicator A character string specifying the indicator code for the type of transaction requested (e.g., "BalGds"). Multiple values can be supplied comma separated. Defaults to all indicators.
#' @param AreaOrCountry A character string specifying the counterparty area or country. "AllCountries" returns the total for all countries, while "All" returns all data available by area and country. Defaults to "AllCountries".
#' @param Frequency A character string indicating the frequency of the data: "A" for annual, "QSA" for quarterly seasonally adjusted, "QNSA" for quarterly not seasonally adjusted. Defaults to all frequencies.
#' @param Year A character string specifying the year(s) for which to retrieve data. Defaults to all years.
#' @param ResultFormat A character string specifying the format of the result (default is "json").
#' @param beaKey An optional character string for the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A dataframe containing the requested ITA data.
#'
#' @details Multiple Indicators can only be specified if a single AreaOrCountry is
#' specified, and a list of countries can only be specified if a single Indicator
#' is specified. Valid parameter values can be discovered with
#' `beaParamValues("ITA", "Indicator")`.
#'
#' @note Users need to register for a BEA API key at https://apps.bea.gov/API/signup/
#' and store it using `setbeaKey()` for seamless usage.
#'
#' @examples
#' \dontrun{
#' # Balance on goods with China for 2011 and 2012
#' data <- beaITA(Indicator = "BalGds", AreaOrCountry = "China",
#'                Frequency = "A", Year = "2011,2012")
#' }
#'
#' @seealso
#' \code{\link{beaParamValues}} for discovering indicator codes.
#' \code{\link{setbeaKey}} for setting the BEA API key.
#'
#' @importFrom httr2 request req_url_query req_throttle req_retry req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaITA <- function(Indicator = NULL, AreaOrCountry = NULL, Frequency = NULL, Year = NULL, ResultFormat = "json", beaKey = NULL){
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
      'DatasetName' = "ITA",
      'Indicator' = Indicator,
      'AreaOrCountry' = AreaOrCountry,
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
