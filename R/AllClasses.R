#' @name BASiCS_Chain
#' @aliases BASiCS_Chain-class
#'
#' @title The BASiCS_Chain class
#'
#' @description Container of an MCMC sample of the BASiCS' model parameters
#' as generated by the function \code{\link[BASiCS]{BASiCS_MCMC}}.
#' @slot parameters List of matrices containing MCMC chains for each model
#' parameter. Depending on the mode in which BASiCS was run, the following
#' parameters can appear in the list:
#' \describe{
#' \item{\code{mu}}{MCMC chain for gene-specific mean expression parameters
#' \eqn{\mu_i}, biological genes only
#' (matrix with \code{q.bio} columns, all elements must be positive numbers)}
#' \item{delta}{MCMC chain for gene-specific biological over-dispersion
#' parameters \eqn{\delta_i}, biological genes only
#' (matrix with \code{q.bio} columns, all elements must be positive numbers)}
#' \item{phi}{MCMC chain for cell-specific mRNA content normalisation parameters
#' \eqn{\phi_j} (matrix with \code{n} columns, all elements must be positive
#' numbers and the sum of its elements must be equal to \code{n})}
#' This parameter is only used when spike-in genes are available.
#' \item{s}{MCMC chain for cell-specific technical normalisation parameters
#' \eqn{s_j} (matrix with \code{n} columns,
#' all elements must be positive numbers)}
#' \item{nu}{MCMC chain for cell-specific random effects \eqn{\nu_j}
#' (matrix with \code{n} columns, all elements must be positive numbers)}
#' \item{theta}{MCMC chain for technical over-dispersion parameter(s)
#' \eqn{\theta} (matrix, all elements must be positive,
#' each colum represents 1 batch)}
#' \item{\code{beta}}{Only relevant for regression BASiCS model (Eling et al,
#' 2017). MCMC chain for regression coefficients (matrix with \code{k} columns,
#' where \code{k} represent the number of chosen basis functions + 2) }
#' \item{\code{sigma2}}{Only relevant for regression BASiCS model (Eling et al,
#' 2017). MCMC chain for the residual variance (matrix with one column, sigma2
#' represents a global parameter)}
#' \item{\code{epsilon}}{Only relevant for regression BASiCS model (Eling et al,
#' 2017). MCMC chain for the gene-specific residual over-dispersion parameter
#' (matrix with \code{q} columns)}
#' \item{\code{RefFreq}}{Only relevant for no-spikes BASiCS model (Eling et al,
#' 2017). For each biological gene, this vector displays the proportion of
#' times for which each gene was used as a reference (within the MCMC
#' algorithm), when using the stochastic reference choice described in
#' (Eling et al, 2017). This information has been kept as it is useful for the
#' developers of this library. However, we do not expect users to need it. }
#' }
#'
#' @examples
#'
#' # A BASiCS_Chain object created by the BASiCS_MCMC function.
#' Data <- makeExampleBASiCS_Data()
#'
#' # To run the model without regression
#' Chain <- BASiCS_MCMC(Data, N = 100, Thin = 2, Burn = 2, Regression = FALSE)
#'
#' # To run the model using the regression model
#' ChainReg <- BASiCS_MCMC(Data, N = 100, Thin = 2, Burn = 2, Regression = TRUE)
#'
#' @author Catalina A. Vallejos \email{cnvallej@@uc.cl}
#' @author Nils Eling \email{eling@@ebi.ac.uk}
#'
#' @export
setClass(
  "BASiCS_Chain",
  representation = representation(parameters = "list"),
  contains = "Versioned",
  validity = function(object) {
    errors <- character()

    if (!("parameters" %in% methods::slotNames(object))) {
      return("'object' was generated by an old version of BASiCS")
    }

    ValidNames <- c(
      .GeneParams(),
      .CellParams(),
      .GlobalParams(),
      .OtherParams()
      # "mu",
      # "delta",
      # "phi",
      # "s",
      # "nu",
      # "theta",
      # "beta",
      # "sigma2",
      # "epsilon",
      # "RefFreq",
      # "designMatrix",
      # "RBFLocations",
      # "ESS",
      # "ls.mu",
      # "ls.delta",
      # "ls.phi",
      # "ls.nu",
      # "ls.theta"
    )
    ReqNames <- c(
      "mu",
      "delta",
      "s",
      "nu",
      "theta"
    )

    # Check whether all elements of `parameters` are valid
    if (sum(!(names(object@parameters) %in% ValidNames) > 0) > 0) {
      errors <- c(
        errors,
        paste(
          "Invalid elements", 
          paste(
            setdiff(names(object@parameters), ValidNames),
            collapse = ", "
          ),
          "in `parameters` slot"
        )
      )
    }

    # Check whether all minimum `parameters` are present
    if (sum(names(object@parameters) %in% ReqNames) != 5) {
      errors <- c(errors, "One or more parameters are missing")
    }

    hasFinite <- lapply(
      object@parameters[setdiff(names(object@parameters), c("delta", "epsilon"))],
      function(x) sum(!is.finite(x))
    )
    # Check for infinite values and NAs
    if (sum(hasFinite > 0) > 0) {
      errors <- c(errors, "Some parameters contain NA/Inf values")
    }

    N <- nrow(object@parameters$mu)
    q <- ncol(object@parameters$mu)
    n <- ncol(object@parameters$s)

    iterParams <- setdiff(
      names(object@parameters), 
      c("RBFLocations", "RefFreq", "designMatrix")
    )
    nRows <- lapply(object@parameters[iterParams], nrow)
    # Check number of iterations per element of `parameters`
    if (sum(nRows != N) > 0) {
      errors <- c(errors, "Different numbers of iterations")
    }
    # Check dimensions for basic gene-specific parameters
    geneParams <- intersect(
      c("mu", "delta", "epsilon"),
      names(object@parameters)
    )
    nGenes <- lapply(object@parameters[geneParams], ncol)
    if (sum(nGenes != q) > 0) {
      errors <- c(errors, "Parameters' dimensions are not compatible (genes)")
    }
    # Check dimensions for basic cell-specific parameters
    cellParams <- intersect(c("nu", "s", "phi"), names(object@parameters))
    nCells <- lapply(object@parameters[cellParams], ncol)
    if (sum(nCells != n) > 0) {
      errors <- c(errors, "Parameters' dimensions are not compatible (cells)")
    }
    # Check labels for gene-specific params
    if (!identical(
          colnames(object@parameters$mu),
          colnames(object@parameters$delta))
        ) {
      errors <- c(errors,"Gene-specific parameter labels don't match")
    }

    if (length(errors) == 0) {
      TRUE
    } else {
      errors
    }

  },
  prototype = prototype(
    new(
      "Versioned",
      versions = c(
        "BASiCS_Chain" = utils::packageVersion("BASiCS")
      )
    )
  )
)


