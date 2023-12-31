#ifndef UPDATESREGNOSPIKES_H
#define UPDATESREGNOSPIKES_H


#include "utils.h"

/* Metropolis-Hastings updates of mu 
 * Updates are implemented simulateaneously for all biological genes
 */
// [[Rcpp::export(".muUpdateRegNoSpikes")]]
arma::mat muUpdateRegNoSpikes(
    arma::vec const& mu0, 
    arma::vec const& prop_var, 
    arma::mat const& Counts,  
    arma::vec const& delta,
    arma::vec const& invdelta, 
    arma::vec const& nu, 
    arma::vec const& sum_bycell_all,
    arma::vec const& mu_mu,
    double const& s2_mu,
    int const& q0,
    int const& n,
    arma::vec & mu1,
    arma::vec & u,
    arma::vec & ind,
    double const& SizeTimesConstrain, /* No-spikes arguments from here */
    int const& RefGene,
    arma::uvec const& ConstrainGene,
    arma::uvec const& NotConstrainGene,
    int const& k, /* Regression arguments from here */
    arma::vec const& lambda,
    arma::vec const& beta,
    arma::mat const& X,
    double const& sigma2,
    double variance,
    bool FixLocations,
    bool RBFMinMax,
    arma::vec RBFLocations,
    double const& exponent,
    double const& mintol) {

  using arma::span;
  
  int nConstrainGene = ConstrainGene.size();
  int nNotConstrainGene = NotConstrainGene.size();
  
  // PROPOSAL STEP    
  mu1 = exp(arma::randn(q0) % sqrt(prop_var) + log(mu0));
  u = arma::randu(q0);
  
  // INITIALIZE MU
  double aux; double iAux;
  double sumAux = sum(log(mu0.elem(ConstrainGene))) - log(mu0(RefGene));
  //Rcout << "sumAux (line 54): " << sumAux << std::endl;
  
  // ACCEPT/REJECT STEP
  
  // Step 1: Computing the likelihood contribution of the acceptance rate 
  // Calculated in the same way for all genes, 
  // but the reference one (no need to be sequential)
  arma::vec log_aux = (log(mu1) - log(mu0)) % sum_bycell_all;
 // Rcout << "sumAux (line 62): " << sumAux << std::endl;
  #pragma omp parallel for
  for (int i = 0; i < q0; i++) {
    if(i != RefGene) {
      for (int j=0; j < n; j++) {
        log_aux(i) -= (Counts(i,j) + invdelta(i)) *
          log(
            (nu(j) * mu1(i) + invdelta(i)) / 
            (nu(j) * mu0(i) + invdelta(i))
          );
      }
    }
  }
  //Rcout << "sumAux (line 75): " << sumAux << std::endl;
  // Revise this part
  // This is new due to regression prior on delta
  if (!FixLocations) {  
    RBFLocations = estimateRBFLocations(log(mu1), k, RBFMinMax);
  }
  //Rcout << "sumAux (line 81): " << sumAux << std::endl;
  arma::mat X_mu1 = designMatrix(k, RBFLocations, mu1, variance);
 // Rcout << "sumAux (line 82): " << sumAux << std::endl;
  
  // REGRESSION RELATED FACTOR
  log_aux -= exponent * lambda % 
    (
      pow(log(delta) - X_mu1 * beta, 2) -
      pow(log(delta) - X * beta, 2)
    ) / (2 * sigma2);
  //Rcout << "sumAux (line 91): " << sumAux << std::endl;
  
  // Step 2: Computing prior component of the acceptance rate 
  
  // Step 2.1: For genes that are under the constrain (excluding the reference one)
  for (int i = 0; i < nConstrainGene; i++) {
    iAux = ConstrainGene(i);
    if (iAux != RefGene) {
      aux = 0.5 * (SizeTimesConstrain - (sumAux - log(mu0(iAux))));
      aux += 0.5 * (mu_mu(iAux) - mu_mu(RefGene));
      log_aux(iAux) -= (0.5 * 2 / s2_mu) * 
        (pow(log(mu1(iAux)) - aux, 2)) * exponent; 
      log_aux(iAux) += (0.5 * 2 / s2_mu) * 
        (pow(log(mu0(iAux)) - aux, 2)) * exponent;

      // ACCEPT REJECT
      if((log(u(iAux)) < log_aux(iAux)) & (mu1(iAux) > mintol)) {
        ind(iAux) = 1;
        sumAux += log(mu1(iAux)) - log(mu0(iAux)); 
      }
      else{
        ind(iAux) = 0;
        mu1(iAux) = mu0(iAux);
      }
    }
  }
  Rcout << "sumAux (line 117): " << sumAux << std::endl;
  
  // Step 2.2: For the reference gene 
  ind(RefGene) = 1;
  mu1(RefGene) = exp(SizeTimesConstrain - sumAux);
  //Rcout << "sumAux (line 122): " << sumAux << std::endl;
  //Rcout << "ConstrainGene.size() * Constrain - sumAux: " << SizeTimesConstrain - sumAux << std::endl;
  //Rcout << "ConstrainGene.size() * Constrain: " << SizeTimesConstrain << std::endl;
  //Rcout << "mu1(RefGene): " << mu1(RefGene) << std::endl;
  
  // Step 2.3: For genes that are *not* under the constrain
  // Only relevant for a trimmed constrain
  #pragma omp parallel for
  for (int i=0; i < nNotConstrainGene; i++) {
    iAux = NotConstrainGene(i);
    log_aux(iAux) -= (0.5 / s2_mu) * 
      (
          pow(log(mu1(iAux)) - mu_mu(iAux), 2) - 
          pow(log(mu0(iAux)) - mu_mu(iAux), 2)
      ) * exponent;
      
    // ACCEPT REJECT
    if ((log(u(iAux)) < log_aux(iAux)) & (mu1(iAux) > mintol)) {
      ind(iAux) = 1;
    } else{
      ind(iAux) = 0; mu1(iAux) = mu0(iAux);
    }
    //Rcout << "sumAux (line 144): " << sumAux << std::endl;
  }
  // OUTPUT
  return join_rows(mu1, ind);
}


