beaParamValuesFiltered <- function(UserID = beaKey, DatasetName = "", TargetParameter = "", TableName = "", LineCode = "", ResultFormat = "json"){
  if (nchar(UserID)!=36){
    warning(paste0("'Invalid API Key: ",UserID," Register @ <https://apps.bea.gov/API/signup/>'"))
    return(paste0("'Invalid API Key: ",UserID," Register @ <https://apps.bea.gov/API/signup/>'"))
  }
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
      'Method' = "GetParameterValuesFiltered",
      'DatasetName' = DatasetName,
      'TargetParameter' = TargetParameter,
      'TableName' = TableName,
      'LineCode' = LineCode,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  return(dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["ParamValue"]]))
}
