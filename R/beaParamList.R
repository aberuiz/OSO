beaParamList <- function(UserID = beaKey, DatasetName = "", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'Method' =  "GetParameterList",
      'DatasetName' = DatasetName,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  data <- dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["Parameter"]])
}
