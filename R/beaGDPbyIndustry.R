beaGDPbyIndustry <- function(UserID = beaKey, TableID = "", Industry = "", Frequency = "", Year = "", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'Method' = "GETDATA",
      'DatasetName' = "GDPbyIndustry",
      'TableID' = TableID,
      'Industry' = Industry,
      'Frequency' = Frequency,
      'Year' = Year,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  dplyr::bind_rows(response[["BEAAPI"]][["Results"]][[1]][["Data"]])
}
