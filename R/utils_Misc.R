## Slightly optimised version of 
## coda::effectiveSize 
## https://cran.r-project.org/web/packages/coda/
#' @importFrom matrixStats colVars
#' @importFrom stats ar setNames
ess <- function(x) {
  vars <- matrixStats::colVars(x)
  spec <- numeric(ncol(x))
  has_var <- vars != 0
  if (any(has_var, na.rm = TRUE)) {
    spec[which(has_var)] <- apply(x[, which(has_var), drop = FALSE],
      2,
      function(y) {
        a <- ar(y, aic = TRUE)
        a$var.pred / (1 - sum(a$ar)) ^ 2
      }
    )
  }
  setNames(ifelse(spec == 0, 0, nrow(x) * vars / spec), colnames(x))
}

.ScaleName <- function(Measure = c("ess", "geweke.diag", "rhat"),
                       Parameter = NULL) {

  Measure <- match.arg(Measure)
  measure_name <- switch(Measure,
    ess = "Effective sample size",
    geweke.diag = "Geweke diagnostic",
    rhat = bquote(hat(R))
  )
  if (!is.null(Parameter)) {
    measure_name <- paste0(measure_name, ": ", Parameter)
  }
  measure_name
}

#' @importFrom coda geweke.diag
.GetMeasure <- function(Chain, 
                        Parameter,
                        Measure = c("ess", "geweke.diag", "rhat"),
                        na.rm = FALSE) {

  Measure <- match.arg(Measure)
  MeasureFun <- match.fun(Measure)
  mat <- .GetParam(Chain, Parameter)
  if (Measure == "ess" & !is.null(attr(mat, "ESS"))) {
    return(attr(mat, "ESS"))
  }

  if (na.rm) {
    mat <- mat[, !apply(mat, 2, function(col) any(is.na(col)))]
    if (!ncol(mat)) {
      stop(paste("No non-NA samples for", Parameter))
    }
  }
  if (Measure == "rhat") {
    return(apply(mat, 2, posterior::rhat))
  }
  metric <- MeasureFun(coda::mcmc(mat))
  if (Measure == "geweke.diag") {
    metric <- metric$z
  }
  metric
}

.GetParam <- function(object, Parameter = "mu") {
  if (is.null(Parameter) || 
      is.na(Parameter) || 
      length(Parameter) > 1 ||
      !(Parameter %in% names(object@parameters))) {
    stop("'Parameter' argument is invalid")
  }
  object@parameters[[Parameter]]
}

.CheckValidCombination <- function(...) {
  Params <- list(...)
  Check1 <- vapply(Params, 
                   FUN = function(x) is.null(x) || x %in% .GeneParams(),
                   FUN.VALUE = TRUE)
  Check2 <- vapply(Params, 
                   FUN = function(x) is.null(x) || x  %in% .CellParams(),
                   FUN.VALUE = TRUE)
  
  if (!(all(Check1) || all(Check2))) {
    stop(paste("Invalid combination of parameters:",
               paste(list(...), collapse = ", "), " \n"))
  } 
}

.GeneParams <- function() c("mu", "delta", "epsilon", "lambda")
.CellParams <- function() c("s", "phi", "nu")
.GlobalParams <- function() c("theta", "beta", "sigma2")
.OtherParams <- function() c("RefFreq", "designMatrix", "RBFLocations", "ESS", paste("ls", c("mu", "delta", "phi", "nu", "theta"), sep = "."))

.NClassFD2D <- function(x, y) {
  max(nclass.FD(x), nclass.FD(y))
}

.MeasureName <- function(measure) {
  switch(measure,
    "Mean" = "mean expression",
    "Disp" = "over dispersion",
    "ResDisp" = "residual over dispersion"
  )
}

.DistanceName <- function(measure) {
  switch(measure,
    "ResDisp" = "distance",
    "fold change")
}

.LogDistanceName <- function(measure) {
  switch(measure,
    "ResDisp" = "distance",
    "log2(fold change)"
  )
}

.DistanceVar <- function(measure) {
  switch(measure,
    "ResDisp" = "Distance",
    "Log2FC"
  )
}

.cap <- function(s) {
  sub("([[:alpha:]])([[:alpha:]]+)", "\\U\\1\\L\\2", s, perl = TRUE)
}

.NSamples <- function(Chain) {
  nrow(Chain@parameters[[1]])
}
