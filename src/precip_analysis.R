library(rstan)

dt_maxprecip <- readr::read_csv(
  file = "data/dt_maxprecip.csv",
  show_col_types = FALSE
)

null_data <- list(
  n = nrow(dt_maxprecip),
  y = dt_maxprecip$max_precip
)

null_fit <- stan(
  file = "src/nullmodel.stan",
  data = null_data,
  chains = 1,
)
