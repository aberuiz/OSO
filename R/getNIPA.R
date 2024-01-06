getNIPA <- function(UserID = "", TableName = "", Frequency = "", Year = "", ShowMillions = "N", ResultFormat = "JSON", Method = "GETDATA"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'DatasetName' = DatasetName,
#      'ParameterName' = ParameterName,
      'TableName' = TableName,
      'Frequency' = Frequency,
      'Year' = Year,
      'ShowMillions' = ShowMillions,
      'Result' = ResultFormat,
      'Method' =  Method
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
