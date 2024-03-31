beaMNE <- function(SeriesID = "", DirectionOfInvestment = "", Year = "", Classification = "", Industry = "", NonBankAffiliates = NULL, OwnershipLevel = NULL, Country = "", State = "", GetFootnotes = "yes", ResultFormat = "json", beaKey = NULL){
  if (is.null(beaKey)){
    beaKey <- getbeaKey()
  }
  if (nchar(beaKey)!=36){
    warning(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
    return(paste0("Invalid API Key: ",beaKey," Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"))
  }
  # Direct Investment
#  if (is.null(OwnershipLevel))

  # Activities of MNEs
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
      'NonBankAffiliatesOnly' = NonBankAffiliates,
      'OwnershipLevel' = OwnershipLevel,
      'Country' = Country,
      'State' = State,
      'GetFootnotes' = GetFootnotes,
      'ResultFormat' = ResultFormat
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
   if ("Error" %in% names(response$BEAAPI)) {
     warning(paste0(response$BEAAPI$Error$APIErrorCode,": ",response$BEAAPI$Error$APIErrorDescription))
     return(dplyr::bind_rows(response$BEAAPI$Error))
   }
 data <- dplyr::bind_rows(response$BEAAPI$Results$Data)
# data$DataValue <- as.numeric(data$DataValue)
 # names(data)[7] <- gsub(" ","_",
 #                        gsub(":","",response$BEAAPI$Results$Statistic))
 if (GetFootnotes == "yes"){
   print(dplyr::bind_rows(response$BEAAPI$Results$Notes))
 } else break
 # notes <- dplyr::bind_rows(response$BEAAPI$Results$Notes)
 # message(response$BEAAPI$Results$Statistic)
 # print(paste(notes[[2]]))
 return(data)
}

## Need to Add
# OwnershipLevel
# NonBankAffiliatesOnly

## Should I distinguish b/w Type 1: DirectInvestment & Type 2: Activities of Multinational Enterprises
