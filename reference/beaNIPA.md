# Retrieve NIPA (National Income and Product Accounts) Data from BEA API

This function fetches NIPA data from the Bureau of Economic Analysis
(BEA) API.

## Usage

``` r
beaNIPA(
  TableName = "",
  Frequency = "",
  Year = "",
  ShowMillions = "N",
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- TableName:

  A character string specifying the NIPA table name.

- Frequency:

  A character string indicating the frequency of the data (e.g., "A" for
  annual, "Q" for quarterly).

- Year:

  A character string specifying the year(s) for which to retrieve data.

- ShowMillions:

  A character string, either "Y" or "N", to display values in millions
  (default is "N").

- ResultFormat:

  A character string specifying the format of the result (default is
  "json").

- beaKey:

  An optional character string for the BEA API key. If NULL, the
  function will attempt to retrieve it using \`getbeaKey()\`.

## Value

A dataframe containing the requested NIPA data.

## Details

This function makes an API call to the BEA to retrieve NIPA data based
on the specified parameters. If no API key is provided, it attempts to
retrieve one using \`getbeaKey()\`. The function will display a warning
and return an error message if the API key is invalid.

## Note

Users need to register for a BEA API key at
https://apps.bea.gov/API/signup/ and store it using \`setbeaKey()\` for
seamless usage.

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve annual data for Table 1.1.5 for the year 2022
data <- beaNIPA(TableName = "T10105", Frequency = "A", Year = "2022")
} # }
```