#' @name BASiCS_Summary
#' @aliases BASiCS_Summary-class
#'
#' @title The BASiCS_Summary class
#'
#' @description Container of a summary of a \code{\linkS4class{BASiCS_Chain}}
#' object. In each element of the \code{parameters} slot, first column contains
#' posterior medians; second and third columns respectively contain the lower
#' and upper limits of an high posterior density interval (for a given 
#' probability).
#'
#' @slot parameters List of parameters in which each entry contains a matrix:
#' first column contains posterior medians, second column contains the
#' lower limits of an high posterior density interval and third column
#' contains the upper limits of high posterior density intervals.
#' \describe{
#' \item{mu}{Posterior medians (1st column), lower (2nd column) and upper
#' (3rd column) limits of gene-specific mean expression parameters \eqn{\mu_i}.}
#' \item{delta}{Posterior medians (1st column), lower (2nd column) and upper
#' (3rd column) limits of gene-specific biological over-dispersion parameters
#' \eqn{\delta_i}, biological genes only }
#' \item{phi}{Posterior medians (1st column), lower (2nd column) and upper
#' (3rd column) limits of cell-specific mRNA content normalisation
#' parameters \eqn{\phi_j}}
#' \item{s}{Posterior medians (1st column), lower (2nd column) and upper
#' (3rd column) limits of cell-specific technical normalisation
#' parameters \eqn{s[j]}}
#' \item{nu}{Posterior medians (1st column), lower (2nd column) and upper
#' (3rd column) limits of cell-specific random effects \eqn{\nu_j}}
#' \item{theta}{Posterior median (1st column), lower (2nd column) and upper
#' (3rd column) limits of technical over-dispersion parameter(s) \eqn{\theta}
#' (each row represents one batch)}
#' \item{\code{beta}}{Posterior median (first column), lower (second column)
#' and upper (third column) limits of regression coefficients \eqn{\beta}}
#' \item{\code{sigma2}}{Posterior median (first column), lower (second column)
#' and upper (third column) limits of residual variance \eqn{\sigma^2}}
#' \item{\code{epsilon}}{Posterior median (first column), lower (second column)
#' and upper (third column) limits of gene-specific residual over-dispersion
#' parameter \eqn{\epsilon} }
#' }
#'
#' @examples
#'
#' # A BASiCS_Summary object created by the Summary method.
#' Data <- makeExampleBASiCS_Data()
#' Chain <- BASiCS_MCMC(Data, N = 100, Thin = 2, Burn = 2, Regression = FALSE)
#' ChainSummary <- Summary(Chain)
#'
#'
#' @export
setClass(
  "BASiCS_Summary",
  representation = representation(
    parameters = "list"
  ),
  contains="Versioned",
  validity = function(object) {
    errors <- character()

    ValidNames <- c(
      "mu", "delta", "phi", "s", "nu", "theta",
      "beta", "sigma2", "epsilon")
    ReqNames <- c("mu", "delta", "s", "nu", "theta")

    # Check whether all elements of `parameters` are valid
    if (sum(!(names(object@parameters) %in% ValidNames) > 0) > 0) {
      errors <- c(errors, "Invalid elemens in `parameters` slot")
    }

    # Check whether all minimum `parameters` are present
    if (sum(names(object@parameters) %in% ReqNames) != 5) {
      errors <- c(errors, "One or more parameters are missing")
    }

    if (length(errors) == 0) {
      TRUE
    } else {
      errors
    }
  },
  prototype = prototype(
    new("Versioned", 
      versions = c("BASiCS_Summary" = utils::packageVersion("BASiCS"))
    )
  )
)


