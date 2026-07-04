# Retrieve IIP (International Investment Position) Data from BEA API

This function fetches International Investment Position data from the
Bureau of Economic Analysis (BEA) API. These accounts include the end of
period value of accumulated stocks of U.S. financial assets and
liabilities.

## Usage

``` r
beaIIP(
  TypeOfInvestment = NULL,
  Component = NULL,
  Frequency = NULL,
  Year = NULL,
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- TypeOfInvestment:

  A character string specifying the type of investment (e.g.,
  "FinAssetsExclFinDeriv"). Multiple values can be supplied comma
  separated. Defaults to all types.

- Component:

  A character string specifying either the position ("Pos") or a
  component in the change of position from the previous period (e.g.,
  "ChgPosPrice"). Defaults to all components.

- Frequency:

  A character string indicating the frequency of the data: "A" for
  annual, "QNSA" for quarterly not seasonally adjusted. Defaults to all
  frequencies.

- Year:

  A character string specifying the year(s) for which to retrieve data.
  Defaults to all years.

- ResultFormat:

  A character string specifying the format of the result (default is
  "json").

- beaKey:

  An optional character string for the BEA API key. If NULL, the
  function will attempt to retrieve it using \`getbeaKey()\`.

## Value

A dataframe containing the requested IIP data.

## Details

More than one TypeOfInvestment can only be specified if a single Year is
specified, and more than one Year can only be specified if a single
TypeOfInvestment is specified. Valid parameter values can be discovered
with \`beaParamValues("IIP", "TypeOfInvestment")\`.

## Note

Users need to register for a BEA API key at
https://apps.bea.gov/API/signup/ and store it using \`setbeaKey()\` for
seamless usage.

## See also

[`beaParamValues`](https://aberuiz.github.io/OSO/reference/beaParamValues.md)
for discovering types of investment and components.
[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key.

## Examples

``` r
if (FALSE) { # \dontrun{
# U.S. assets excluding financial derivatives; change in position
# attributable to price changes for all available years
data <- beaIIP(TypeOfInvestment = "FinAssetsExclFinDeriv",
               Component = "ChgPosPrice", Frequency = "A", Year = "ALL")
} # }
```
