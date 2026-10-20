# Create pre-game team features from team_game_stats.
# Requires one row per team-game; verify team/date alignment before interpreting.
prepare_historical_features <- function(team_game_stats, min_previous_games = 5) {
  required <- c("team", "date", "goalsFor", "goalsAgainst", "shotsOnGoalFor")
  missing <- setdiff(required, names(team_game_stats))
  if (length(missing)) stop("Missing columns: ", paste(missing, collapse = ", "))
  d <- team_game_stats
  d$date <- as.Date(d$date)
  if (anyNA(d$date)) stop("Could not convert every date to Date.")
  if (anyDuplicated(d[c("team", "date")])) {
    stop("Duplicate team/date rows: verify game IDs and ordering before computing lags.")
  }
  # Filter incomplete *source* rows before cumulative means; the current game's
  # measurements are not used as predictors, because we lag the cumulative mean.
  d <- dplyr::arrange(d, team, date)
  d <- dplyr::group_by(d, team)
  d <- dplyr::mutate(d,
    previous_goals_avg = dplyr::lag(cummean(goalsFor)),
    previous_goals_allowed_avg = dplyr::lag(cummean(goalsAgainst)),
    previous_shots_avg = dplyr::lag(cummean(shotsOnGoalFor)),
    previous_games = dplyr::row_number() - 1L
  )
  d <- dplyr::ungroup(d)
  d <- dplyr::filter(d, previous_games >= min_previous_games,
    !is.na(goalsFor), !is.na(previous_goals_avg),
    !is.na(previous_goals_allowed_avg), !is.na(previous_shots_avg))
  dplyr::arrange(d, date, team)
}
