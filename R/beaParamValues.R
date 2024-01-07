beaParamValues <- function(UserID = beaKey, DatasetName = "", ParameterName = "", ResultFormat = "json"){
  if (nchar(UserID)!=36){
    warning(paste0("'Invalid API Key: ",UserID,". Register @ <https://apps.bea.gov/API/signup/>'"))
    return(paste0("'Invalid API Key: ",UserID,". Register @ <https://apps.bea.gov/API/signup/>'"))
  }
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
  if ("Error" %in% names(response$BEAAPI$Results)) {
    warning(paste0(response$BEAAPI$Results$Error$APIErrorCode,": ",response$BEAAPI$Results$Error$APIErrorDescription, " Use beaParamList function to get a list of Parameters"))
    return(dplyr::bind_rows(response$BEAAPI$Results$Error))
  }
  return(dplyr::bind_rows(response[["BEAAPI"]][["Results"]][["ParamValue"]]))
}
