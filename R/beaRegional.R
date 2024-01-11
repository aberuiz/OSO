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
  notes <- dplyr::bind_rows(response$BEAAPI$Results$Notes)
  message(response$BEAAPI$Results$Statistic)
  print(paste(notes[[2]]))
  return(data)
}
