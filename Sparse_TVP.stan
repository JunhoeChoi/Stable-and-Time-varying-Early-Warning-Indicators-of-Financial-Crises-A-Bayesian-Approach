data {
int<lower=1> N;                         // Total obs
  int<lower=1> T;                       // Years
  int<lower=1> P;                       // number of variables
  array[N] int<lower=1, upper=T> tt;    // time index (1..T) for each obs
  matrix[N, P] X;                       // Normalized variables
  array[N] int<lower=0, upper=1> y;     // Crisis

  real<lower=0> tau0;                   // beta1 horseshoe global scale
  real<lower=0> xi0;                    // theta horseshoe global scale
}

parameters {
  // Horseshoe prior for beta 1
  vector[P] beta1;
  vector<lower=0>[P] lambda;
  real<lower=0> tau;

  // Horseshoe prior for variances theta: diag(Q)
  vector<lower=0>[P] theta;
  vector<lower=0>[P] kappa;
  real<lower=0> xi;

  // Non-centered state shocks
  matrix[T-1, P] z;                     // z ~ N(0,1)
}

transformed parameters {
  matrix[T, P] beta;                    // time-varying coefficients

  beta[1] = beta1';
  for (t in 2:T) {
    for (p in 1:P) {
      beta[t, p] = beta[t-1, p] + sqrt(theta[p]) * z[t-1, p];
    }
  }
}

model {
  //---------------- Horseshoe prior ---------------------
  
  // Horseshoe beta1
  lambda ~ cauchy(0, 1);
  tau    ~ cauchy(0, tau0);
  beta1  ~ normal(0, tau .* lambda);

  // Horseshoe for theta
  kappa  ~ cauchy(0, 1);
  xi     ~ cauchy(0, xi0);
  theta  ~ normal(0, xi .* kappa);   // truncated by lower=0 constraint

  // Non-centered State shocks
  to_vector(z) ~ normal(0, 1);

  // -------------- Likelihood (logit) ------------------
  for (n in 1:N) {
    y[n] ~ bernoulli_logit(dot_product(X[n], beta[tt[n]]'));
  }
}