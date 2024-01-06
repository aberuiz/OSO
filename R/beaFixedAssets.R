beaFixedAssets <- function(UserID = beaKey, TableName = "", Year = "", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'Method' = "GetData",
      'DatasetName' = "FixedAssets",
      'TableName' = TableName,
      'Year' = Year,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Data"]])
}
