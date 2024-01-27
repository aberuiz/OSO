
# OSO

The goal of OSO is to provide a straightforward way of reading data into
R from the Bureau of Economic Analysis (BEA) and improving discovery of
available data sets.

## Installation

You can install the development version of OSO from
[GitHub](https:://github.com/) with:

``` r
#install.packages("devtools")
devtools::install_github("aberuiz/OSO")
library(OSO)
```

## API Registration

Every function in OSO does require an API key from BEA. You can register
for a key on the [BEA Website](https://apps.bea.gov/api/signup/).

For saving your API Key into the environment you can use `setbeaKey`. To
permanently store your BEA API Key in .Renviron use the argument
‘install = TRUE’.

``` r
setbeaKey(APIkey = "<Your 36 character API Key>", install = TRUE)
```

Once you have set up your key OSO will automatically check for your key
in the stored environment using `getbeaKey` when you make a request.

Use `getbeaKey` to check what BEA API Key you have stored. You can
overwrite an existing key using the argument ‘overwrite = TRUE’ in
`setbeaKey`.

## Available Datasets

Use `beaDatasetList` to view all datasets available through the BEA API.

**Disclaimer** as of this writing, not all datasets can be accessed
through OSO. Look below for a list of future development.

``` r
beaDatasetList()
#> # A tibble: 13 × 2
#>    DatasetName             DatasetDescription                                
#>    <chr>                   <chr>                                             
#>  1 NIPA                    Standard NIPA tables                              
#>  2 NIUnderlyingDetail      Standard NI underlying detail tables              
#>  3 MNE                     Multinational Enterprises                         
#>  4 FixedAssets             Standard Fixed Assets tables                      
#>  5 ITA                     International Transactions Accounts               
#>  6 IIP                     International Investment Position                 
#>  7 InputOutput             Input-Output Data                                 
#>  8 IntlServTrade           International Services Trade                      
#>  9 IntlServSTA             International Services Supplied Through Affiliates
#> 10 GDPbyIndustry           GDP by Industry                                   
#> 11 Regional                Regional data sets                                
#> 12 UnderlyingGDPbyIndustry Underlying GDP by Industry                        
#> 13 APIDatasetMetaData      Metadata about other API datasets
```

## Finding Parameters & Values

In this example, we’ll focus on accessing the ‘Regional’ dataset.

Before making a call using `beaRegional` you may want to look at the
parameters necessary to make a request.

Using `beaParamList` we can get the list of parameters we can use for
the ‘Regional’ dataset.

``` r
beaParamList(
  DatasetName = "Regional"
)
#> # A tibble: 4 × 6
#>   ParameterName ParameterDataType ParameterDescription    ParameterIsRequiredF…¹
#>   <chr>         <chr>             <chr>                   <chr>                 
#> 1 GeoFips       string            Comma-delimited list o… 1                     
#> 2 LineCode      integer           Line code for a statis… 1                     
#> 3 TableName     string            Regional income or pro… 1                     
#> 4 Year          string            Comma-delimted list of… 0                     
#> # ℹ abbreviated name: ¹​ParameterIsRequiredFlag
#> # ℹ 2 more variables: MultipleAcceptedFlag <chr>, ParameterDefaultValue <chr>
```

From here, you are returned all parameters you can use for this dataset.

To get all available Values for each of the above parameters you can use
`beaParamValues`.

``` r
beaParamValues(
  DatasetName = "Regional",
  ParameterName = "TableName"
)
#> # A tibble: 94 × 2
#>    Key      Desc                                                                
#>    <chr>    <chr>                                                               
#>  1 CAEMP25N Total full-time and part-time employment by NAICS industry          
#>  2 CAEMP25S Total full-time and part-time employment by SIC industry            
#>  3 CAGDP1   County and MSA gross domestic product (GDP) summary                 
#>  4 CAGDP11  Contributions to percent change in real GDP                         
#>  5 CAGDP2   Gross domestic product (GDP) by county and metropolitan area        
#>  6 CAGDP8   Chain-type quantity indexes for real GDP by county and metropolitan…
#>  7 CAGDP9   Real GDP by county and metropolitan area                            
#>  8 CAINC1   County and MSA personal income summary: personal income, population…
#>  9 CAINC30  Economic profile                                                    
#> 10 CAINC35  Personal current transfer receipts                                  
#> # ℹ 84 more rows
```

For this example we’ll look at Real GDP which is Table Value : “CAGDP9”

You can get all available linecodes for the ‘Regional’ dataset you can
run `beaParamValues` and enter ‘linecode’ for the ParameterName.
However, an easier command is `beaParamValuesFiltered` which allows you
to view linecodes only for your table of interest: “CAGDP9”

``` r
beaParamValuesFiltered(
  DatasetName = "Regional",
  TargetParameter = "linecode",
  TableName = "CAGDP9"
)
#> # A tibble: 34 × 2
#>    Key   Desc                                                               
#>    <chr> <chr>                                                              
#>  1 1     [CAGDP9] Real GDP: All industry total                              
#>  2 10    [CAGDP9] Real GDP: Utilities (22)                                  
#>  3 11    [CAGDP9] Real GDP: Construction (23)                               
#>  4 12    [CAGDP9] Real GDP: Manufacturing (31-33)                           
#>  5 13    [CAGDP9] Real GDP: Durable goods manufacturing (321,327-339)       
#>  6 2     [CAGDP9] Real GDP: Private industries                              
#>  7 25    [CAGDP9] Real GDP: Nondurable goods manufacturing (311-316,322-326)
#>  8 3     [CAGDP9] Real GDP: Agriculture, forestry, fishing and hunting (11) 
#>  9 34    [CAGDP9] Real GDP: Wholesale trade (42)                            
#> 10 35    [CAGDP9] Real GDP: Retail trade (44-45)                            
#> # ℹ 24 more rows
```

## Making the Request

Now we are ready to make a call using `beaRegional` for Real GDP in
Construction for the entire United States using geoFips code ‘00000’.

``` r
beaRegional(
  TableName = "CAGDP9",
  LineCode = 11,
  GeoFips = "00000",
  Year = 2022
)
#> Real GDP: Construction
#> [1] "Metropolitan Areas are defined (geographically delineated) by the Office of Management and Budget (OMB) bulletin no. 20-01 issued March 6, 2020."                                                                                                                                                                               
#> [2] "For the All industry total and Government and government enterprises, the difference between the United States and Metropolitan and Nonmetropolitan portions reflects overseas activity, economic activity taking place outside the borders of the United States by the military and associated federal civilian support staff."
#> [3] "Last updated: December 7, 2023 -- new statistics for 2022, revised statistics for 2017-2021."
#> # A tibble: 1 × 7
#>   Code      GeoFips GeoName   TimePeriod CL_UNIT UNIT_MULT Real_GDP_Construction
#>   <chr>     <chr>   <chr>     <chr>      <chr>   <chr>                     <dbl>
#> 1 CAGDP9-11 00000   United S… 2022       Thousa… 3                     827768000
```

**Data Notes** For datasets that include notes they will be provided in
the console. See the above request for an example.

## Multiple Values

For ‘Regional’ datasets you are able to request multiple returns for
parameters ‘GeoFips’ and ‘Year’. You must insert values in a
comma-delimited string. For requesting all available years you can also
insert ‘ALL’.

``` r
beaRegional(
  TableName = "CAGDP9",
  LineCode = 11,
  GeoFips = "00000, 48000",
  Year = "ALL"
)
#> Real GDP: Construction
#> [1] "Metropolitan Areas are defined (geographically delineated) by the Office of Management and Budget (OMB) bulletin no. 20-01 issued March 6, 2020."                                                                                                                                                                               
#> [2] "For the All industry total and Government and government enterprises, the difference between the United States and Metropolitan and Nonmetropolitan portions reflects overseas activity, economic activity taking place outside the borders of the United States by the military and associated federal civilian support staff."
#> [3] "Last updated: December 7, 2023 -- new statistics for 2022, revised statistics for 2017-2021."
#> # A tibble: 12 × 7
#>    Code      GeoFips GeoName  TimePeriod CL_UNIT UNIT_MULT Real_GDP_Construction
#>    <chr>     <chr>   <chr>    <chr>      <chr>   <chr>                     <dbl>
#>  1 CAGDP9-11 00000   United … 2017       Thousa… 3                     840220000
#>  2 CAGDP9-11 00000   United … 2018       Thousa… 3                     863755000
#>  3 CAGDP9-11 00000   United … 2019       Thousa… 3                     882046000
#>  4 CAGDP9-11 00000   United … 2020       Thousa… 3                     856487000
#>  5 CAGDP9-11 00000   United … 2021       Thousa… 3                     888104000
#>  6 CAGDP9-11 00000   United … 2022       Thousa… 3                     827768000
#>  7 CAGDP9-11 48000   Texas    2017       Thousa… 3                      88478080
#>  8 CAGDP9-11 48000   Texas    2018       Thousa… 3                      87963012
#>  9 CAGDP9-11 48000   Texas    2019       Thousa… 3                      90383450
#> 10 CAGDP9-11 48000   Texas    2020       Thousa… 3                      87536636
#> 11 CAGDP9-11 48000   Texas    2021       Thousa… 3                      88865961
#> 12 CAGDP9-11 48000   Texas    2022       Thousa… 3                      83697711
```

## In Development

- Improvements to MNE
- Addition of IntlServTrade
- Addition of IntlServSTA
- Allow for XML Responses
