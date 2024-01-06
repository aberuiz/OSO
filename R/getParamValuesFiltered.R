getParamValuesFiltered <- function(UserID = "", DatasetName = "", TargetParameter = "", TableName = "", ResultFormat = "json", Method = "GetParameterValuesFiltered"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'DatasetName' = DatasetName,
      'TargetParameter' = TargetParameter,
      'TableName' = TableName,
      'Result' = ResultFormat,
      'Method' = Method
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
