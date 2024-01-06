getDatasetList <- function(UserID = "", Method = "GETDATASETLIST", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'Method' =  Method,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  data <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Dataset"]])
}
