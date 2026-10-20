# Cumulative features grouped by the home and away teams.
# The lag ensures the feature for a game only contains information from
# earlier rows for that team, not the current game's result.
#
# IMPORTANT: the original snippet uses generic columns such as
# shotsOnGoalFor, hitsFor, and faceOffsWonFor for both grouping passes.
# Confirm that these columns represent the expected team's statistics in
# your merged dataset before using these features for modeling.

add_cumulative_game_features <- function(sportsbook_with_stats) {
  required_columns <- c(
    "h__team", "a__team", "date", "h__goals_total", "a__goals_total",
    "shotsOnGoalFor", "shotsOnGoalAgainst", "faceOffsWonFor",
    "faceOffsWonAgainst", "hitsFor", "hitsAgainst",
    "lowDangerShotsFor", "mediumDangerShotsFor", "highDangerShotsFor",
    "lowDangerShotsAgainst", "mediumDangerShotsAgainst", "highDangerShotsAgainst",
    "penaltiesFor", "penaltiesAgainst", "reboundsFor", "reboundsAgainst",
    "playStoppedFor", "playStoppedAgainst"
  )
  missing_columns <- setdiff(required_columns, names(sportsbook_with_stats))

  if (length(missing_columns) > 0) {
    stop(
      "sportsbook_with_stats is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  stat_columns <- c(
    "h__goals_total", "a__goals_total",
    "shotsOnGoalFor", "shotsOnGoalAgainst",
    "faceOffsWonFor", "faceOffsWonAgainst", "hitsFor", "hitsAgainst",
    "lowDangerShotsFor", "mediumDangerShotsFor", "highDangerShotsFor",
    "lowDangerShotsAgainst", "mediumDangerShotsAgainst", "highDangerShotsAgainst",
    "penaltiesFor", "penaltiesAgainst", "reboundsFor", "reboundsAgainst",
    "playStoppedFor", "playStoppedAgainst"
  )

  result <- sportsbook_with_stats %>%
    arrange(h__team, date) %>%
    group_by(h__team) %>%
    mutate(
      across(
        all_of(stat_columns),
        ~ dplyr::lag(cumsum(.x), default = 0),
        .names = "cum_home_{.col}_before"
      )
    ) %>%
    ungroup() %>%
    arrange(a__team, date) %>%
    group_by(a__team) %>%
    mutate(
      across(
        all_of(stat_columns),
        ~ dplyr::lag(cumsum(.x), default = 0),
        .names = "cum_away_{.col}_before"
      )
    ) %>%
    ungroup()

  result
}

# Example usage after sportsbook_with_stats has been created and merged:
# sportsbook_with_stats <- add_cumulative_game_features(sportsbook_with_stats)
