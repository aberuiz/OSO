% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/beaParamList.R
\name{beaParamList}
\alias{beaParamList}
\title{Return dataset parameters}
\usage{
beaParamList(DatasetName = "", ..., ResultFormat = "json", beaKey = NULL)
}
\arguments{
\item{DatasetName}{The name of the dataset}

\item{ResultFormat}{Currently OSO can only return data properly in json}

\item{beaKey}{Searches Sys.getenv by default. You may provide your API key here or save one with `setbeaKey`}
}
\value{
returns a list of all required and optional parameters for the dataset
}
\description{
Returns a data frame of all required and optional parameters for provided dataset
}
\examples{
beaParamList(DataSetName = "Regional")

}
