% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auxi_sparse_converter.R
\name{list2csc}
\alias{list2csc}
\title{convert a list to column compressed sparse matrix}
\usage{
list2csc(l, dimnames)
}
\arguments{
\item{l}{a data.frame with at least two columns - featureId, gsId; optionally
a "weight" column.}

\item{dimnames}{a list of dimnames, should contain at least one element for the
row names.}
}
\value{
a sparse matrix, CsparseMatrix, column compressed
}
\description{
convert a list to column compressed sparse matrix
}
