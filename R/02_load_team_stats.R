# Import one CSV per team and combine them into a single data frame.
# Expected layout: data/raw/team_Stats/BOS.csv, data/raw/team_Stats/TBL.csv, etc.

load_team_stats <- function(
  team_stats_dir = file.path("data", "raw", "team_Stats"),
  situation_filter = "all"
) {
  if (!dir.exists(team_stats_dir)) {
    stop("Team stats directory does not exist: ", team_stats_dir, call. = FALSE)
  }

  team_files <- list.files(
    team_stats_dir,
    pattern = "\\.csv$",
    full.names = TRUE,
    ignore.case = TRUE
  )

  if (length(team_files) == 0) {
    stop(
      "No CSV files found in ", team_stats_dir,
      ". Add one team-statistics CSV per team first.",
      call. = FALSE
    )
  }

  team_list <- Map(function(file, team) {
    team_data <- readr::read_csv(file, show_col_types = FALSE)
    dplyr::mutate(team_data, team = team)
  }, team_files, tools::file_path_sans_ext(basename(team_files)))

  team_stats_all <- dplyr::bind_rows(team_list)

  if (!is.null(situation_filter)) {
    if (!"situation" %in% names(team_stats_all)) {
      warning(
        "No 'situation' column was found; returning all rows without filtering.",
        call. = FALSE
      )
    } else {
      team_stats_all <- dplyr::filter(
        team_stats_all,
        .data$situation == situation_filter
      )
    }
  }

  team_stats_all
}

# Example usage:
# team_stats_all <- load_team_stats()
# dplyr::count(team_stats_all, situation)
