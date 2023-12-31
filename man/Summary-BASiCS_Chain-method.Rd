% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Methods.R
\docType{methods}
\name{Summary}
\alias{Summary}
\alias{Summary,BASiCS_Chain-method}
\title{'Summary' method for BASiCS_Chain objects}
\usage{
\S4method{Summary}{BASiCS_Chain}(x, ..., prob = 0.95, na.rm = FALSE)
}
\arguments{
\item{x}{A \code{\linkS4class{BASiCS_Chain}} object.}

\item{...}{Unused, only included for consistency with the generic.}

\item{prob}{\code{prob} argument for \code{\link[coda]{HPDinterval}}
function.}

\item{na.rm}{Unused, only included for consistency with the generic.}
}
\value{
An object of class \code{\linkS4class{BASiCS_Summary}}.
}
\description{
For each of the BASiCS parameters (see Vallejos et al 2015),
\code{Summary} returns the corresponding postior medians and limits of
the high posterior density interval (probabilty equal to \code{prob})
}
\examples{

data(ChainSC)
SummarySC <- Summary(ChainSC)

}
\author{
Catalina A. Vallejos \email{cnvallej@uc.cl}

Nils Eling \email{eling@ebi.ac.uk}
}
