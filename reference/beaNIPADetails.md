# Retrieve NIPA (National Income and Product Accounts) Details from BEA API

This function fetches NIPA details from the Bureau of Economic Analysis
(BEA) API

## Usage

``` r
beaNIPADetails(
  TableName = "",
  Frequency = "",
  Year = "",
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

  A character string or numeric value representing the year(s) for which
  data is requested.

- ResultFormat:

  A character string specifying the format of the result. Default is
  "json".

- beaKey:

  An optional character string containing the BEA API key. If NULL, the
  function will attempt to retrieve it using \`getbeaKey()\`.

## Value

A dataframe containing the requested NIPA data.

## Details

This function requires a valid BEA API key. If not provided, it attempts
to retrieve one using \`getbeaKey()\`. Users can register for an API key
at https://apps.bea.gov/API/signup/

## Examples

``` r
if (FALSE) { # \dontrun{
# Fetch annual data for a specific table and year
data <- beaNIPADetails(TableName = "T10101", Frequency = "A", Year = "2022")

# Fetch quarterly data for a specific table and multiple years
data <- beaNIPADetails(TableName = "T10101", Frequency = "Q", Year = "2021,2022")
} # }
```
