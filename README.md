# NHL Game Statistics & Predictive Modeling

An R-based sports analytics project exploring NHL game statistics, team performance, and predictive models for goals and game outcomes.

The original analysis focused on NHL games from the 2021–2022 season and explored three main questions:

- Can game and team statistics help model goals scored?
- How can cumulative team performance be tracked through a season?
- Can game statistics be used to classify whether the total goals exceed the sportsbook over/under line?

## Tools

- R
- `dplyr` for data manipulation
- `readr` for importing CSV files
- `slider` for rolling-window summaries
- Generalized linear models (`glm`) for logistic regression

## Repository Structure

```text
nhl-game-statistics-analysis/
├── README.md
├── .gitignore
├── R/
│   ├── 00_packages.R
│   ├── 01_moneyline_and_targets.R
│   ├── 02_load_team_stats.R
│   ├── 03_cumulative_features.R
│   ├── 04_team_points_and_rolling_stats.R
│   └── 05_home_win_model.R
├── data/
│   └── raw/
│       ├── README.md
│       └── team_Stats/
├── figures/
└── reports/
```

## Getting Started

1. Install R and an editor such as RStudio.
2. Install the packages listed in `R/00_packages.R`.
3. Put the team statistics CSV files in `data/raw/team_Stats/`. The original import code assumes one CSV per team, with the team abbreviation in the filename, such as `BOS.csv`.
4. Obtain and load the sportsbook/game-level data used in the original analysis. The uploaded code snippet does not include the original data download, all joining steps, or the creation of every intermediate data frame.
5. Run the scripts in order after supplying the input data objects described in each script. Some scripts define functions rather than running transformations immediately.

The scripts use paths relative to the repository root. In RStudio, open the project from the repository root before running them.

## Script Guide

| Script | Purpose |
|---|---|
| `00_packages.R` | Load required R packages. |
| `01_moneyline_and_targets.R` | Convert American moneylines to implied probabilities and create outcome labels. |
| `02_load_team_stats.R` | Import and combine per-team CSV files; optionally filter to the `all` situation. |
| `03_cumulative_features.R` | Build cumulative game-stat features grouped by home and away team. |
| `04_team_points_and_rolling_stats.R` | Build team-level points trends and rolling averages. |
| `05_home_win_model.R` | Fit the supplied logistic regression for the home-win outcome. |

## Important Modeling Notes

- **Feature timing matters.** A model predicting a game must only use information available before that game. The cumulative and rolling features in this version are shifted to exclude the current game's result where they are intended as pre-game features.
- **Verify the data schema.** The provided snippet uses generic columns such as `shotsOnGoalFor` alongside home/away team identifiers. Confirm that these columns represent the intended team's statistics before relying on the resulting home- and away-grouped features.
- **NHL points logic is approximate.** The source snippet treats tied scores as an overtime-loss placeholder. A final game score alone cannot establish which team earned an overtime/shootout point unless the data includes enough information about the actual result.
- **The home-win model is exploratory.** The snippet does not include a train/test split or out-of-sample evaluation. Do not describe its training fit as test accuracy.
- The original write-up reported an approximately 0.81 mean absolute error for the Poisson model, approximately 0.95 residual standard error for the linear model, and approximately 84% over/under classification accuracy on a training sample. These were historical results from the original course analysis and have not been reproduced by the reorganized scripts. The over/under model's complete formula was not included in the code provided here.

## Data & Reproducibility

Raw datasets are not included. See `data/raw/README.md` before adding data files. Include source attribution and check each source's redistribution terms. Do not commit data files that you are not authorized to redistribute.

## Disclaimer

This is an academic sports analytics project. It is exploratory analysis, not betting advice or evidence of a profitable betting strategy.

## Loading the original saved workspace

The original project used an RStudio workspace snapshot (`Stats2work.RData`) containing objects such as `sportsbook_with_stats`, `team_game_stats`, `team_rolling_stats`, `sportsbook_nhl_2021_2022`, `games_with_all_stats`, and `team_stats_all`. These names were detected in the uploaded serialized workspace, but their structure and contents have not yet been validated.

Copy the workspace file to `data/raw/Stats2work.RData`, open R from the repository root, and run `source("R/00_load_workspace.R")`. The workspace is intentionally excluded from Git. Some analysis scripts may still need adjustment to the saved column schemas and object dependencies.

## Historical-feature model comparison (updated analysis)

The original linear and Poisson model fits included same-game information (e.g., final goals, `HomeWin`, shots from the game being predicted), so their apparent fit is **not** a valid forecast evaluation. The original cumulative feature code can also suffer from timing or home/away alignment errors.

For an improved, deliberately simple comparison, `R/06_prepare_historical_features.R` constructs lagged team-level cumulative averages from `team_game_stats`, with five prior games required. `R/07_fit_and_evaluate_models.R` fits a constant-mean baseline, a linear model, and a Poisson model to an earlier chronological training period and evaluates MAE on later games. `R/08_run_model_comparison.R` runs this workflow using the locally saved workspace and writes output to the ignored `outputs/` folder.

```r
source("R/08_run_model_comparison.R")
```

The *previously observed*, row-split held-out results were baseline **1.435983**, linear **1.409095**, Poisson **1.408167** test MAE (goals). Their differences are small; the Poisson model was only marginally better. See `results/README.md` for the provenance and limitations. The updated date-based split may produce different metrics.

**Important validation:** the comparison requires `team_game_stats` to contain one correctly aligned row per team and game. Confirm that `goalsFor`, `goalsAgainst`, and `shotsOnGoalFor` are that team's completed-game values, not duplicated/opponent values; never use current-game information to forecast that game. Same-day duplicate team rows currently trigger an error until game IDs and ordering are addressed. The original data import/join code was not fully provided, and the raw workspace is not redistributed.

### Files added

| File | Role |
| --- | --- |
| `R/06_prepare_historical_features.R` | Lagged previous-game averages by team |
| `R/07_fit_and_evaluate_models.R` | Common train/test comparison and predictions |
| `R/08_run_model_comparison.R` | Run saved-data analysis, export local metrics |
| `results/README.md` | Report the validated-by-user run and caveats |
