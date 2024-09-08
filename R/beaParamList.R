#' Retrieve dataset parameters BEA
#'
#' @description
#' This function returns a data frame containing all required and optional parameters
#' for a specified dataset from the Bureau of Economic Analysis (BEA) API.
#'
#' @param DatasetName A character string specifying the name of the dataset.
#' @param ResultFormat A character string specifying the format of the result.
#'   Currently, only "json" is supported. Defaults to "json".
#' @param beaKey A character string containing the BEA API key. If NULL (default),
#'   the function will attempt to retrieve the key using `getbeaKey()`.
#' @param ... Additional arguments passed to the function (currently unused).
#'
#' @return A dataframe containing all required and optional parameters
#'   for the specified dataset. If an error occurs, it returns an error message.
#'
#' @examples
#' \dontrun{
#' # Retrieve parameters for the Regional dataset
#' regional_params <- beaParamList(DatasetName = "Regional")
#'
#' # Using a specific API key
#' params <- beaParamList(DatasetName = "NIPA", beaKey = "YOUR-API-KEY-HERE")
#' }
#'
#' @details
#' This function interacts with the BEA API to retrieve parameter information
#' for a specified dataset. It requires a valid BEA API key, which can be
#' obtained from https://apps.bea.gov/API/signup/
#'
#' If no API key is provided, the function attempts to retrieve one using
#' `getbeaKey()`. Ensure you have set your API key using `setbeaKey()` before
#' running this function without explicitly providing a key.
#'
#' @seealso
#' \code{\link{setbeaKey}} for setting your BEA API key
#' \code{\link{getbeaKey}} for retrieving your stored BEA API key
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#' @importFrom dplyr bind_rows
#'
#' @export
beaParamList <- function(DatasetName = "", ..., ResultFormat = "json", beaKey = NULL){
  if (is.null(beaKey)){
    beaKey <- getbeaKey()
  }
  if (nchar(beaKey)!=36){
    warning(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
    return(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
  }
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = beaKey,
      'Method' =  "GetParameterList",
      'DatasetName' = DatasetName,
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  return(dplyr::bind_rows(response$BEAAPI$Results$Parameter))
}
