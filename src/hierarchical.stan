#include gev.stan

data {
  int<lower = 0> n;
  int<lower = 0> m;
  vector[n] y;
  vector[n] t;
  vector[m] t_j;
}

parameters {
  vector[m] beta;
  real<lower = 0> sigma;
  real<lower = 0, upper = 1> xi_0;  
  real tau;
}

transformed parameters {
  real xi = xi_0 - 0.5;
}

model {
  tau ~ exponential(2.0);
  sigma ~ exponential(0.5);
  xi_0 ~ beta(4, 4);
  
  vector[n] mu;

  for (j in 1:m) {
    beta[j] ~ normal(0, tau^2);
  }

  for (i in 1:n) {
    mu[i] = 0;
    for (j in 1:m) {
      if (t[i] > t[j]) {
        mu[i] += beta[j] * (t[i] - t[j]);
      }
    }
    y[i] ~ gev(mu[i], sigma, xi);
  }
}
