#' Retrieve IntlServSTA (International Services Supplied Through Affiliates) Data from BEA API
#'
#' @description
#' This function fetches annual data on services supplied through U.S.-owned
#' foreign affiliates to foreign markets and through foreign-owned U.S. affiliates
#' to the United States from the Bureau of Economic Analysis (BEA) API.
#'
#' @param Channel A character string specifying the channel through which the service is supplied: "Mofas", "Mousas", "AllChannels", "Trade", "UsExportsByMousas", or "UsImportsFromMofas". Defaults to all channels.
#' @param Destination A character string specifying the location and affiliation of the recipient of the service (e.g., "AllForeign", "HostCtry", "AllUs"). Defaults to all destinations.
#' @param Industry A character string specifying the industry of the affiliate supplying the service. "AllInd" returns the total for all industries, while "All" returns all data available by industry. Defaults to all industries.
#' @param AreaOrCountry A character string specifying, for MOFAs, the area or country of the affiliate; for MOUSAs, the area or country of the Ultimate Beneficial Owner (UBO) of the affiliate. "AllCountries" returns the total for all countries, while "All" returns all data available by area and country. Defaults to "AllCountries".
#' @param Year A character string specifying the year(s) for which to retrieve data. Defaults to all years.
#' @param ResultFormat A character string specifying the format of the result (default is "json").
#' @param beaKey An optional character string for the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A dataframe containing the requested International Services Supplied Through Affiliates data.
#'
#' @details Valid parameter values can be discovered with
#' `beaParamValues("IntlServSTA", "Channel")` and similar calls for the other
#' parameters.
#'
#' @note Users need to register for a BEA API key at https://apps.bea.gov/API/signup/
#' and store it using `setbeaKey()` for seamless usage.
#'
#' @examples
#' \dontrun{
#' # Services supplied through MOFAs in retail trade to all foreign persons
#' # in India in 2015 and 2016
#' data <- beaIntlServSTA(Channel = "Mofas", Destination = "AllForeign",
#'                        Industry = "RetailTrade", AreaOrCountry = "India",
#'                        Year = "2015,2016")
#' }
#'
#' @seealso
#' \code{\link{beaIntlServTrade}} for U.S. international trade in services.
#' \code{\link{beaParamValues}} for discovering valid parameter values.
#' \code{\link{setbeaKey}} for setting the BEA API key.
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaIntlServSTA <- function(Channel = NULL, Destination = NULL, Industry = NULL, AreaOrCountry = NULL, Year = NULL, ResultFormat = "json", beaKey = NULL){
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
      'DatasetName' = "IntlServSTA",
      'Channel' = Channel,
      'Destination' = Destination,
      'Industry' = Industry,
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
