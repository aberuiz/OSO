#' Retrieve Regional BEA Tables
#'
#' @description
#' This function fetches data from Regional BEA Tables. It allows users to specify
#' table names, line codes, geographic areas, and years for which they need data.
#' Table names and line codes can be discovered using the `beaParamValues` function.
#'
#' @param TableName character. Specific table value to request (e.g., "CAGDP9").
#' @param LineCode numeric or character. Specific line from the specified table to request.
#' @param GeoFips character. Geographic area(s) for the requested data. Use FIPS codes.
#' @param Year numeric or character. Year(s) for which data is requested.
#' @param ResultFormat character. Format of the returned data. Currently only "json" is supported.
#' @param beaKey character. BEA API key. If NULL, searches for key in system environment.
#'
#' @return A data frame containing the requested BEA data with the following columns:
#'   \itemize{
#'     \item GeoFips: Geographic FIPS code
#'     \item GeoName: Name of the geographic area
#'     \item Code: Line code
#'     \item TimePeriod: Year of the data
#'     \item CL_UNIT: Classification unit
#'     \item UNIT_MULT: Unit multiplier
#'     \item DataValue: The actual data value (numeric)
#'     \item [Statistic]: The name of the statistic (column name varies)
#'   }
#'
#' @note
#' - The function will display a message with the statistic name and print any notes returned by the API.
#' - If an error occurs, the function will return the error information as a data frame.
#'
#' @examples
#' \dontrun{
#' # Fetch GDP data for the entire United States in 2022
#' gdp_data <- beaRegional(
#'   TableName = "CAGDP9",
#'   LineCode = 11,
#'   GeoFips = "00000",
#'   Year = 2022
#' )
#'
#' # Fetch data for multiple years
#' multi_year_data <- beaRegional(
#'   TableName = "CAGDP9",
#'   LineCode = 11,
#'   GeoFips = "00000",
#'   Year = "2020,2021,2022"
#' )
#' }
#'
#' @seealso
#' \code{\link{beaParamValues}} for discovering table names and line codes.
#' \code{\link{setbeaKey}} for setting the BEA API key.
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaRegional <- function(TableName = "", LineCode = "", GeoFips = "", Year = "", ResultFormat = "json", beaKey = NULL){
  if (is.null(beaKey)){
    beaKey <- getbeaKey()
  }
  if (nchar(beaKey)!=36){
    warning(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
    return(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
  }
  GeoFips <- gsub(" ", "", GeoFips)
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = beaKey,
      'Method' = "GETDATA",
      'DatasetName' = "Regional",
      'TableName' = TableName,
      'LineCode' = LineCode,
      'GeoFips' = GeoFips,
      'Year' = Year,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  data <- dplyr::bind_rows(response$BEAAPI$Results$Data)
  data$DataValue <- as.numeric(data$DataValue)
  names(data)[7] <- gsub(" ","_",
                         gsub(":","",response$BEAAPI$Results$Statistic))
  notes <- dplyr::bind_rows(response$BEAAPI$Results$Notes)
  message(response$BEAAPI$Results$Statistic)
  print(paste(notes[[2]]))
  return(data)
}
