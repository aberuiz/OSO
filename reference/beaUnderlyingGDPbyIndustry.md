# Fetch Underlying GDP by Industry Data from BEA API

This function retrieves Underlying GDP by Industry data from the Bureau
of Economic Analysis (BEA) API.

## Usage

``` r
beaUnderlyingGDPbyIndustry(
  TableID = "",
  Industry = "",
  Year = "",
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- TableID:

  A character string specifying the TableID for the desired data.

- Industry:

  A character string specifying the Industry code.

- Year:

  Year for which data is requested.

- ResultFormat:

  Default is "json".

- beaKey:

  A character string containing the BEA API key. If NULL, the function
  will attempt to retrieve it using \`getbeaKey()\`.

## Value

A data frame containing the requested Underlying GDP by Industry data.

## Details

This function makes a request to the BEA API to fetch Underlying GDP by
Industry data. It requires a valid BEA API key, which can be obtained
from https://apps.bea.gov/API/signup/. If the API key is not provided,
the function attempts to retrieve it using \`getbeaKey()\`.

## Note

The function will display a warning message if an invalid API key is
used. It also prints the statistic description and any notes returned by
the API.

## Examples

``` r
if (FALSE) { # \dontrun{
# Fetch data for a specific industry and year
data <- beaUnderlyingGDPbyIndustry(TableID = "1", Industry = "11", Year = "2022")
} # }
```
