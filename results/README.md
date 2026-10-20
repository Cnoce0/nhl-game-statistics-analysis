# Recorded results from the original RStudio run

The user reported the following held-out MAE values from a chronological 80/20 **row-based** split of the previously saved `team_game_stats` workspace, with at least five earlier games per team:

| Method | Test MAE (goals) |
| --- | ---: |
| Constant training-mean baseline | 1.435983 |
| Linear regression | 1.409095 |
| Poisson regression | 1.408167 |

The Poisson model was marginally best (by ~0.001 MAE vs linear; ~0.028 vs baseline). These values should **not** be read as evidence of a major predictive gain, and the original in-sample scores from the course project were affected by outcome leakage.

The updated `R/08_run_model_comparison.R` uses a stricter **date-based** cutoff rather than a row index so the numerical results may differ. R is not available in the package-building environment and the revised workflow has not been independently executed. Verify unique team/date rows, pregame feature timing, and source data definitions before making stronger performance claims.
