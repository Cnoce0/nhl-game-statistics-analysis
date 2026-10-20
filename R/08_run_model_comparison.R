# Run from the repository root after placing Stats2work.RData in data/raw/.
# This workflow starts from the workspace's team_game_stats object.
source("R/00_packages.R")
source("R/00_load_workspace.R")
source("R/06_prepare_historical_features.R")
source("R/07_fit_and_evaluate_models.R")
nhl_model_data <- prepare_historical_features(team_game_stats)
results <- fit_and_evaluate_models(nhl_model_data)
print(results$metrics)
message("Chronological cutoff date: ", results$split_date)
# Outputs stored locally under outputs/ (ignored by Git).
dir.create("outputs", showWarnings = FALSE)
utils::write.csv(results$metrics, "outputs/model_comparison.csv", row.names = FALSE)
utils::write.csv(results$predictions, "outputs/model_predictions.csv", row.names = FALSE)
