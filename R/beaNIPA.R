beaNIPA <- function(UserID = beaKey, TableName = "", Frequency = "", Year = "", ShowMillions = "N", ResultFormat = "JSON"){
  if (nchar(UserID)!=36){
    warning(paste0("'Invalid API Key: ",UserID,". Register @ <https://apps.bea.gov/API/signup/>'"))
    return(paste0("'Invalid API Key: ",UserID,". Register @ <https://apps.bea.gov/API/signup/>'"))
  }
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
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
