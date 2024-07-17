functions {

  real gev_lpdf(vector y, real mu, real sigma, real xi) {
    int n = rows(y);
    vector[n] eta;
    real lp = 0; // log-likelihood;

    for (i in 1:n) {
      eta[i] = abs(xi) < 1e-12 ? pow(1 + xi * (y[i] - mu) / sigma, -1 / xi)
                               : exp((y[i] - mu) / sigma);

      lp += (1 + xi) * eta[i] - eta[i];
    }

    lp += -n * log(sigma);
    return lp;
  }

}
