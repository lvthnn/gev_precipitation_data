library(rstan)

dt_maxprecip <- readr::read_csv(
  file = "data/dt_maxprecip.csv",
  show_col_types = FALSE
)

model_data <- list(
  n = nrow(dt_maxprecip),
  y = dt_maxprecip$max_precip
)

# set up cores

options(mc.cores = parallel::detectCores())

# null model

null_fit <- stan(
  file = "src/nullmodel.stan",
  data = model_data,
  chains = 4,
  iter = 13000,
  warmup = 3000
)

# time trend model

timetrend_fit <- stan(
  file = "src/timetrend.stan",
  data = model_data,
  iter = 13000,
  chains = 4
)
