# install.packages('rstan')

library(rstan)
library(readr)
library(dplyr)
library(ggplot2)


# ----------------------------
# Load data
# ----------------------------
df <- read_csv("df_normalized.csv", show_col_types = FALSE) %>% as.data.frame()

# ----------------------------
# Settings
# ----------------------------

# Earning Warning Indicators 
ewi_num <- names(df)[sapply(df, is.numeric)]
ewi_col  <- setdiff(ewi_num, c("year", "crisis"))

# MCMC modeling
tau0 <- 0.8
xi0  <- 1

chains <- 4
iter   <- 4000
warmup <- 2000
seed   <- 123
control_list <- list(adapt_delta = 0.95, max_treedepth = 12)


# Keep needed columns, drop missing
d <- df[, c('year', 'crisis', ewi_col), drop = FALSE]
# Delete NA if exists
d <- d[complete.cases(d), , drop = FALSE]

# ----------------------------
# Build full-sample time index tt and X
# ----------------------------
all_years <- sort(unique(d[["year"]]))
T_all <- length(all_years)
tt_all <- match(d[["year"]], all_years)   # Map years to index

X_ewi <- as.matrix(d[ , ewi_col, drop = FALSE])

N_all <- nrow(X_ewi)
P <- ncol(X_ewi)

stan_data_all <- list(
  N    = N_all,
  T    = T_all,
  P    = P,
  tt   = tt_all,
  X    = X_ewi,
  y    = as.integer(d[['crisis']]),
  tau0 = tau0,
  xi0  = xi0
)

# ----------------------------
# Fit on ALL data (in-sample)
# ----------------------------
fit_all <- stan(
  file = "Sparse_TVP.stan",
  data = stan_data_all,
  chains = chains,
  iter = iter,
  warmup = warmup,
  seed = seed,
  control = control_list
)

beta_draws <- rstan::extract(fit_all, pars = "beta")$beta

# Beta results
beta_med <- apply(beta_draws, c(2,3), median)
beta_low <- apply(beta_draws, c(2,3), quantile, probs = 0.025)
beta_high <- apply(beta_draws, c(2,3), quantile, probs = 0.975)

beta_df <- data.frame(
                  t_idx    = rep(1:T_all, times=P),
                  year     = rep(all_years,times=P),
                  variable = rep(ewi_col, each = T_all),
                  med      = as.vector(beta_med),
                  low      = as.vector(beta_low),
                  high    = as.vector(beta_high)
)

