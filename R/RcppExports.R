# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

.BASiCS_DenoisedRates <- function(CountsBio, Mu, TransInvDelta, PhiNu, N, q0, n) {
    .Call('_BASiCS_BASiCS_DenoisedRates', PACKAGE = 'BASiCS', CountsBio, Mu, TransInvDelta, PhiNu, N, q0, n)
}

.BASiCS_MCMCcpp <- function(N, Thin, Burn, Counts, BatchDesign, muSpikes, mu0, delta0, phi0, s0, nu0, theta0, mu_mu, s2mu, adelta, bdelta, s2delta, prior_delta, aphi, as, bs, atheta, btheta, ar, LSmu0, LSdelta0, LSphi0, LSnu0, LStheta0, sumByCellBio, sumByGeneAll, sumByGeneBio, StoreAdapt, EndAdapt, PrintProgress, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, threads = 1L) {
    .Call('_BASiCS_BASiCS_MCMCcpp', PACKAGE = 'BASiCS', N, Thin, Burn, Counts, BatchDesign, muSpikes, mu0, delta0, phi0, s0, nu0, theta0, mu_mu, s2mu, adelta, bdelta, s2delta, prior_delta, aphi, as, bs, atheta, btheta, ar, LSmu0, LSdelta0, LSphi0, LSnu0, LStheta0, sumByCellBio, sumByGeneAll, sumByGeneBio, StoreAdapt, EndAdapt, PrintProgress, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, threads)
}

.BASiCS_MCMCcppNoSpikes <- function(N, Thin, Burn, Counts, BatchDesign, mu0, delta0, s0, nu0, theta0, mu_mu, s2mu, adelta, bdelta, s2delta, prior_delta, as, bs, atheta, btheta, SizeTimesConstrain, Index, RefGene, RefGenes, ConstrainGene, NotConstrainGene, StochasticRef, ar, LSmu0, LSdelta0, LSnu0, LStheta0, sumByCellAll, sumByGeneAll, StoreAdapt, EndAdapt, PrintProgress, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, fixNu, threads = 1L) {
    .Call('_BASiCS_BASiCS_MCMCcppNoSpikes', PACKAGE = 'BASiCS', N, Thin, Burn, Counts, BatchDesign, mu0, delta0, s0, nu0, theta0, mu_mu, s2mu, adelta, bdelta, s2delta, prior_delta, as, bs, atheta, btheta, SizeTimesConstrain, Index, RefGene, RefGenes, ConstrainGene, NotConstrainGene, StochasticRef, ar, LSmu0, LSdelta0, LSnu0, LStheta0, sumByCellAll, sumByGeneAll, StoreAdapt, EndAdapt, PrintProgress, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, fixNu, threads)
}

.BASiCS_MCMCcppReg <- function(N, Thin, Burn, Counts, BatchDesign, muSpikes, mu0, delta0, phi0, s0, nu0, theta0, mu_mu, s2mu, aphi, as, bs, atheta, btheta, k, m0, V0, sigma2_a0, sigma2_b0, beta0, sigma20, eta0, lambda0, variance, ar, LSmu0, LSdelta0, LSphi0, LSnu0, LStheta0, sumByCellBio, sumByGeneAll, sumByGeneBio, StoreAdapt, EndAdapt, PrintProgress, FixLocations, RBFMinMax, RBFLocations, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, threads = 1L) {
    .Call('_BASiCS_BASiCS_MCMCcppReg', PACKAGE = 'BASiCS', N, Thin, Burn, Counts, BatchDesign, muSpikes, mu0, delta0, phi0, s0, nu0, theta0, mu_mu, s2mu, aphi, as, bs, atheta, btheta, k, m0, V0, sigma2_a0, sigma2_b0, beta0, sigma20, eta0, lambda0, variance, ar, LSmu0, LSdelta0, LSphi0, LSnu0, LStheta0, sumByCellBio, sumByGeneAll, sumByGeneBio, StoreAdapt, EndAdapt, PrintProgress, FixLocations, RBFMinMax, RBFLocations, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, threads)
}

