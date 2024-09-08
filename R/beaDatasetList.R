#' Retrieve List of Available Datasets from Bureau of Economic Analysis (BEA) API
#'
#' @description
#' This function retrieves a list of available datasets from the Bureau of Economic Analysis (BEA) API.
#' It requires a valid API key and can return results in different formats.
#'
#' @param ResultFormat A character string specifying the desired format of the results.
#'   Default is "json". Other possible values may include "xml" (check BEA API documentation for all options).
#' @param beaKey A character string containing the BEA API key. If NULL (default),
#'   the function will attempt to retrieve the key using `getbeaKey()`.
#'
#' @return If ResultFormat is "json", returns a tibble (data frame) containing information about available datasets.
#'   For other formats, returns the raw API response.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Retrieve dataset list using default JSON format
#' datasets <- beaDatasetList()
#'
#' # Retrieve dataset list using a specific API key
#' datasets <- beaDatasetList(beaKey = "YOUR-API-KEY-HERE")
#'
#' # Retrieve dataset list in XML format
#' datasets_xml <- beaDatasetList(ResultFormat = "xml")
#' }
#'
#' @seealso
#' \url{https://apps.bea.gov/API/signup/} for BEA API registration
#'
#' @references
#' Bureau of Economic Analysis (BEA) API: \url{https://apps.bea.gov/API/docs/index.htm}
beaDatasetList <- function(ResultFormat = "json", beaKey = NULL){
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
      'Method' = "GETDATASETLIST",
      'Result' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if ("Error" %in% names(response$BEAAPI)) {
    warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
    return(dplyr::bind_rows(response$BEAAPI$Error))
  }
  return(dplyr::bind_rows(response$BEAAPI$Results$Dataset))
}
