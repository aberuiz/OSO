# Retrieve IntlServTrade (International Services Trade) Data from BEA API

This function fetches annual data on U.S. international trade in
services from the Bureau of Economic Analysis (BEA) API. Statistics on
services supplied through affiliates by multinational enterprises are
not included in this dataset (see \`beaIntlServSTA()\`).

## Usage

``` r
beaIntlServTrade(
  TypeOfService = NULL,
  TradeDirection = NULL,
  Affiliation = NULL,
  AreaOrCountry = NULL,
  Year = NULL,
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- TypeOfService:

  A character string specifying the type of service being traded (e.g.,
  "Telecom", "AllTypesOfService"). Multiple values can be supplied comma
  separated. Defaults to all types.

- TradeDirection:

  A character string specifying the trade direction: "Exports",
  "Imports", "Balance" (exports less imports), or "SupplementalIns"
  (supplemental detail on insurance transactions). Defaults to all
  directions.

- Affiliation:

  A character string specifying the affiliation: "AllAffiliations",
  "Unaffiliated", "Affiliated", "UsParents", or "UsAffiliates". Defaults
  to all affiliations.

- AreaOrCountry:

  A character string specifying the counterparty area or country.
  "AllCountries" returns the total for all countries, while "All"
  returns all data available by area and country. Defaults to
  "AllCountries".

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

A dataframe containing the requested International Services Trade data.

## Details

Multiple TypeOfService values can only be specified if a single
AreaOrCountry is specified, and a list of countries can only be
specified if a single TypeOfService is specified. Valid parameter values
can be discovered with \`beaParamValues("IntlServTrade",
"TypeOfService")\`.

## Note

Users need to register for a BEA API key at
https://apps.bea.gov/API/signup/ and store it using \`setbeaKey()\` for
seamless usage.

## See also

[`beaIntlServSTA`](https://aberuiz.github.io/OSO/reference/beaIntlServSTA.md)
for services supplied through affiliates.
[`beaParamValues`](https://aberuiz.github.io/OSO/reference/beaParamValues.md)
for discovering valid parameter values.
[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key.

## Examples

``` r
if (FALSE) { # \dontrun{
# Imports of services from Germany for 2014 and 2015
data <- beaIntlServTrade(TypeOfService = "AllTypesOfService",
                         TradeDirection = "Imports",
                         Affiliation = "AllAffiliations",
                         AreaOrCountry = "Germany", Year = "2014,2015")
} # }
```