#' @name BASiCS_ResultsDE
#' @aliases BASiCS_ResultsDE-class
#'
#' @title The BASiCS_ResultsDE class
#'
#' @description Results of BASiCS_TestDE
#' @slot Results \code{\linkS4class{BASiCS_ResultDE}} objects
#' @slot Chain1,Chain2 \code{\linkS4class{BASiCS_Chain}} objects. 
#' @slot GroupLabel1,GroupLabel2 Labels for Chain1 and Chain2
#' @slot Offset Ratio between median of chains 
#' @slot RowData Annotation for genes
#' @slot Extras Slot for extra information to be added later
setClass("BASiCS_ResultsDE",
  representation = representation(
    Results = "list",
    Chain1 = "BASiCS_Chain",
    Chain2 = "BASiCS_Chain",
    GroupLabel1 = "character",
    GroupLabel2 = "character",
    Offset = "numeric",
    ## gene annotations!
    RowData = "DataFrame",
    Extras = "list"
  ),
  contains = "Versioned",
  validity = function(object) {
    g1 <- object@RowData$GeneName
    matching_genes <- vapply(object@Results,
      function(x) {
        all(x@Table$GeneName == g1)
      },
      logical(1)
    )
    if (!all(matching_genes)) {
      stop("Some GeneName columns do not match!")
    }
    assert_that(
      all(vapply(object@Results, function(x) inherits(x, "BASiCS_ResultDE"), logical(1))),
      length(object@GroupLabel1) == 1,
      length(object@GroupLabel2) == 1,
      .NSamples(object@Chain1) == .NSamples(object@Chain2)
    )
  }
)

#' @name BASiCS_Result
#' @aliases BASiCS_Result-class
#'
#' @title The BASiCS_Result class
#'
#' @description Container of results for a single test (HVG/LVG/DE).
#' This should be an abstract class (but this is R so no)
#' and shouldn't be directly instantiated.
#' Defines a very small amount of common behaviour for
#' \linkS4class{BASiCS_ResultDE} and \linkS4class{BASiCS_ResultVG}.
#' @slot Table Tabular results for each gene.
#' @slot Name The name of the test performed (typically "Mean", "Disp" or 
#'  "ResDisp")
#' @slot ProbThreshold Posterior probability threshold used in differential 
#' test.
#' @slot EFDR,EFNR Expected false discovery and expected false negative rates
#' for differential test.
#' @slot Extra Additional objects for class flexibility.
setClass("BASiCS_Result",
  representation = representation(
    Table = "data.frame",
    Name = "character",
    ProbThreshold = "numeric",
    EFDR = "numeric",
    EFNR = "numeric",
    Extras = "list"
  ),
  validity = function(object) {

    assert_that(
      !is.null(object@Table$GeneName),
      object@Name %in% c("Mean", "Disp", "ResDisp", "HVG", "LVG"),
      length(object@ProbThreshold) == 1,
      length(object@EFDR) == 1,
      length(object@EFNR) == 1,
      object@ProbThreshold >= 0,
      object@ProbThreshold <= 1,
      all(object@EFDR <= 1, na.rm = TRUE),
      all(object@EFDR >= 0, na.rm = TRUE),
      all(object@EFNR <= 1, na.rm = TRUE),
      all(object@EFNR >= 0, na.rm = TRUE)
    )
  }
)



