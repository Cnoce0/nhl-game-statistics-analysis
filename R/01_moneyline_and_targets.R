# Moneyline conversion and target construction.
# These functions take data frames as arguments so the script can be sourced
# without requiring the original datasets to already exist in the workspace.

# Convert American moneyline odds to implied win probability.
# Positive odds represent an underdog; negative odds represent a favorite.
convert_moneyline <- function(odds) {
  ifelse(
    is.na(odds),
    NA_real_,
    ifelse(
      odds == 0,
      0.5,
      ifelse(odds > 0, 100 / (odds + 100), -odds / (-odds + 100))
    )
  )
}

# Add the home-win target and implied probability to the sportsbook data.
# Expected columns: h__goals_total, a__goals_total, moneyline.
add_sportsbook_targets <- function(sportsbook_data) {
  required_columns <- c("h__goals_total", "a__goals_total", "moneyline")
  missing_columns <- setdiff(required_columns, names(sportsbook_data))

  if (length(missing_columns) > 0) {
    stop(
      "sportsbook_data is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  dplyr::mutate(
    sportsbook_data,
    HomeWin = as.integer(h__goals_total > a__goals_total),
    implied_prob = convert_moneyline(moneyline)
  )
}

# Add a binary indicator for whether total goals exceed the sportsbook line.
# Expected columns: total_goals, over_under.
add_over_under_target <- function(games_data) {
  required_columns <- c("total_goals", "over_under")
  missing_columns <- setdiff(required_columns, names(games_data))

  if (length(missing_columns) > 0) {
    stop(
      "games_data is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  dplyr::mutate(
    games_data,
    over_under_hit = as.integer(total_goals > over_under)
  )
}

# Example usage after you load the corresponding datasets:
# sportsbook_nhl_2021_2022 <- add_sportsbook_targets(sportsbook_nhl_2021_2022)
# games_with_all_stats <- add_over_under_target(games_with_all_stats)
