# Retrieve dataset parameters BEA

This function returns a data frame containing all required and optional
parameters for a specified dataset from the Bureau of Economic Analysis
(BEA) API.

## Usage

``` r
beaParamList(DatasetName = "", ..., ResultFormat = "json", beaKey = NULL)
```

## Arguments

- DatasetName:

  A character string specifying the name of the dataset.

- ...:

  Additional arguments passed to the function (currently unused).

- ResultFormat:

  A character string specifying the format of the result. Currently,
  only "json" is supported. Defaults to "json".

- beaKey:

  A character string containing the BEA API key. If NULL (default), the
  function will attempt to retrieve the key using \`getbeaKey()\`.

## Value

A dataframe containing all required and optional parameters for the
specified dataset. If an error occurs, it returns an error message.

## Details

This function interacts with the BEA API to retrieve parameter
information for a specified dataset. It requires a valid BEA API key,
which can be obtained from https://apps.bea.gov/API/signup/

If no API key is provided, the function attempts to retrieve one using
\`getbeaKey()\`. Ensure you have set your API key using \`setbeaKey()\`
before running this function without explicitly providing a key.

## See also

[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting your BEA API key
[`getbeaKey`](https://aberuiz.github.io/OSO/reference/getbeaKey.md) for
retrieving your stored BEA API key

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve parameters for the Regional dataset
regional_params <- beaParamList(DatasetName = "Regional")

# Using a specific API key
params <- beaParamList(DatasetName = "NIPA", beaKey = "YOUR-API-KEY-HERE")
} # }
```
