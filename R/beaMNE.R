beaMNE <- function(UserID = beaKey, SeriesID = "", DirectionOfInvestment = "", Year = "", Classification = "", Industry = "", Country = "", State = "", GetFootnotes = "", ResultFormat = "json"){
  response <- httr2::request("https://apps.bea.gov/api/data") |>
    httr2::req_url_query(
      'UserID' = UserID,
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