.BASiCS_MCMCcppRegNoSpikes <- function(N, Thin, Burn, Counts, BatchDesign, mu0, delta0, s0, nu0, theta0, mu_mu, s2mu, as, bs, atheta, btheta, k, m0, V0, sigma2_a0, sigma2_b0, beta0, sigma20, eta0, lambda0, variance, SizeTimesConstrain, Index, RefGene, RefGenes, ConstrainGene, NotConstrainGene, StochasticRef, ar, LSmu0, LSdelta0, LSnu0, LStheta0, sumByCellAll, sumByGeneAll, StoreAdapt, EndAdapt, PrintProgress, RBFMinMax, FixLocations, RBFLocations, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, fixNu, threads = 1L) {
    .Call('_BASiCS_BASiCS_MCMCcppRegNoSpikes', PACKAGE = 'BASiCS', N, Thin, Burn, Counts, BatchDesign, mu0, delta0, s0, nu0, theta0, mu_mu, s2mu, as, bs, atheta, btheta, k, m0, V0, sigma2_a0, sigma2_b0, beta0, sigma20, eta0, lambda0, variance, SizeTimesConstrain, Index, RefGene, RefGenes, ConstrainGene, NotConstrainGene, StochasticRef, ar, LSmu0, LSdelta0, LSnu0, LStheta0, sumByCellAll, sumByGeneAll, StoreAdapt, EndAdapt, PrintProgress, RBFMinMax, FixLocations, RBFLocations, mintol_mu, mintol_delta, mintol_nu, mintol_theta, geneExponent, cellExponent, fixNu, threads)
}

.muUpdate <- function(mu0, prop_var, Counts, invdelta, phinu, sum_bycell_bio, mu_mu, s2_mu, q0, n, mu1, u, ind, exponent, mintol) {
    .Call('_BASiCS_muUpdate', PACKAGE = 'BASiCS', mu0, prop_var, Counts, invdelta, phinu, sum_bycell_bio, mu_mu, s2_mu, q0, n, mu1, u, ind, exponent, mintol)
}

.deltaUpdate <- function(delta0, prop_var, Counts, mu, phinu, a_delta, b_delta, s2delta, prior_delta, q0, n, delta1, u, ind, exponent, mintol) {
    .Call('_BASiCS_deltaUpdate', PACKAGE = 'BASiCS', delta0, prop_var, Counts, mu, phinu, a_delta, b_delta, s2delta, prior_delta, q0, n, delta1, u, ind, exponent, mintol)
}

.phiUpdate <- function(phi0, prop_var, Counts, mu, invdelta, nu, aphi, sum_bygene_bio, q0, n, phi1, exponent) {
    .Call('_BASiCS_phiUpdate', PACKAGE = 'BASiCS', phi0, prop_var, Counts, mu, invdelta, nu, aphi, sum_bygene_bio, q0, n, phi1, exponent)
}

.sUpdateBatch <- function(s0, nu, thetaBatch, as, bs, BatchDesign, n, s1, exponent) {
    .Call('_BASiCS_sUpdateBatch', PACKAGE = 'BASiCS', s0, nu, thetaBatch, as, bs, BatchDesign, n, s1, exponent)
}

.nuUpdateBatch <- function(nu0, prop_var, Counts, SumSpikeInput, BatchDesign, mu, invdelta, phi, s, thetaBatch, sum_bygene_all, q0, n, nu1, u, ind, exponent, mintol) {
    .Call('_BASiCS_nuUpdateBatch', PACKAGE = 'BASiCS', nu0, prop_var, Counts, SumSpikeInput, BatchDesign, mu, invdelta, phi, s, thetaBatch, sum_bygene_all, q0, n, nu1, u, ind, exponent, mintol)
}

.thetaUpdateBatch <- function(theta0, prop_var, BatchDesign, BatchSizes, s, nu, a_theta, b_theta, n, nBatch, exponent, mintol) {
    .Call('_BASiCS_thetaUpdateBatch', PACKAGE = 'BASiCS', theta0, prop_var, BatchDesign, BatchSizes, s, nu, a_theta, b_theta, n, nBatch, exponent, mintol)
}

.muUpdateNoSpikes <- function(mu0, prop_var, Counts, invdelta, nu, sum_bycell_all, mu_mu, s2_mu, q0, n, mu1, u, ind, SizeTimesConstrain, RefGene, ConstrainGene, NotConstrainGene, exponent, mintol) {
    .Call('_BASiCS_muUpdateNoSpikes', PACKAGE = 'BASiCS', mu0, prop_var, Counts, invdelta, nu, sum_bycell_all, mu_mu, s2_mu, q0, n, mu1, u, ind, SizeTimesConstrain, RefGene, ConstrainGene, NotConstrainGene, exponent, mintol)
}

