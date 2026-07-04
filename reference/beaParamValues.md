# Get Parameter Values for BEA Dataset

Retrieves a data frame of available values for a specified parameter
within a given Bureau of Economic Analysis (BEA) dataset.

## Usage

``` r
beaParamValues(
  DatasetName = "",
  ParameterName = "",
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- DatasetName:

  character. The name of the BEA dataset to query.

- ParameterName:

  character. The name of the parameter for which to retrieve values.

- ResultFormat:

  character. The format of the API response. Currently only "json" is
  supported. Default is "json".

- beaKey:

  character. Optional. The BEA API key. If NULL (default), it will be
  retrieved using \`getbeaKey()\`.

## Value

A data frame containing available values for the specified parameter in
the given dataset. If an error occurs, it returns a data frame with
error information.

## Details

This function interacts with the BEA API to fetch parameter values for a
specified dataset. It requires a valid BEA API key, which can be set
using the \`setbeaKey()\` function or provided directly as an argument.

## See also

[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key
[`getbeaKey`](https://aberuiz.github.io/OSO/reference/getbeaKey.md) for
retrieving the stored BEA API key
[`beaParamList`](https://aberuiz.github.io/OSO/reference/beaParamList.md)
for getting a list of available parameters for a dataset

## Examples

``` r
# Get table names for the Regional dataset
beaParamValues(DatasetName = "Regional", ParameterName = "TableName")
#> Warning: Invalid API Key:  Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`
#> [1] "Invalid API Key:  Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"

# Get available FIPS codes for the Regional dataset
beaParamValues(DatasetName = "Regional", ParameterName = "GeoFips")
#> Warning: Invalid API Key:  Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`
#> [1] "Invalid API Key:  Register <https://apps.bea.gov/API/signup/> Store with `setbeaKey`"
```
