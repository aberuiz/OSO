# Retrieve Regional BEA Tables

This function fetches data from Regional BEA Tables. It allows users to
specify table names, line codes, geographic areas, and years for which
they need data. Table names and line codes can be discovered using the
\`beaParamValues\` function.

## Usage

``` r
beaRegional(
  TableName = "",
  LineCode = "",
  GeoFips = "",
  Year = "",
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- TableName:

  character. Specific table value to request (e.g., "CAGDP9").

- LineCode:

  numeric or character. Specific line from the specified table to
  request.

- GeoFips:

  character. Geographic area(s) for the requested data. Use FIPS codes.

- Year:

  numeric or character. Year(s) for which data is requested.

- ResultFormat:

  character. Format of the returned data. Currently only "json" is
  supported.

- beaKey:

  character. BEA API key. If NULL, searches for key in system
  environment.

## Value

A data frame containing the requested BEA data with the following
columns:

- GeoFips: Geographic FIPS code

- GeoName: Name of the geographic area

- Code: Line code

- TimePeriod: Year of the data

- CL_UNIT: Classification unit

- UNIT_MULT: Unit multiplier

- DataValue: The actual data value (numeric)

- \[Statistic\]: The name of the statistic (column name varies)

## Note

\- The function will display a message with the statistic name and print
any notes returned by the API. - If an error occurs, the function will
return the error information as a data frame.

## See also

[`beaParamValues`](https://aberuiz.github.io/OSO/reference/beaParamValues.md)
for discovering table names and line codes.
[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key.

## Examples

``` r
if (FALSE) { # \dontrun{
# Fetch GDP data for the entire United States in 2022
gdp_data <- beaRegional(
  TableName = "CAGDP9",
  LineCode = 11,
  GeoFips = "00000",
  Year = 2022
)

# Fetch data for multiple years
multi_year_data <- beaRegional(
  TableName = "CAGDP9",
  LineCode = 11,
  GeoFips = "00000",
  Year = "2020,2021,2022"
)
} # }
```
