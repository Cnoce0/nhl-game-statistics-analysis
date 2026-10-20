# Team points over time and rolling performance summaries.

# Reshape game-level rows into one row per team per game and calculate
# cumulative standings points. Tied final scores are retained as a placeholder
# from the original analysis; verify how overtime/shootout outcomes are encoded.
make_team_points_over_time <- function(sportsbook_with_stats) {
  required_columns <- c("date", "h__team", "a__team", "h__goals_total", "a__goals_total")
  missing_columns <- setdiff(required_columns, names(sportsbook_with_stats))

  if (length(missing_columns) > 0) {
    stop(
      "sportsbook_with_stats is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  team_points_over_time <- sportsbook_with_stats %>%
    transmute(
      date,
      team = h__team,
      opponent = a__team,
      goals_for = h__goals_total,
      goals_against = a__goals_total,
      is_home = TRUE
    ) %>%
    bind_rows(
      sportsbook_with_stats %>%
        transmute(
          date,
          team = a__team,
          opponent = h__team,
          goals_for = a__goals_total,
          goals_against = h__goals_total,
          is_home = FALSE
        )
    ) %>%
    arrange(team, date) %>%
    group_by(team) %>%
    mutate(
      result = case_when(
        goals_for > goals_against ~ "win",
        goals_for == goals_against ~ "OTL_placeholder",
        TRUE ~ "loss"
      ),
      points = case_when(
        result == "win" ~ 2,
        result == "OTL_placeholder" ~ 1,
        TRUE ~ 0
      ),
      cum_points_before_game = dplyr::lag(cumsum(points), default = 0),
      cum_points = cumsum(points)
    ) %>%
    ungroup()

  team_points_over_time
}

# Optional helper corresponding to the original join. This expects team_game_stats
# to contain team, date, and cum_goals columns.
join_cumulative_goals <- function(team_points_over_time, team_game_stats) {
  required_columns <- c("team", "date", "cum_goals")
  missing_columns <- setdiff(required_columns, names(team_game_stats))

  if (length(missing_columns) > 0) {
    stop(
      "team_game_stats is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  dplyr::left_join(
    team_points_over_time,
    dplyr::select(team_game_stats, team, date, cum_goals),
    by = c("team", "date")
  )
}

# Add game points and 5-game rolling averages to team_game_stats.
# Rolling averages lag the current game so the current game's goals/points
# cannot leak into a feature used to predict that same game.
add_team_rolling_stats <- function(team_game_stats) {
  required_columns <- c("team", "date", "goalsFor", "goalsAgainst")
  missing_columns <- setdiff(required_columns, names(team_game_stats))

  if (length(missing_columns) > 0) {
    stop(
      "team_game_stats is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  team_game_stats %>%
    mutate(
      points = case_when(
        goalsFor > goalsAgainst ~ 2,
        goalsFor == goalsAgainst ~ 1, # Verify whether ties represent final scores.
        goalsFor < goalsAgainst ~ 0
      )
    ) %>%
    arrange(team, date) %>%
    group_by(team) %>%
    mutate(
      rolling_goals_avg = slider::slide_dbl(
        dplyr::lag(goalsFor),
        mean,
        .before = 4,
        .complete = TRUE
      ),
      rolling_points_avg = slider::slide_dbl(
        dplyr::lag(points),
        mean,
        .before = 4,
        .complete = TRUE
      )
    ) %>%
    ungroup()
}

# Example usage:
# team_points_over_time <- make_team_points_over_time(sportsbook_with_stats)
# team_points_goals <- join_cumulative_goals(team_points_over_time, team_game_stats)
# team_rolling_stats <- add_team_rolling_stats(team_game_stats)
