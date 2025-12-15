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

# Bayesian model
tau0 <- 0.8
xi0  <- 1

chains <- 4
iter   <- 2000
warmup <- 1000
seed   <- 123
control_list <- list(adapt_delta = 0.99, max_treedepth = 15)


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
# Fit on ALL data
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

# Show Result
View(beta_df)

# 95% CI of Beta
beta_mid_lo <- apply(beta_draws, c(2,3), quantile, probs = 0.025)
beta_mid_hi <- apply(beta_draws, c(2,3), quantile, probs = 0.975)

beta_df$mid_lo <- as.vector(beta_mid_lo)
beta_df$mid_hi <- as.vector(beta_mid_hi)


