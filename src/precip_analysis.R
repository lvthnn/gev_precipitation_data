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
  file = "src/stan/nullmodel.stan",
  data = model_data,
  chains = 4,
  iter = 13000,
  warmup = 3000,
  init_r = 0.5
)

# Time trend model
timetrend_fit <- rstan::stan(
  file = "src/stan/timetrend.stan",
  data = model_data,
  iter = 13000,
  warmup = 3000,
  chains = 4,
  init_r = 0.5
)

# Hierarchical model -- i.i.d. prior for random effects

m <- 6
t_m <- floor(seq(1, nrow(dt_maxprecip), length = m + 2))[-c(1, m + 2)]

hmodel_data <- list(
  n = nrow(dt_maxprecip),
  m = m,
  y = dt_maxprecip$max_precip,
  t_m = floor(seq(1, nrow(dt_maxprecip), length = m + 2))[-c(1, m + 2)]
)

iid_fit <- rstan::stan(
  file = "src/stan/hierarchical_iid.stan",
  data = hmodel_data,
  iter = 13000,
  warmup = 3000,
  chains = 4,
  init_r = 0.5
)

# Evaluation
# - PSIS
# - WAIC
# - QQplot (ath. smá handavinna fyrir non-stationary dreifingar)
# - Trend línur
# - Return level? [hentar ekki vel fyrir non-stationary]
#   - Virkar vel fyrir stationary tímaröð
#   - Hvaða stærð fær maður á flóði fyrir gefinn endurkomutíma?
#     — x. t — 1/(1 - q) — q quantile af breytunni [length of return period]
#     — y. quantile of the random variable [return level]

rw_fit <- rstan::stan(
  file = "src/stan/hierarchical_rw.stan",
  data = hmodel_data,
  iter = 13000,
  warmup = 3000,
  chains = 4,
  init_r = 0.5
)

ar1_fit <- rstan::stan(
  file = "src/stan/hierarchical_ar1.stan",
  data = hmodel_data,
  iter = 13000,
  warmup = 3000,
  chains = 4,
  init_r = 0.5
)
