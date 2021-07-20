data {
  //predictors include interaction effects also this time
  int<lower=0> N;
  vector[N] Run_time;
  vector[N] IMDb_Rating;
  vector[N] Age;
  vector[N] has_star;
  vector[N] is_eng_lang;
  vector[N] moviemeter;
  vector[N] age_runtime;
  vector[N] is_eng_lang_age;
  vector[N] age_has_star;
  int<lower=0,upper=1> y[N]; //binary dependent variable
  
  int<lower=0> N_new; //test set predictions to evaluate model
  vector[N_new] Run_time_new;
  vector[N_new] IMDb_Rating_new;
  vector[N_new] Age_new;
  vector[N_new] has_star_new;
  vector[N_new] is_eng_lang_new;
  vector[N_new] moviemeter_new;
  vector[N_new] age_runtime_new;
  vector[N_new] is_eng_lang_age_new;
  vector[N_new] age_has_star_new;
}
parameters {
  real alpha;
  real b_Run_time;
  real b_IMDb_Rating;
  real b_Age;
  real b_has_star;
  real b_is_eng_lang;
  real b_age_runtime;
  real b_moviemeter;
  real b_is_eng_lang_age;
  real b_age_has_star;
}
model {
  //implicit flat stan improper priors used here, converges fine, weakly informative again 
  y ~ bernoulli_logit(alpha +  b_Run_time * Run_time + b_IMDb_Rating * IMDb_Rating + b_Age * Age + b_has_star * has_star + b_is_eng_lang * is_eng_lang + b_moviemeter * moviemeter + b_age_runtime * age_runtime + b_is_eng_lang_age * is_eng_lang_age + b_age_has_star * age_has_star); 
}
generated quantities{
  real y_pred[N_new];
  
  y_pred = bernoulli_logit_rng(alpha +  b_Run_time * Run_time_new + b_IMDb_Rating * IMDb_Rating_new + b_Age * Age_new + b_has_star * has_star_new + b_is_eng_lang * is_eng_lang_new + b_moviemeter * moviemeter_new + b_age_runtime * age_runtime_new + b_is_eng_lang_age * is_eng_lang_age_new + b_age_has_star* age_has_star_new);
}
