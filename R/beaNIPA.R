beaNIPA <- function(UserID = beaKey, TableName = "", Frequency = "", Year = "", ShowMillions = "N", ResultFormat = "JSON"){
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
  dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Data"]])
}
