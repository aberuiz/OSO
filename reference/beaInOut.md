# Retrieve Input-Output Data from the Bureau of Economic Analysis (BEA) API

This function fetches Input-Output data from the BEA API for a specified
table and year.

## Usage

``` r
beaInOut(TableID = "", Year = "", ResultFormat = "json", beaKey = NULL)
```

## Arguments

- TableID:

  A character string specifying the ID of the table to retrieve.

- Year:

  A character string specifying the year for which to retrieve data.

- ResultFormat:

  A character string specifying the format of the results. Default is
  "json".

- beaKey:

  An optional character string containing the BEA API key. If NULL, the
  function will attempt to retrieve the key using \`getbeaKey()\`.

## Value

A data frame containing the requested Input-Output data. If an error
occurs, it returns a data frame with error information.

## Details

This function requires a valid BEA API key. If not provided, it attempts
to retrieve one using getbeaKey(). The function will issue a warning if
the API key is invalid or if the API request results in an error.

## See also

<https://apps.bea.gov/API/signup/> for BEA API registration
[`getbeaKey`](https://aberuiz.github.io/OSO/reference/getbeaKey.md) for
retrieving a stored BEA API key

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve data for a specific table and year
data <- beaInOut(TableID = "59", Year = "2022")

# Use a specific API key
data <- beaInOut(TableID = "262", Year = "2022", beaKey = "YOUR_API_KEY")
} # }
```
