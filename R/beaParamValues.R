beaParamValues <- function(UserID = beaKey, DatasetName = "", ParameterName = "", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'Method' =  "GETParameterValues",
      'DatasetName' = DatasetName,
      'ParameterName' = ParameterName,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["ParamValue"]])
}
