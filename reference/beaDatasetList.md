# Retrieve List of Available Datasets from Bureau of Economic Analysis (BEA) API

This function retrieves a list of available datasets from the Bureau of
Economic Analysis (BEA) API. It requires a valid API key and can return
results in different formats.

## Usage

``` r
beaDatasetList(ResultFormat = "json", beaKey = NULL)
```

## Arguments

- ResultFormat:

  A character string specifying the desired format of the results.
  Default is "json". Other possible values may include "xml" (check BEA
  API documentation for all options).

- beaKey:

  A character string containing the BEA API key. If NULL (default), the
  function will attempt to retrieve the key using \`getbeaKey()\`.

## Value

If ResultFormat is "json", returns a tibble (data frame) containing
information about available datasets. For other formats, returns the raw
API response.

## References

Bureau of Economic Analysis (BEA) API:
<https://apps.bea.gov/API/docs/index.htm>

## See also

<https://apps.bea.gov/API/signup/> for BEA API registration

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve dataset list using default JSON format
datasets <- beaDatasetList()

# Retrieve dataset list using a specific API key
datasets <- beaDatasetList(beaKey = "YOUR-API-KEY-HERE")

# Retrieve dataset list in XML format
datasets_xml <- beaDatasetList(ResultFormat = "xml")
} # }
```