.nuUpdateBatchNoSpikes <- function(nu0, prop_var, Counts, BatchDesign, mu, invdelta, s, thetaBatch, sum_bygene_all, q0, n, nu1, u, ind, exponent, mintol) {
    .Call('_BASiCS_nuUpdateBatchNoSpikes', PACKAGE = 'BASiCS', nu0, prop_var, Counts, BatchDesign, mu, invdelta, s, thetaBatch, sum_bygene_all, q0, n, nu1, u, ind, exponent, mintol)
}

.designMatrix <- function(k, RBFLocations, mu, variance) {
    .Call('_BASiCS_designMatrix', PACKAGE = 'BASiCS', k, RBFLocations, mu, variance)
}

.estimateRBFLocations <- function(log_mu, k, RBFMinMax) {
    .Call('_BASiCS_estimateRBFLocations', PACKAGE = 'BASiCS', log_mu, k, RBFMinMax)
}

.muUpdateReg <- function(mu0, prop_var, Counts, delta, phinu, sum_bycell_bio, mu_mu, s2_mu, q0, n, mu1, u, ind, k, lambda, beta, X, sigma2, variance, FixLocations, RBFMinMax, RBFLocations, exponent, mintol) {
    .Call('_BASiCS_muUpdateReg', PACKAGE = 'BASiCS', mu0, prop_var, Counts, delta, phinu, sum_bycell_bio, mu_mu, s2_mu, q0, n, mu1, u, ind, k, lambda, beta, X, sigma2, variance, FixLocations, RBFMinMax, RBFLocations, exponent, mintol)
}

.deltaUpdateReg <- function(delta0, prop_var, Counts, mu, phinu, q0, n, delta1, u, ind, lambda, X, sigma2, beta, exponent, mintol) {
    .Call('_BASiCS_deltaUpdateReg', PACKAGE = 'BASiCS', delta0, prop_var, Counts, mu, phinu, q0, n, delta1, u, ind, lambda, X, sigma2, beta, exponent, mintol)
}

.betaUpdateReg <- function(sigma2, VAux, mAux) {
    .Call('_BASiCS_betaUpdateReg', PACKAGE = 'BASiCS', sigma2, VAux, mAux)
}

.sigma2UpdateReg <- function(delta, beta, lambda, V1, mInvVm0, m, sigma2_a0, sigma2_b0, q0, exponent) {
    .Call('_BASiCS_sigma2UpdateReg', PACKAGE = 'BASiCS', delta, beta, lambda, V1, mInvVm0, m, sigma2_a0, sigma2_b0, q0, exponent)
}

.lambdaUpdateReg <- function(delta, X, beta, sigma2, eta, q0, lambda1, exponent) {
    .Call('_BASiCS_lambdaUpdateReg', PACKAGE = 'BASiCS', delta, X, beta, sigma2, eta, q0, lambda1, exponent)
}

.muUpdateRegNoSpikes <- function(mu0, prop_var, Counts, delta, invdelta, nu, sum_bycell_all, mu_mu, s2_mu, q0, n, mu1, u, ind, SizeTimesConstrain, RefGene, ConstrainGene, NotConstrainGene, k, lambda, beta, X, sigma2, variance, FixLocations, RBFMinMax, RBFLocations, exponent, mintol) {
    .Call('_BASiCS_muUpdateRegNoSpikes', PACKAGE = 'BASiCS', mu0, prop_var, Counts, delta, invdelta, nu, sum_bycell_all, mu_mu, s2_mu, q0, n, mu1, u, ind, SizeTimesConstrain, RefGene, ConstrainGene, NotConstrainGene, k, lambda, beta, X, sigma2, variance, FixLocations, RBFMinMax, RBFLocations, exponent, mintol)
}

.deltaUpdateRegNoSpikes <- function(delta0, prop_var, Counts, mu, nu, q0, n, delta1, u, ind, lambda, X, sigma2, beta, exponent, mintol) {
    .Call('_BASiCS_deltaUpdateRegNoSpikes', PACKAGE = 'BASiCS', delta0, prop_var, Counts, mu, nu, q0, n, delta1, u, ind, lambda, X, sigma2, beta, exponent, mintol)
}

.rDirichlet <- function(alpha) {
    .Call('_BASiCS_rDirichlet', PACKAGE = 'BASiCS', alpha)
}

