% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compute_troendle.R
\name{compute_troendle}
\alias{compute_troendle}
\title{The Troendle's correction}
\usage{
compute_troendle(distribution, alternative)
}
\arguments{
\item{distribution}{A matrix of permuted statistical signal. The first row indicating the observed statistics.}

\item{alternative}{A character string indicating the alternative hypothesis. Default is \code{"greater"}. Choose between \code{"greater"}, \code{"less"} or \code{"two.sided"}.}
}
\description{
Compute the Troendle's correction given a matrix a permuted statistics.
}
\seealso{
Other multcomp: 
\code{\link{compute_clusterdepth_head}()},
\code{\link{compute_clusterdepth}()},
\code{\link{compute_clustermass}()},
\code{\link{compute_maxT}()},
\code{\link{compute_minP}()},
\code{\link{compute_stepdownmaxT}()},
\code{\link{compute_tfce}()}
}
\concept{multcomp}
