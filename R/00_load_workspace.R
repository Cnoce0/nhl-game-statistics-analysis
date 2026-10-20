# Load saved objects from the original RStudio project.
# Keep Stats2work.RData locally in data/raw/ (not committed to GitHub).
workspace_path <- file.path("data", "raw", "Stats2work.RData")
if (!file.exists(workspace_path)) {
  stop("Missing data/raw/Stats2work.RData. Obtain the original workspace file locally.")
}
loaded_objects <- load(workspace_path)
message("Loaded objects: ", paste(loaded_objects, collapse = ", "))
required <- c("sportsbook_nhl_2021_2022", "sportsbook_with_stats", "team_game_stats")
missing <- setdiff(required, loaded_objects)
if (length(missing)) warning("Expected objects not in workspace: ", paste(missing, collapse = ", "))
