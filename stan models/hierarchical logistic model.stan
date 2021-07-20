data {
  int<lower=0> N;
  int<lower=1> L;
  int<lower=1,upper=L> genre[N];
  vector[N] Run_time;
  vector[N] IMDb_Rating;
  vector[N] Age;
  vector[N] has_star;
  vector[N] is_eng_lang;
  vector[N] moviemeter;
  int<lower=0,upper=1> y[N];
  
  int<lower=0> N_new;
  int<lower=1,upper=L> genre_test[N_new];
  vector[N_new] Run_time_new;
  vector[N_new] IMDb_Rating_new;
  vector[N_new] Age_new;
  vector[N_new] has_star_new;
  vector[N_new] is_eng_lang_new;
  vector[N_new] moviemeter_new;
}
parameters {
  vector[L] alpha;
  vector[L] b_Run_time;
  vector[L] b_IMDb_Rating;
  vector[L] b_Age;
  vector[L] b_has_star;
  vector[L] b_is_eng_lang;
  vector[L] b_moviemeter;
  
  real mu_a;
  real<lower=0> si_a;
  real mu_b1;
  real<lower=0> si_b1;
  real mu_b2;
  real<lower=0> si_b2;
  real mu_b3;
  real<lower=0> si_b3;
  real mu_b4;
  real<lower=0> si_b4;
  real mu_b5;
  real<lower=0> si_b5;
  real mu_b6;
  real<lower=0> si_b6;
} 
model{
  //use hierarchical shrinkage for hierarchical model
  //weakly informative again
  alpha ~ normal(mu_a, si_a);
  mu_a ~ normal(0,10);
  si_a ~ cauchy(0,1);
  
  b_Run_time ~ normal(mu_b1, si_b1);
  mu_b1 ~ normal(0,10);
  si_b1 ~ cauchy(0,1);
  
  b_IMDb_Rating ~ normal(mu_b2, si_b2);
  mu_b2 ~ normal(0,10);
  si_b2 ~ cauchy(0,1);
  
  b_Age ~ normal(mu_b3, si_b3);
  mu_b3 ~ normal(0,10);
  si_b3 ~ cauchy(0,1);
  
  b_has_star ~ normal (mu_b4, si_b4);
  mu_b4 ~ normal(0,10);
  si_b4 ~ cauchy(0,1);
  
  b_is_eng_lang ~ normal(mu_b5, si_b5);
  mu_b5 ~ normal(0,10);
  si_b5 ~ cauchy(0,1);
  
  b_moviemeter~ normal(mu_b6, si_b6);
  mu_b6 ~ normal(0,10);
  si_b6 ~ cauchy(0,1);
  
  y ~ bernoulli_logit(alpha[genre] +  b_Run_time[genre].* Run_time + b_IMDb_Rating[genre].* IMDb_Rating + b_Age[genre].* Age + b_has_star[genre].* has_star + b_is_eng_lang[genre].* is_eng_lang + b_moviemeter[genre].* moviemeter);
}
generated quantities{
  real y_pred[N_new];
  
    y_pred = bernoulli_logit_rng(alpha[genre_test] +  b_Run_time[genre_test].* Run_time_new + b_IMDb_Rating[genre_test].* IMDb_Rating_new + b_Age[genre_test].* Age_new + b_has_star[genre_test].* has_star_new + b_is_eng_lang[genre_test].* is_eng_lang_new + b_moviemeter[genre_test].* moviemeter_new);
}