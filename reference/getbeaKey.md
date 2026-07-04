# Retrieve BEA API Key

This function attempts to retrieve a the Bureau of Economic Analysis
(BEA) API key that has been set in the system environment. It's used to
authenticate requests to the BEA API for accessing economic data.

## Usage

``` r
getbeaKey()
```

## Value

Returns a character string containing the BEA API key if it's set in the
environment. If the key is not set, returns an empty string ("").
