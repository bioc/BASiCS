% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BASiCS_MCMC.R
\name{BASiCS_MCMC}
\alias{BASiCS_MCMC}
\title{BASiCS MCMC sampler}
\usage{
BASiCS_MCMC(
  Data,
  N,
  Thin,
  Burn,
  Regression,
  WithSpikes = TRUE,
  PriorParam = BASiCS_PriorParam(Data, PriorMu = "EmpiricalBayes"),
  FixNu = FALSE,
  SubsetBy = c("none", "gene", "cell"),
  NSubsets = 1,
  CombineMethod = c("pie", "consensus"),
  Weighting = c("naive", "n_weight", "inverse_variance"),
  Threads = getOption("Ncpus", default = 1L),
  BPPARAM = BiocParallel::bpparam(),
  ...
)
}
\arguments{
\item{Data}{A \code{\linkS4class{SingleCellExperiment}} object.
If \code{WithSpikes = TRUE}, this MUST be formatted to include
the spike-ins and/or batch information (see vignette).}

\item{N}{Total number of iterations for the MCMC sampler.
Use \code{N>=max(4,Thin)}, \code{N} being a multiple of \code{Thin}.}

\item{Thin}{Thining period for the MCMC sampler. Use \code{Thin>=2}.}

\item{Burn}{Burn-in period for the MCMC sampler. Use \code{Burn>=1},
\code{Burn<N}, \code{Burn} being a multiple of \code{Thin}.}

\item{Regression}{If \code{Regression = TRUE}, BASiCS exploits a joint prior
formulation for mean and over-dispersion parameters to estimate a measure of
residual over-dispersion is not confounded by mean expression. Recommended
setting is \code{Regression = TRUE}.}

\item{WithSpikes}{If \code{WithSpikes = TRUE}, BASiCS will use reads from
added spike-ins to estimate technical variability. 
If \code{WithSpikess = FALSE},
BASiCS depends on replicated experiments (batches) to estimate
technical variability. In this case, please supply the BatchInfo vector
in \code{colData(Data)}. Default: \code{WithSpikes = TRUE}.}

\item{PriorParam}{List of prior parameters for BASiCS_MCMC.
Should be created using \code{\link{BASiCS_PriorParam}}.}

\item{FixNu}{Should the scaling normalisation factor \code{nu} be fixed
to the starting value when \code{WithSpikes=FALSE}?
These are set to scran scaling normalisation factors.}

\item{SubsetBy}{Character value specifying whether a divide and
conquer inference strategy should be used. When this is set to \code{"gene"},
inference is performed on batches of genes separately, and when it is set to
\code{"cell"}, inference is performed on batches of cells separately.
Posterior distributions are combined using posterior interval estimation
(see Li et al., 2016).}

\item{NSubsets}{If \code{SubsetBy="gene"} or 
\code{SubsetBy="cell"}, \code{NSubsets} specifies the number of batches 
to create and perform divide and conquer inference with.}

\item{CombineMethod}{The method used to combine 
subposteriors if \code{SubsetBy} is set to \code{"gene"} or 
\code{"cell"}. Options are \code{"pie"} corresponding to
posterior interval estimation (see Li et al., 2016) or
\code{"consensus"} (see Scott et al., 2016).
Both of these methods use a form of weighted average to
combine subposterior draws into the final posterior.}

\item{Weighting}{The weighting method used in the weighted
average chosen using \code{CombineMethod}. Available
options are \code{"naive"} (unweighted), \code{"n_weight"}
(weights are chosen based on the size of each partition)
and \code{"inverse_variance"} (subposteriors are weighted based
on the inverse of the variance of the subposterior for each 
parameter).}

\item{Threads}{Integer specifying the number of threads to be used to 
parallelise parameter updates. Default value is the globally set
\code{"Ncpus"} option, or 1 if this option is not set.}

\item{BPPARAM}{A \code{\link{BiocParallelParam}} instance,
used for divide and conquer inference.}

\item{...}{Optional parameters.
\describe{
  \item{
    \code{AR}
  }{
    Optimal acceptance rate for adaptive Metropolis Hastings
    updates. It must be a positive number between 0 and 1. Default
    (and recommended): \code{AR = 0.44}.
  }
  \item{
    \code{StopAdapt}
  }{
    Iteration at which adaptive proposals are not longer
    adapted. Use \code{StopAdapt>=1}. Default: \code{StopAdapt = Burn}.
  }
  \item{
    \code{StoreChains}
  }{
    If \code{StoreChains = TRUE}, the generated
    \code{BASiCS_Chain} object is stored as a `.Rds` file (\code{RunName}
    argument used to index the file name).
    Default: \code{StoreChains = FALSE}.}
  \item{
    \code{StoreAdapt}
  }{
    If \code{StoreAdapt = TRUE}, trajectory of
    adaptive proposal variances (in log-scale) for all parameters is
    stored as a list in a `.Rds` file (\code{RunName} argument used to
    index file name). Default: \code{StoreAdapt = FALSE}.
  }
  \item{
    \code{StoreDir}
  }{
    Directory where output files are stored.
    Only required if \code{StoreChains = TRUE} and/or
    \code{StoreAdapt = TRUE}. Default: \code{StoreDir = getwd()}.
  }
  \item{
    \code{RunName}
  }{
    String used to index `.Rds` files storing chains
    and/or adaptive proposal variances.
  }
  \item{
    \code{PrintProgress}
  }{
    If \code{PrintProgress = FALSE}, console-based
    progress report is suppressed.}
  \item{
    \code{Start}
  }{
    Starting values for the MCMC sampler. We do not advise
    to use this argument. Default options have been tuned to facilitate
    convergence. If changed, it must be a list containing the following
    elements: 
    \code{mu0}, \code{delta0}, \code{phi0}, \code{s0}, \code{nu0}, 
    \code{theta0}, \code{ls.mu0}, \code{ls.delta0}, \code{ls.phi0},
    \code{ls.nu0} and \code{ls.theta0}
  }
  \item{
    \code{GeneExponent/CellExponent}
  }{
    Exponents applied to the prior for MCMC updates. Intended for use only 
    when performing divide & conquer MCMC strategies.
  }
}}
}
\value{
An object of class \code{\link[BASiCS]{BASiCS_Chain}}.
}
\description{
MCMC sampler to perform Bayesian inference for single-cell
mRNA sequencing datasets using the model described in Vallejos et al (2015).
}
\examples{

# Built-in simulated dataset
set.seed(1) 
Data <- makeExampleBASiCS_Data()
# To analyse real data, please refer to the instructions in:
# https://github.com/catavallejos/BASiCS/wiki/2.-Input-preparation

# Only a short run of the MCMC algorithm for illustration purposes
# Longer runs migth be required to reach convergence
Chain <- BASiCS_MCMC(Data, N = 50, Thin = 2, Burn = 10, Regression = FALSE,
                     PrintProgress = FALSE, WithSpikes = TRUE)

# To run the regression version of BASiCS, use:
Chain <- BASiCS_MCMC(Data, N = 50, Thin = 2, Burn = 10, Regression = TRUE,
                     PrintProgress = FALSE, WithSpikes = TRUE)

# To run the non-spike version BASiCS requires the data to contain at least
# 2 batches:
set.seed(2)
Data <- makeExampleBASiCS_Data(WithBatch = TRUE)
Chain <- BASiCS_MCMC(Data, N = 50, Thin = 2, Burn = 10, Regression = TRUE,
                     PrintProgress = FALSE, WithSpikes = FALSE)

# For illustration purposes we load a built-in 'BASiCS_Chain' object
# (obtained using the 'BASiCS_MCMC' function)
data(ChainSC)

# `displayChainBASiCS` can be used to extract information from this output.
# For example:
head(displayChainBASiCS(ChainSC, Param = 'mu'))

# Traceplot (examples only)
plot(ChainSC, Param = 'mu', Gene = 1)
plot(ChainSC, Param = 'phi', Cell = 1)
plot(ChainSC, Param = 'theta', Batch = 1)

# Calculating posterior medians and 95\% HPD intervals
ChainSummary <- Summary(ChainSC)

# `displaySummaryBASiCS` can be used to extract information from this output
# For example:
head(displaySummaryBASiCS(ChainSummary, Param = 'mu'))

# Graphical display of posterior medians and 95\% HPD intervals
# For example:
plot(ChainSummary, Param = 'mu', main = 'All genes')
plot(ChainSummary, Param = 'mu', Genes = 1:10, main = 'First 10 genes')
plot(ChainSummary, Param = 'phi', main = 'All cells')
plot(ChainSummary, Param = 'phi', Cells = 1:5, main = 'First 5 cells')
plot(ChainSummary, Param = 'theta')

# To constrast posterior medians of cell-specific parameters
# For example:
par(mfrow = c(1,2))
plot(ChainSummary, Param = 'phi', Param2 = 's', SmoothPlot = FALSE)
# Recommended for large numbers of cells
plot(ChainSummary, Param = 'phi', Param2 = 's', SmoothPlot = TRUE)

# To constrast posterior medians of gene-specific parameters
par(mfrow = c(1,2))
plot(ChainSummary, Param = 'mu', Param2 = 'delta', log = 'x',
     SmoothPlot = FALSE)
# Recommended
plot(ChainSummary, Param = 'mu', Param2 = 'delta', log = 'x',
     SmoothPlot = TRUE)

# To obtain denoised rates / counts, see:
# help(BASiCS_DenoisedRates)
# and
# help(BASiCS_DenoisedCounts)

# For examples of differential analyses between 2 populations of cells see:
# help(BASiCS_TestDE)

}
\references{
Vallejos, Marioni and Richardson (2015). PLoS Computational Biology.

Vallejos, Richardson and Marioni (2016). Genome Biology.

Eling et al (2018). Cell Systems

Simple, Scalable and Accurate Posterior Interval Estimation
Cheng Li and Sanvesh Srivastava and David B. Dunson
arXiv (2016)

Bayes and Big Data:  The Consensus Monte Carlo Algorithm
Steven L. Scott, Alexander W. Blocker, Fernando V. Bonassi,
Hugh A. Chipman, Edward I. George and Robert E. McCulloch
International Journal of Management Science and Engineering 
Management (2016)
}
\author{
Catalina A. Vallejos \email{cnvallej@uc.cl}

Nils Eling \email{eling@ebi.ac.uk}
}
