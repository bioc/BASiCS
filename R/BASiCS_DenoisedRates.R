#' @name BASiCS_DenoisedRates
#'
#' @title Calculates denoised expression rates
#'
#' @description Calculates normalised and denoised expression rates, by 
#' removing the effect of technical variation.
#'
#' @param Data an object of class \code{\linkS4class{SingleCellExperiment}} 
#' @param Chain an object of class \code{\linkS4class{BASiCS_Chain}}
#' @param Propensities If \code{TRUE}, returns underlying 
#' expression propensitites \eqn{\rho_{ij}}. 
#' Otherwise, denoised rates \eqn{\mu_i \rho_{ij}} are returned.
#' Default: \code{Propensities = FALSE}. 
#'
#' @examples
#'
#' Data <- makeExampleBASiCS_Data(WithSpikes = TRUE)
#' Chain <- BASiCS_MCMC(Data, N = 10000, Thin = 10, Burn = 5000, 
#'                      PrintProgress = FALSE)
#'
#' DR <- BASiCS_DenoisedRates(Data, Chain)
#'
#' @details See vignette
#'
#' @return A matrix of denoised expression rates (biological genes only)
#'
#' @seealso \code{\linkS4class{BASiCS_Chain}}
#'
#' @author Catalina A. Vallejos \email{cnvallej@@uc.cl}
#'
#' @references 
#' 
#' Vallejos, Marioni and Richardson (2015). PLoS Computational Biology. 
#'
#' @rdname BASiCS_DenoisedRates
BASiCS_DenoisedRates = function(Data, 
                                Chain, 
                                Propensities = FALSE) 
{
  if (!is(Data, "SingleCellExperiment")) 
    stop("'Data' is not a SingleCellExperiment class object.")
  if (!is(Chain, "BASiCS_Chain")) 
    stop("'Chain' is not a BASiCS_Chain class object.")
    
  N <- nrow(Chain@delta)
  q.bio <- ncol(Chain@delta)
  n <- ncol(Chain@phi)

  CountsBio <- assay(Data)[!isSpike(Data),]
  Rho <- HiddenBASiCS_DenoisedRates(CountsBio, 
                                    Chain@mu, t(1/Chain@delta),
                                    Chain@phi*Chain@nu,
                                    N, q.bio, n)

  if (Propensities) { out <- Rho } 
  else { out <- Rho * matrixStats::colMedians(Chain@mu) }
    
  return(out)
    
}