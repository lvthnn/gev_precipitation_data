#include gev.stan

data {
  int<lower = 0> n;
  vector[n] y;
}

parameters {
  real<lower = 0> mu_0;
  real<lower = 0> sigma;
  real<lower = 0, upper = 1> xi_0;
  real delta;
}

transformed parameters {
  real xi = 2 * xi_0 - 1;
}

model {
  mu_0 ~ normal(0, 100^2);
  sigma ~ exponential(0.5);
  xi_0 ~ beta(4, 4);
  delta ~ normal(0, 100^2);

  y ~ gevt(mu_0, sigma, xi, delta);
}
