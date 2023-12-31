% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BASiCS_CalculateERCC.R
\name{BASiCS_CalculateERCC}
\alias{BASiCS_CalculateERCC}
\title{Convert concentration in moles per microlitre to molecule counts}
\usage{
BASiCS_CalculateERCC(Mix, DilutionFactor, VolumePerCell)
}
\arguments{
\item{Mix}{The name of the spike-in mix to use.}

\item{DilutionFactor}{The dilution factor applied to the spike-in mixture.
e.g., 1 microlitre per 50ml would be a 1/50000 \code{DilutionFactor}.}

\item{VolumePerCell}{The volume of spike-in mixture added to each well, or to
each cell.}
}
\value{
The molecule counts per well, or per cell, based on the input
parameters.
}
\description{
Convert concentration in moles per microlitre to molecule counts
}
