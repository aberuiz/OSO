beaRegional <- function(UserID = beaKey, TableName = "", LineCode = "", GeoFips = "", Year = "", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
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
  data <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Data"]])
  notes <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Notes"]])
  return(list(data, notes))
}

## Something wrong with viewing notes and data as DF
