# Filter and retrieve parameter values from BEA datasets

This function queries the Bureau of Economic Analysis (BEA) API to
retrieve a filtered set of parameter values for a specified dataset. It
allows for filtering based on table name and line code.

## Usage

``` r
beaParamValuesFiltered(
  DatasetName = "",
  TargetParameter = "",
  TableName = "",
  LineCode = "",
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- DatasetName:

  Character string. The name of the BEA dataset to query (e.g.,
  "Regional").

- TargetParameter:

  Character string. The name of the parameter for which to retrieve
  values.

- TableName:

  Character string. Optional. Specific BEA table name to filter the
  results.

- LineCode:

  Character string. Optional. Specific line code to further filter the
  results.

- ResultFormat:

  Character string. The format of the API response. Currently only
  supports "json".

- beaKey:

  Character string. Optional. Your BEA API key. If not provided, it will
  be retrieved from the environment.

## Value

A data frame containing the filtered parameter values for the specified
dataset and criteria.

## Details

This function interacts with the BEA API to retrieve filtered parameter
values. It requires a valid BEA API key, which can be obtained from
<https://apps.bea.gov/API/signup/>. The API key can be provided directly
to the function or set in the environment using the \`setbeaKey\`
function.

If an error occurs during the API request, the function will return a
data frame with error information.

## See also

[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key
[`getbeaKey`](https://aberuiz.github.io/OSO/reference/getbeaKey.md) for
retrieving the stored BEA API key

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve filtered line codes for the Regional dataset, table CAGDP9
result <- beaParamValuesFiltered(
  DatasetName = "Regional",
  TargetParameter = "LineCode",
  TableName = "CAGDP9"
)

# Retrieve parameter values with additional line code filter
result <- beaParamValuesFiltered(
  DatasetName = "Regional",
  TargetParameter = "GeoFips",
  TableName = "CAGDP2",
  LineCode = "1"
)
} # }
```
