#' Return Regional BEA Tables
#'
#' @description
#' Returns Regional BEA Tables. Table names and Line codes can be discovered with `beaParamValues`
#'
#' @param TableName Specific table value to request
#' @param LineCode Specific line from the specified table to request
#' @param GeoFips Geographic area(s) for the above data
#' @param Year Year(s) requested
#' @param ResultFormat Currently OSO can only return data properly in json
#' @param beaKey Will search sys.env by default. You may provide your API key here or save one with `setbeaKey`
#' @returns Table and Line code values from BEA in a data frame
#'
#' @examples
#' beaRegional(
#'   TableName = "CAGDP9",
#'   LineCode = 11,
#'   GeoFips = "00000",
#'   Year = 2022
#' )
#'
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
