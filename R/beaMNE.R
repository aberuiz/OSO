beaMNE <- function(SeriesID = "", DirectionOfInvestment = "", Year = "", Classification = "", Industry = "", Country = "", State = "", GetFootnotes = "", ResultFormat = "json", beaKey = NULL){
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
      'Method' = "GetData",
      'DatasetName' = "MNE",
      'SeriesID' = SeriesID,
      'DirectionOfInvestment' = DirectionOfInvestment,
      'Year' = Year,
      'Classification' = Classification,
      'Industry' = Industry,
      'Country' = Country,
      'State' = State,
      'GetFootnotes' = GetFootnotes,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

## Need to Add
# OwnershipLevel
# NonBankAffiliatesOnly

## Should I distinguish b/w Type 1: DirectInvestment & Type 2: Activities of Multinational Enterprises
