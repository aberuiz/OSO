# Retrieve MNE (Direct Investment and Multinational Enterprises) Data from BEA API

This function fetches data on Direct Investment (DI) and Activities of
Multinational Enterprises (AMNE) from the Bureau of Economic Analysis
(BEA) API. Direct Investment covers income and financial transactions in
direct investment and direct investment positions. AMNE covers
operations and finances of U.S. parent enterprises and their foreign
affiliates and U.S. affiliates of foreign MNEs.

## Usage

``` r
beaMNE(
  SeriesID = "",
  DirectionOfInvestment = "",
  Year = "",
  Classification = "",
  Industry = "",
  NonBankAffiliates = NULL,
  OwnershipLevel = NULL,
  Country = "",
  State = "",
  GetFootnotes = "yes",
  ResultFormat = "json",
  beaKey = NULL
)
```

## Arguments

- SeriesID:

  An integer or character string specifying the data series
  identifier(s). Multiple values can be supplied comma separated.
  Defaults to all series.

- DirectionOfInvestment:

  A character string. For DI requests: "Outward" (U.S. direct investment
  abroad) or "Inward" (foreign investment in the U.S.). AMNE requests
  also accept "State" and "Parent". Required.

- Year:

  A character string specifying the year(s) for which to retrieve data.

- Classification:

  A character string specifying results by country and/or industry
  (e.g., "Country", "CountryByIndustry"). Required.

- Industry:

  A character string specifying the industry code(s). Defaults to all
  industries.

- NonBankAffiliates:

  0 for both bank and nonbank affiliates, 1 for nonbank affiliates only.
  Required for AMNE requests; leave NULL for DI requests.

- OwnershipLevel:

  0 for majority-owned affiliates, 1 for all affiliates. Required for
  AMNE requests; leave NULL for DI requests.

- Country:

  A character string specifying the geographic area code(s). Defaults to
  all countries.

- State:

  A character string specifying the two-digit state FIPS code (AMNE
  requests only). Defaults to all states.

- GetFootnotes:

  A character string, "yes" or "no", indicating whether to print
  footnotes (default is "yes").

- ResultFormat:

  A character string specifying the format of the result (default is
  "json").

- beaKey:

  An optional character string for the BEA API key. If NULL, the
  function will attempt to retrieve it using \`getbeaKey()\`.

## Value

A dataframe containing the requested MNE data.

## Details

Direct Investment (DI) and AMNE requests share most parameters, but
\`OwnershipLevel\` and \`NonBankAffiliates\` apply only to AMNE
requests. Valid parameter values can be discovered with
\`beaParamValues("MNE", "SeriesID")\` and similar calls for the other
parameters.

## Note

Users need to register for a BEA API key at
https://apps.bea.gov/API/signup/ and store it using \`setbeaKey()\` for
seamless usage.

## See also

[`beaParamValues`](https://aberuiz.github.io/OSO/reference/beaParamValues.md)
for discovering valid parameter values.
[`setbeaKey`](https://aberuiz.github.io/OSO/reference/setbeaKey.md) for
setting the BEA API key.

## Examples

``` r
if (FALSE) { # \dontrun{
# U.S. direct investment position in China and Asia for 2011 and 2012
data <- beaMNE(SeriesID = "30", DirectionOfInvestment = "Outward",
               Classification = "Country", Country = "650,699",
               Year = "2011,2012")

# Net income and sales for Brazilian affiliates of U.S. parent
# enterprises, all industries, 2011 and 2012
data <- beaMNE(SeriesID = "4,5", DirectionOfInvestment = "Outward",
               Classification = "CountryByIndustry", Country = "202",
               Industry = "all", Year = "2011,2012",
               NonBankAffiliates = 0, OwnershipLevel = 0)
} # }
```