/* Metropolis-Hastings updates of delta
* Updates are implemented simulateaneously for all biological genes
*/
// [[Rcpp::export(".deltaUpdateRegNoSpikes")]]
arma::mat deltaUpdateRegNoSpikes(
    arma::vec const& delta0,
    arma::vec const& prop_var,  
    arma::mat const& Counts, 
    arma::vec const& mu, 
    arma::vec const& nu, 
    int const& q0,
    int const& n,
    arma::vec & delta1,
    arma::vec & u, 
    arma::vec & ind,
    arma::vec const& lambda,
    arma::mat const& X,
    double const& sigma2,
    arma::vec const& beta,
    double const& exponent,
    double const& mintol)
{
  using arma::span;
  
  // PROPOSAL STEP
  delta1 = exp(arma::randn(q0) % sqrt(prop_var) + log(delta0));
  u = arma::randu(q0);
  
  // ACCEPT/REJECT STEP 
  arma::vec log_aux = - n * (lgamma_cpp(1 / delta1) - lgamma_cpp(1 / delta0));
  // +1 should appear because we update log(delta) not delta. 
  // However, it cancels out with the prior. 
  log_aux -= n * ((log(delta1) / delta1) - (log(delta0) / delta0));
  
  // Loop to replace matrix operations, through genes and cells
  #pragma omp parallel for
  for (int i = 0; i < q0; i++) {
    for (int j = 0; j < n; j++) {
      log_aux(i) += std::lgamma(Counts(i, j) + (1 / delta1(i)));
      log_aux(i) -= std::lgamma(Counts(i, j) + (1 / delta0(i)));
      log_aux(i) -= (Counts(i, j) + (1 / delta1(i))) * 
        log(nu(j) * mu(i) + (1 / delta1(i)));
      log_aux(i) += (Counts(i, j) + (1 / delta0(i))) * 
        log(nu(j) * mu(i) + (1 / delta0(i)));
    } 
  }
  
  // REGRESSION RELATED FACTOR
  // Some terms might cancel out here; check
  log_aux -= exponent * lambda % 
    (
      pow(log(delta1) - X * beta, 2) -
      pow(log(delta0) - X * beta, 2)
    ) / (2 * sigma2);
  
  // CREATING OUTPUT VARIABLE & DEBUG
  ind = DegubInd(ind, q0, u, log_aux, delta1, mintol, "delta");
  for (int i=0; i < q0; i++) {
    if(ind(i) == 0) {
      delta1(i) = delta0(i);
    }
  }
  
  // OUTPUT
  return join_rows(delta1, ind);
}

#endif
