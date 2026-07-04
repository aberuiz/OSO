#' Retrieve IntlServTrade (International Services Trade) Data from BEA API
#'
#' @description
#' This function fetches annual data on U.S. international trade in services from
#' the Bureau of Economic Analysis (BEA) API. Statistics on services supplied
#' through affiliates by multinational enterprises are not included in this
#' dataset (see `beaIntlServSTA()`).
#'
#' @param TypeOfService A character string specifying the type of service being traded (e.g., "Telecom", "AllTypesOfService"). Multiple values can be supplied comma separated. Defaults to all types.
#' @param TradeDirection A character string specifying the trade direction: "Exports", "Imports", "Balance" (exports less imports), or "SupplementalIns" (supplemental detail on insurance transactions). Defaults to all directions.
#' @param Affiliation A character string specifying the affiliation: "AllAffiliations", "Unaffiliated", "Affiliated", "UsParents", or "UsAffiliates". Defaults to all affiliations.
#' @param AreaOrCountry A character string specifying the counterparty area or country. "AllCountries" returns the total for all countries, while "All" returns all data available by area and country. Defaults to "AllCountries".
#' @param Year A character string specifying the year(s) for which to retrieve data. Defaults to all years.
#' @param ResultFormat A character string specifying the format of the result (default is "json").
#' @param beaKey An optional character string for the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A dataframe containing the requested International Services Trade data.
#'
#' @details Multiple TypeOfService values can only be specified if a single
#' AreaOrCountry is specified, and a list of countries can only be specified if a
#' single TypeOfService is specified. Valid parameter values can be discovered
#' with `beaParamValues("IntlServTrade", "TypeOfService")`.
#'
#' @note Users need to register for a BEA API key at https://apps.bea.gov/API/signup/
#' and store it using `setbeaKey()` for seamless usage.
#'
#' @examples
#' \dontrun{
#' # Imports of services from Germany for 2014 and 2015
#' data <- beaIntlServTrade(TypeOfService = "AllTypesOfService",
#'                          TradeDirection = "Imports",
#'                          Affiliation = "AllAffiliations",
#'                          AreaOrCountry = "Germany", Year = "2014,2015")
#' }
#'
#' @seealso
#' \code{\link{beaIntlServSTA}} for services supplied through affiliates.
#' \code{\link{beaParamValues}} for discovering valid parameter values.
#' \code{\link{setbeaKey}} for setting the BEA API key.
#'
#' @importFrom httr2 request req_url_query req_throttle req_retry req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaIntlServTrade <- function(TypeOfService = NULL, TradeDirection = NULL, Affiliation = NULL, AreaOrCountry = NULL, Year = NULL, ResultFormat = "json", beaKey = NULL){
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
      'DatasetName' = "IntlServTrade",
      'TypeOfService' = TypeOfService,
      'TradeDirection' = TradeDirection,
      'Affiliation' = Affiliation,
      'AreaOrCountry' = AreaOrCountry,
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
