# Load in the data
dt_maxprecip <- readr::read_csv(
  file = "data/dt_maxprecip.csv",
  show_col_types = FALSE
)

model_data <- list(
  n = nrow(dt_maxprecip),
  y = dt_maxprecip$max_precip
)

# Set up parallel cores
options(mc.cores = parallel::detectCores())

# Null model
null_fit <- rstan::stan(
  file = "src/nullmodel.stan",
  data = model_data,
  chains = 4,
  iter = 2000,
  warmup = 1000,
  pars = c("mu", "sigma", "xi")
)

# Time trend model
timetrend_fit <- rstan::stan(
  file = "src/timetrend.stan",
  data = model_data,
  iter = 13000,
  chains = 4,
  init_r = 0.5
)

# Hierarchical model -- i.i.d. prior for random effects

m <- 10
t_m <- floor(seq(1, nrow(dt_maxprecip), length = m + 2))[-c(1, m + 2)]

hmodel_data <- list(
  n = nrow(dt_maxprecip),
  m = m,
  y = dt_maxprecip$max_precip,
  t_m = floor(seq(1, nrow(dt_maxprecip), length = m + 2))[-c(1, m + 2)]
)

iid_fit <- rstan::stan(
  file = "src/hierarchical_iid.stan",
  data = hmodel_data,
  iter = 13000,
  warmup = 3000,
  chains = 4,
  init_r = 0.5
)

# Extract the log-likelihood matrix
log_lik <- loo::extract_log_lik(iid_fit, parameter_name = "log_lik")

# Apply Pareto Smoothed Importance Sampling
psis_results <- loo::psis(log_lik)
