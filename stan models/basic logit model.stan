data {
  //just three predictors used that were most significant
  int<lower=0> N;
  vector[N] IMDb_Rating;
  vector[N] has_star;
  vector[N] is_eng_lang;
  int<lower=0,upper=1> y[N]; //binary dependent variable
  
  int<lower=0> N_new; //test set predictions to evaluate model
  vector[N_new] IMDb_Rating_new;
  vector[N_new] has_star_new;
  vector[N_new] is_eng_lang_new;
}
parameters {
  real alpha;
  real b_IMDb_Rating;
  real b_has_star;
  real b_is_eng_lang;
}
model {
  //priors
  //unit information prior, weakly informative
  alpha ~ normal(0,1);
  b_IMDb_Rating ~ normal(0,1);
  b_has_star ~ normal(0,1);
  b_is_eng_lang ~ normal(0,1);
  //likelihood
  y ~ bernoulli_logit(alpha +  b_IMDb_Rating * IMDb_Rating + b_has_star * has_star + b_is_eng_lang * is_eng_lang); 
}
generated quantities{
  //test set predictions
  real y_pred[N_new];
  
  y_pred = bernoulli_logit_rng(alpha  + b_IMDb_Rating * IMDb_Rating_new +  b_has_star * has_star_new + b_is_eng_lang * is_eng_lang_new);
}