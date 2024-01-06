beaUnderlyingGDPbyIndustry <- function(UserID = beaKey, TableID = "", Industry = "", Year = "", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'Method' = "GETDATA",
      'DatasetName' = "UnderlyingGDPbyIndustry",
      'TableID' = TableID,
      'Industry' = Industry,
      'Frequency' = "A",
      'Year' = Year,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  data <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][[1]][["Data"]])
  notes <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][[1]][["Notes"]])
  return(list(data, notes))
#  print(notes)
}
