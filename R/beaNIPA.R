beaNIPA <- function(TableName = "", Frequency = "", Year = "", ShowMillions = "N", ResultFormat = "json", beaKey = NULL){
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
      'Method' =  "GETDATA",
      'DatasetName' = "NIPA",
      'TableName' = TableName,
      'Frequency' = Frequency,
      'Year' = Year,
      'ShowMillions' = ShowMillions,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  message(response$BEAAPI$Results$Statistic)
  print(paste(response[["BEAAPI"]][["Results"]][["Notes"]][[1]][["NoteText"]]))
  return(dplyr::bind_rows(response$BEAAPI$Results$Data))
}
