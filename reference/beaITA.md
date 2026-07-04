# Retrieve ITA (International Transactions Accounts) Data from BEA API

This function fetches International Transactions (balance of payments)
data from the Bureau of Economic Analysis (BEA) API. These accounts
include all transactions between U.S. and foreign residents.

## Usage

``` r
beaITA(
  Indicator = NULL,
  AreaOrCountry = NULL,
  Frequency = NULL,
  Year = NULL,
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- Indicator:

  A character string specifying the indicator code for the type of
  transaction requested (e.g., "BalGds"). Multiple values can be
  supplied comma separated. Defaults to all indicators.

- AreaOrCountry:

  A character string specifying the counterparty area or country.
  "AllCountries" returns the total for all countries, while "All"
  returns all data available by area and country. Defaults to
  "AllCountries".

- Frequency:

  A character string indicating the frequency of the data: "A" for
  annual, "QSA" for quarterly seasonally adjusted, "QNSA" for quarterly
  not seasonally adjusted. Defaults to all frequencies.

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

A dataframe containing the requested ITA data.

## Details

Multiple Indicators can only be specified if a single AreaOrCountry is
specified, and a list of countries can only be specified if a single
Indicator is specified. Valid parameter values can be discovered with
\`beaParamValues("ITA", "Indicator")\`.

## Note

Users need to register for a BEA API key at
https://apps.bea.gov/API/signup/ and store it using \`setbeaKey()\` for
seamless usage.

## See also

[`beaParamValues`](https://aberuiz.github.io/OSO/reference/beaParamValues.md)
for discovering indicator codes.
[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key.

## Examples

``` r
if (FALSE) { # \dontrun{
# Balance on goods with China for 2011 and 2012
data <- beaITA(Indicator = "BalGds", AreaOrCountry = "China",
               Frequency = "A", Year = "2011,2012")
} # }
```
