#include gev.stan

data {
  int<lower = 0> n;
  vector[n] y;
}

parameters {
  real mu;
  real<lower = 0> sigma;
  real<lower = 0, upper = 1> xi_0;
}

transformed parameters {
   real xi = xi_0 - 1;
}

model {
  mu ~ normal(0, 100^2);
  sigma ~ exponential(2);
  xi_0 ~ beta(4, 4);

  y ~ gev(mu, sigma, xi);
}
