% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auxi_stats.R
\name{exprspca}
\alias{exprspca}
\title{Perform PCA and prepare results for \code{omicsViewer}}
\usage{
exprspca(x, n = min(8, ncol(x) - 1), prefix = "PCA|All", fillNA = FALSE, ...)
}
\arguments{
\item{x}{an expression matrix, where rows are features and samples are on columns.}

\item{n}{number of components to keep}

\item{prefix}{prefix of the names. Usually don't need to be changed by the user. 
When changes are needed, the prefix should be in a format like 
[analysis name]|[subset] so the "analysis name" and "subset" can be selected
in the \code{omicsViewer}.}

\item{fillNA}{logical; whether NA should be filled? If FALSE (default), 
\code{na.omit} will be called before PCA. If TRUE, the missing value 
will be replaced using \code{\link{fillNA}}.}

\item{...}{other parameters passed to \code{\link{prcomp}}}
}
\value{
a \code{data.frame} storing the PCA results
}
\description{
This is a convenience function to perform PCA on expression matrix, 
  the output of PCA
  will be in a format ready to be incorporated into object to be visualized by 
  \code{omicsViewer}.
}
\examples{
# reading expression
packdir <- system.file("extdata", package = "omicsViewer")
expr <- read.delim(file.path(packdir, "expressionMatrix.tsv"), stringsAsFactors = FALSE)
# call PCA
pc <- exprspca(expr)
head(pc$samples)
head(pc$features)
}
