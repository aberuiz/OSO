# Set a BEA API key

Set a Bureau of Economic Analysis (BEA) API key for data requests. The
key can be set for the current session or installed permanently in the
user's .Renviron file.

## Usage

``` r
setbeaKey(APIkey, install = FALSE, overwrite = FALSE)
```

## Arguments

- APIkey:

  A 36-character string provided by bea.gov

- install:

  Logical; if TRUE, the API key will be saved in .Renviron for future
  sessions

- overwrite:

  Logical; if TRUE, overwrites an existing BEA API key in .Renviron

## Value

Invisibly returns the BEA API key

## Examples

``` r
if (FALSE) { # \dontrun{
setbeaKey("your-36-character-api-key-here")
setbeaKey("your-36-character-api-key-here", install = TRUE)
} # }
```
