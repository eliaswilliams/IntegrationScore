% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotCorrByCutoff.R
\name{plotCorrByCutoff}
\alias{plotCorrByCutoff}
\title{Runs corrDEG with different cutoff levels for log 2 FC then plots the results.}
\usage{
plotCorrByCutoff(DEG_df, granularity, estimate = "pearson", byCluster = T)
}
\arguments{
\item{DEG_df}{data frame with DEG information for each batch pre and
post correction, output from findDEG}

\item{granularity}{integer giving number of cutoffs}

\item{estimate}{test to plot, either pearson or spearman}

\item{byCluster}{whether or not to aggregate scores by averaging over cluster}
}
\value{
ggplot with the spearman and pearson correlation estimates and
        for each cluster at each cutoff.
}
\description{
Runs corrDEG with different cutoff levels for log 2 FC then plots the results.
}
\examples{
data("deg_df")
plotCorrByCutoff(deg_df, 50)

}