#' @name BASiCS_ResultDE
#' @aliases BASiCS_ResultDE-class
#'
#' @title The BASiCS_ResultDE class
#'
#' @description Container of results for a single differential test.
#' @slot Table Tabular results for each gene.
#' @slot Name The name of the test performed (typically "Mean", "Disp" or 
#'  "ResDisp")
#' @slot GroupLabel1,GroupLabel2 Group labels.
#' @slot ProbThreshold Posterior probability threshold used in differential 
#' test.
#' @slot EFDR,EFNR Expected false discovery and expected false negative rates
#' for differential test.
#' @slot EFDRgrid,EFNRgrid Grid of EFDR and EFNR values calculated before 
#' thresholds were fixed.
#' @slot Epsilon Minimum fold change or difference threshold.
#' @slot Extra objects for class flexibility.
setClass("BASiCS_ResultDE",
  representation = representation(
    GroupLabel1 = "character",
    GroupLabel2 = "character",
    EFDRgrid = "numeric",
    EFNRgrid = "numeric",
    Epsilon = "numeric"
  ),
  contains = "BASiCS_Result",
  validity = function(object) {
    assert_that(
      length(object@GroupLabel1) == 1,
      length(object@GroupLabel2) == 1,
      length(object@EFDRgrid) == length(object@EFNRgrid),
      length(object@Epsilon) == 1,
      object@Epsilon >= 0
    )
  }
)

#' @name BASiCS_ResultVG
#' @aliases BASiCS_ResultVG-class
#'
#' @title The BASiCS_ResultVG class
#'
#' @description Container of results for a single HVG/LVG test.
#' @slot Method Character value detailing whether the test performed using 
#' a threshold directly on epsilon values (\code{Method="Epsilon"}),
#' variance decomposition (\code{Method="Variance"}) or percentiles of epsilon 
#' (\code{Method="Percentile"}).
#' @slot RowData Optional \linkS4class{DataFrame} containing 
#' additional information about genes used in the test.
#' @slot EFDRgrid,EFNRgrid Grid of EFDR and EFNR values calculated before 
#' thresholds were fixed.
#' @slot Threshold Threshold used to calculate tail posterior probabilities 
#' for the HVG or LVG decision rule.
#' @slot ProbThresholds Probability thresholds used to calculate 
#' \code{EFDRGrid} and \code{EFNRGrid}.
#' @slot ProbThreshold Posterior probability threshold used in the HVG/LVG 
#' decision rule.
#' 
setClass("BASiCS_ResultVG",
  representation = representation(
    Method = "character",
    RowData = "DataFrame",
    EFDRgrid = "numeric",
    EFNRgrid = "numeric",
    Threshold = "numeric",
    ProbThresholds = "numeric",
    ProbThreshold = "numeric"
  ),
  contains = "BASiCS_Result",
  validity = function(object) {
    assert_that(
      length(object@Method) == 1,
      !is.null(object@RowData$GeneName),
      length(object@EFDRgrid) == length(object@EFNRgrid),
      length(object@EFNRgrid) == length(object@ProbThresholds),
      all(object@EFDRgrid >= 0, na.rm = TRUE),
      all(object@EFDRgrid <= 1, na.rm = TRUE),
      all(object@EFNRgrid >= 0, na.rm = TRUE),
      all(object@EFNRgrid <= 1, na.rm = TRUE),
      all(object@ProbThresholds >= 0, na.rm = TRUE),
      all(object@ProbThresholds <= 1, na.rm = TRUE),
      length(object@ProbThreshold) == 1,
      object@ProbThreshold >= 0,
      object@ProbThreshold <= 1
    )
  }
)
