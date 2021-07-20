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
}
model {
  //use recommended students t prior for fixed effects model, weakly informative
  alpha  ~ student_t(3,0,1);
  b_Run_time  ~ student_t(3,0,1);
  b_IMDb_Rating  ~ student_t(3,0,1);
  b_Age  ~ student_t(3,0,1);
  b_has_star  ~ student_t(3,0,1);
  b_is_eng_lang  ~ student_t(3,0,1);
  b_moviemeter ~ student_t(3,0,1);
  
  //likelihood
    y ~ bernoulli_logit(alpha[genre] + b_Run_time[genre].* Run_time + b_IMDb_Rating[genre].* IMDb_Rating + b_Age[genre].* Age + b_has_star[genre].* has_star + b_is_eng_lang[genre].* is_eng_lang + b_moviemeter[genre].* moviemeter);
}
generated quantities{
  real y_pred[N_new];
  
    y_pred = bernoulli_logit_rng(alpha[genre_test] +  b_Run_time[genre_test].* Run_time_new + b_IMDb_Rating[genre_test].* IMDb_Rating_new + b_Age[genre_test].* Age_new + b_has_star[genre_test].* has_star_new + b_is_eng_lang[genre_test].* is_eng_lang_new + b_moviemeter[genre_test].* moviemeter_new);
} 