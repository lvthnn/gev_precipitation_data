functions {

  real gev_lpdf(vector y, real mu, real sigma, real xi) {
    int n = rows(y);

    vector[n] eta = (abs(xi) < 1e-12)
                    ? exp(-(y - mu) / sigma)
                    : pow(1 + xi * (y - mu) / sigma, -1 / xi);

    real lp = -n * log(sigma) + sum((1 + xi) * log(eta)) - sum(eta);

    return lp;
  }

  real gevt_lpdf(vector y, real mu_0, real sigma, real xi, real delta) {
    int n = rows(y);
    vector[n] mu;

    for (i in 1:n) { mu[i] = mu_0 * (1 + delta * (i - 1)); }

    vector[n] eta = (abs(xi) < 1e-12)
                    ? exp(-(y - mu) / sigma)
                    : pow(1 + xi * (y - mu) / sigma, -1 / xi);
    
    real lp = -n * log(sigma) + sum((1 + xi) * log(eta)) - sum(eta);

    return lp;
  }

}
