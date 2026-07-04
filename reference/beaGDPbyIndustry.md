# Retrieve GDP by Industry data from the Bureau of Economic Analysis (BEA) API

This function fetches GDP by Industry data from the BEA API based on the
specified parameters.

## Usage

``` r
beaGDPbyIndustry(
  TableID = "",
  Industry = "",
  Frequency = "",
  Year = "",
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- TableID:

  Character string specifying the desired table ID.

- Industry:

  Character string specifying the industry code.

- Frequency:

  Character string specifying the frequency of the data (e.g., "A" for
  annual, "Q" for quarterly).

- Year:

  Character string specifying the year(s) for which data is requested.

- ResultFormat:

  Character string specifying the format of the results (default is
  "json").

- beaKey:

  Character string containing the BEA API key. If NULL, the function
  will attempt to retrieve it using \`getbeaKey()\`.

## Value

A data frame containing the requested GDP by Industry data. If an error
occurs, it returns an error message.

## Details

This function requires a valid BEA API key. If not provided, it attempts
to retrieve the key using \`getbeaKey()\`. The function will display a
warning and return an error message if the API key is invalid.

## Note

The function prints the statistic description and any notes returned by
the API.

## See also

<https://apps.bea.gov/API/signup/> for BEA API registration

## Examples

``` r
if (FALSE) { # \dontrun{
# Fetch annual GDP data for all industries in 2022
data <- beaGDPbyIndustry(TableID = "1", Industry = "ALL", Frequency = "A", Year = "2022")
} # }
```
