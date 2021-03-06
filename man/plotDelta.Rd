% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotDelta.R
\name{plotDelta}
\alias{plotDelta}
\title{Plot deltas by cluster of most altered genes under batch correction.
Plot deltas by cluster of most altered genes under batch correction.}
\usage{
plotDelta(deg_df, nTop)
}
\arguments{
\item{deg_df}{data frame with DEG information for each batch pre and
post correction, output from findDEG}

\item{nTop}{integer specifying number of top genes to consider}
}
\value{
ggplot object
}
\description{
Plot deltas by cluster of most altered genes under batch correction.
Plot deltas by cluster of most altered genes under batch correction.
}
\examples{
data("deg_df")
plotDelta(deg_df, 16)

}
