getNIPADetails <- function(UserID = "", TableName = "", Frequency = "", Year = "", ResultFormat = "JSON"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'DatasetName' = "NIUnderlyingDetail",
      'TableName' = TableName,
      'Frequency' = Frequency,
      'Year' = Year,
      'Result' = ResultFormat,
      'Method' =  "GETDATA"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Data"]])
}
