# Logistic regression model for whether the home team wins.
# This follows the supplied model formula, with cleaner formula syntax.
# It is an exploratory model; this function does not perform a train/test split.

fit_home_win_model <- function(sportsbook_data) {
  required_columns <- c("HomeWin", "over_under", "FavoriteWinProb")
  missing_columns <- setdiff(required_columns, names(sportsbook_data))

  if (length(missing_columns) > 0) {
    stop(
      "sportsbook_data is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  stats::glm(
    HomeWin ~ over_under + FavoriteWinProb,
    data = sportsbook_data,
    family = stats::binomial()
  )
}

# Example usage after target and predictor columns are available:
# logit_model <- fit_home_win_model(sportsbook_nhl_2021_2022)
# summary(logit_model)
