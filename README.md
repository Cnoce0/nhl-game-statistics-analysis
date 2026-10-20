# NHL Game Statistics & Predictive Modeling

An R-based sports analytics project exploring NHL game statistics,
team performance, and statistical models for predicting goals and
classifying game totals.

The project uses NHL games from the 2021–2022 season, combining
game outcomes, sportsbook moneylines and over/under totals with
team-level performance statistics.

## Project Objectives

The goal was to investigate whether team statistics and performance
trends could help explain or predict NHL game outcomes.

The main questions were:

- Can team statistics predict the number of goals scored in a game?
- How do linear regression and Poisson regression compare when
  modeling goal counts?
- Can logistic regression classify whether a game's total goals
  finish above or below the sportsbook over/under line?
- Do cumulative team statistics provide useful information about
  performance throughout a season?

## Tools & Technologies

- R
- Data cleaning and feature engineering
- Linear regression
- Poisson regression
- Logistic regression
- Exploratory data analysis and visualization

## Project Workflow

### 1. Data Preparation

Combined game-level odds and outcomes with team statistics and
expected performance metrics. Prepared variables for analysis and
converted moneyline odds into implied win probabilities.

### 2. Feature Engineering

Created additional features, including cumulative team statistics
and performance measures tracked across the season. Constructed a
binary target indicating whether a game's total goals exceeded
the over/under line.

### 3. Exploratory Analysis

Examined relationships among team statistics, scoring, and
season-long performance. Used visualizations to explore trends in
goals and cumulative team points.

### 4. Predictive Modeling

Developed and compared models for different prediction tasks:

- Linear regression for goals scored
- Poisson regression for goals scored
- Logistic regression for over/under classification

## Results Reported in the Original Analysis

The original course write-up reported the following results:

- Poisson regression: approximately 0.81 mean absolute error.
- Linear regression: approximately 0.95 residual standard error.
- Over/under logistic regression: approximately 84% classification
  accuracy at a 0.50 probability threshold on a training sample
  of roughly 500 games.

These metrics come from the original exploratory project and have
not been independently revalidated. The goal-model metrics are
different measures and should not be compared directly.

The reported classification accuracy was calculated on training
data, so it should not be interpreted as evidence of performance
on unseen games.

## Limitations & Future Improvements

- Evaluate models on a properly held-out test set.
- Ensure all predictive features use information available before
  the game being predicted to prevent data leakage.
- Investigate rolling averages and recent team performance.
- Explore additional NHL seasons to test whether results generalize.
- Compare models using consistent evaluation metrics.
- Improve documentation of data sources and reproducibility.

## Data

The original analysis used NHL game and team-statistics datasets
collected from external sources.

The raw datasets are not included in this repository. Check the
original data sources' terms before redistributing any files, and
document the sources and preparation steps in `data/README.md`.

## Reproducibility

The analysis was developed in R. Place the required data files in
the appropriate local data directory and update any file paths in
the scripts before running the analysis.

The scripts and package requirements should be documented as the
original analysis is organized into a reproducible workflow.

## Disclaimer

This is an academic sports analytics project. The models are
exploratory and are not betting advice or evidence of a profitable
betting strategy.
