#' Retrieve MNE (Direct Investment and Multinational Enterprises) Data from BEA API
#'
#' @description
#' This function fetches data on Direct Investment (DI) and Activities of
#' Multinational Enterprises (AMNE) from the Bureau of Economic Analysis (BEA)
#' API. Direct Investment covers income and financial transactions in direct
#' investment and direct investment positions. AMNE covers operations and
#' finances of U.S. parent enterprises and their foreign affiliates and U.S.
#' affiliates of foreign MNEs.
#'
#' @param SeriesID An integer or character string specifying the data series identifier(s). Multiple values can be supplied comma separated. Defaults to all series.
#' @param DirectionOfInvestment A character string. For DI requests: "Outward" (U.S. direct investment abroad) or "Inward" (foreign investment in the U.S.). AMNE requests also accept "State" and "Parent". Required.
#' @param Year A character string specifying the year(s) for which to retrieve data.
#' @param Classification A character string specifying results by country and/or industry (e.g., "Country", "CountryByIndustry"). Required.
#' @param Industry A character string specifying the industry code(s). Defaults to all industries.
#' @param NonBankAffiliates 0 for both bank and nonbank affiliates, 1 for nonbank affiliates only. Required for AMNE requests; leave NULL for DI requests.
#' @param OwnershipLevel 0 for majority-owned affiliates, 1 for all affiliates. Required for AMNE requests; leave NULL for DI requests.
#' @param Country A character string specifying the geographic area code(s). Defaults to all countries.
#' @param State A character string specifying the two-digit state FIPS code (AMNE requests only). Defaults to all states.
#' @param GetFootnotes A character string, "yes" or "no", indicating whether to print footnotes (default is "yes").
#' @param ResultFormat A character string specifying the format of the result (default is "json").
#' @param beaKey An optional character string for the BEA API key. If NULL, the function will attempt to retrieve it using `getbeaKey()`.
#'
#' @return A dataframe containing the requested MNE data.
#'
#' @details Direct Investment (DI) and AMNE requests share most parameters, but
#' `OwnershipLevel` and `NonBankAffiliates` apply only to AMNE requests. Valid
#' parameter values can be discovered with `beaParamValues("MNE", "SeriesID")`
#' and similar calls for the other parameters.
#'
#' @note Users need to register for a BEA API key at https://apps.bea.gov/API/signup/
#' and store it using `setbeaKey()` for seamless usage.
#'
#' @examples
#' \dontrun{
#' # U.S. direct investment position in China and Asia for 2011 and 2012
#' data <- beaMNE(SeriesID = "30", DirectionOfInvestment = "Outward",
#'                Classification = "Country", Country = "650,699",
#'                Year = "2011,2012")
#'
#' # Net income and sales for Brazilian affiliates of U.S. parent
#' # enterprises, all industries, 2011 and 2012
#' data <- beaMNE(SeriesID = "4,5", DirectionOfInvestment = "Outward",
#'                Classification = "CountryByIndustry", Country = "202",
#'                Industry = "all", Year = "2011,2012",
#'                NonBankAffiliates = 0, OwnershipLevel = 0)
#' }
#'
#' @seealso
#' \code{\link{beaParamValues}} for discovering valid parameter values.
#' \code{\link{setbeaKey}} for setting the BEA API key.
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaMNE <- function(SeriesID = "", DirectionOfInvestment = "", Year = "", Classification = "", Industry = "", NonBankAffiliates = NULL, OwnershipLevel = NULL, Country = "", State = "", GetFootnotes = "yes", ResultFormat = "json", beaKey = NULL){
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
      'DatasetName' = "MNE",
      'SeriesID' = SeriesID,
      'DirectionOfInvestment' = DirectionOfInvestment,
      'Year' = Year,
      'Classification' = Classification,
      'Industry' = Industry,
      'NonBankAffiliatesOnly' = NonBankAffiliates,
      'OwnershipLevel' = OwnershipLevel,
      'Country' = Country,
      'State' = State,
      'GetFootnotes' = GetFootnotes,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  data <- dplyr::bind_rows(response$BEAAPI$Results$Data)
  if (GetFootnotes == "yes"){
    print(dplyr::bind_rows(response$BEAAPI$Results$Notes))
  }
  return(data)
}
