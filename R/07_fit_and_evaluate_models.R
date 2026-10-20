# Compare a constant-goals baseline with linear and Poisson regressions.
# All models use the exact same chronological held-out observations.
fit_and_evaluate_models <- function(nhl_model_data, train_fraction = 0.8) {
  if (nrow(nhl_model_data) < 20L) stop("Not enough observations for a meaningful split.")
  df <- dplyr::arrange(nhl_model_data, date, team)
  dates <- sort(unique(df$date))
  if (length(dates) < 2L) stop("Need multiple dates for a chronological split.")
  # Split on unique dates to keep observations on the same date together.
  boundary <- dates[max(1L, min(length(dates) - 1L, floor(length(dates) * train_fraction)))]
  train_data <- df[df$date <= boundary, , drop = FALSE]
  test_data <- df[df$date > boundary, , drop = FALSE]
  f <- goalsFor ~ previous_goals_avg + previous_goals_allowed_avg + previous_shots_avg
  linear_model <- stats::lm(f, data = train_data)
  poisson_model <- stats::glm(f, data = train_data, family = stats::poisson())
  actual <- test_data$goalsFor
  baseline <- rep(mean(train_data$goalsFor), nrow(test_data))
  linear_predictions <- as.numeric(stats::predict(linear_model, newdata = test_data))
  poisson_predictions <- as.numeric(stats::predict(poisson_model, newdata = test_data, type = "response"))
  mae <- function(x) mean(abs(actual - x))
  metrics <- data.frame(
    Model = c("Constant mean baseline", "Linear regression", "Poisson regression"),
    Test_MAE = c(mae(baseline), mae(linear_predictions), mae(poisson_predictions))
  )
  list(metrics = metrics, linear_model = linear_model, poisson_model = poisson_model,
       train_data = train_data, test_data = test_data, split_date = boundary,
       predictions = data.frame(date = test_data$date, team = test_data$team,
         actual_goals = actual, baseline = baseline,
         linear = linear_predictions, poisson = poisson_predictions))
}
