% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proc_funs.R
\name{normalize.nQuantiles}
\alias{normalize.nQuantiles}
\title{Normalization using n quantiles}
\usage{
normalize.nQuantiles(x, probs = 0.5, shareFeature = FALSE, ref = 1)
}
\arguments{
\item{x}{an expression matrix, usually log transformed}

\item{probs}{the quantiles to be aligned across samples. If \code{probs} is a length 1 numerical 
vector, the quantiles will aligned. As a special case, \code{probs = 0.5}
equals the median centering. If \code{probs}' length is > 1, a shift and scaling factor
of samples will be calculating by fitting linear models using quantiles of samples, 
the median and variance of samples will be corrected using the intersect and
slope of the fitted model.}

\item{shareFeature}{logocal; if TRUE, the normalization will be based on the 
shared features between samples}

\item{ref}{the columns name or index to specify the reference sample, only used 
when \code{shareFeature = TRUE}}
}
\value{
a normalized matrix
}
\description{
Normalization using n quantiles
}
\examples{
e1 <- matrix(rnorm(5000), 500, 10)
e1[, 6:10] <- 0.3 *e1[, 6:10] + 3
boxplot(e1)
# median centering, no variance correction
e2 <- normalize.nQuantiles(x = e1, probs = 0.5)
boxplot(e2)
# median centering + variance stablization
e3 <- normalize.nQuantiles(x = e1, probs = seq(0.25, 0.75, by = 0.1))
boxplot(e3)
}
