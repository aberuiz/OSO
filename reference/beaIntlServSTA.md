# Retrieve IntlServSTA (International Services Supplied Through Affiliates) Data from BEA API

This function fetches annual data on services supplied through
U.S.-owned foreign affiliates to foreign markets and through
foreign-owned U.S. affiliates to the United States from the Bureau of
Economic Analysis (BEA) API.

## Usage

``` r
beaIntlServSTA(
  Channel = NULL,
  Destination = NULL,
  Industry = NULL,
  AreaOrCountry = NULL,
  Year = NULL,
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- Channel:

  A character string specifying the channel through which the service is
  supplied: "Mofas", "Mousas", "AllChannels", "Trade",
  "UsExportsByMousas", or "UsImportsFromMofas". Defaults to all
  channels.

- Destination:

  A character string specifying the location and affiliation of the
  recipient of the service (e.g., "AllForeign", "HostCtry", "AllUs").
  Defaults to all destinations.

- Industry:

  A character string specifying the industry of the affiliate supplying
  the service. "AllInd" returns the total for all industries, while
  "All" returns all data available by industry. Defaults to all
  industries.

- AreaOrCountry:

  A character string specifying, for MOFAs, the area or country of the
  affiliate; for MOUSAs, the area or country of the Ultimate Beneficial
  Owner (UBO) of the affiliate. "AllCountries" returns the total for all
  countries, while "All" returns all data available by area and country.
  Defaults to "AllCountries".

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

A dataframe containing the requested International Services Supplied
Through Affiliates data.

## Details

Valid parameter values can be discovered with
\`beaParamValues("IntlServSTA", "Channel")\` and similar calls for the
other parameters.

## Note

Users need to register for a BEA API key at
https://apps.bea.gov/API/signup/ and store it using \`setbeaKey()\` for
seamless usage.

## See also

[`beaIntlServTrade`](https://aberuiz.github.io/OSO/reference/beaIntlServTrade.md)
for U.S. international trade in services.
[`beaParamValues`](https://aberuiz.github.io/OSO/reference/beaParamValues.md)
for discovering valid parameter values.
[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key.

## Examples

``` r
if (FALSE) { # \dontrun{
# Services supplied through MOFAs in retail trade to all foreign persons
# in India in 2015 and 2016
data <- beaIntlServSTA(Channel = "Mofas", Destination = "AllForeign",
                       Industry = "RetailTrade", AreaOrCountry = "India",
                       Year = "2015,2016")
} # }
```
