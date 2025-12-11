# GENERATE TOOLTIPS FOR DEMOGRAPHIC COMBINATIONS
# Uses 3-stage prompt chain to create human, conversational tooltips

source("./code/r/utils/helpers.R")
library(jsonlite)

cat("=== Generating Tooltips for Demographic Combinations ===\n\n")

# ==============================================================================
# LOAD COMBINATION DATA
# ==============================================================================

data_file <- "exercise/1/frontend/public/data/unemploymentCombinations.json"
if (!file.exists(data_file)) {
  stop("Data file not found. Run generate_combination_data.R first.")
}

cat("Loading combination data...\n")
json_data <- fromJSON(data_file, simplifyVector = FALSE)

# Convert to a more usable structure
combinations <- list()
for (combo_id in names(json_data$combinations)) {
  combo <- json_data$combinations[[combo_id]]
  combinations[[combo_id]] <- list(
    race = combo$race,
    gender = combo$gender,
    age = combo$age,
    education = combo$education,
    data = do.call(
      rbind,
      lapply(combo$data, function(x) {
        data.frame(
          date = as.Date(x$date),
          unemployment_rate = as.numeric(x$unemployment_rate)
        )
      })
    )
  )
}

cat(sprintf("Loaded %d combinations\n\n", length(combinations)))

# ==============================================================================
# DATA ANALYSIS HELPERS
# ==============================================================================

get_combination_stats <- function(combo_data) {
  # Pre-COVID baseline (2019 average)
  baseline_data <- combo_data[format(combo_data$date, "%Y") == "2019", ]
  baseline <- mean(baseline_data$unemployment_rate)

  # Peak unemployment
  peak_idx <- which.max(combo_data$unemployment_rate)
  peak_rate <- combo_data$unemployment_rate[peak_idx]
  peak_date <- format(combo_data$date[peak_idx], "%B %Y")

  # Current rate (December 2024)
  current_data <- combo_data[combo_data$date == as.Date("2024-12-01"), ]
  current_rate <- current_data$unemployment_rate

  list(
    baseline = round(baseline, 1),
    peak = round(peak_rate, 1),
    peak_date = peak_date,
    current = round(current_rate, 1)
  )
}

get_overall_stats <- function() {
  # Get "All Races|Men and Women|All ages|All levels of education" combination
  overall_id <- "All Races|Men and Women|All ages|All levels of education"
  if (!overall_id %in% names(combinations)) {
    # Fallback: average across all combinations
    all_rates <- do.call(rbind, lapply(combinations, function(c) c$data))
    baseline <- mean(all_rates[
      format(all_rates$date, "%Y") == "2019",
      "unemployment_rate"
    ])
    current <- mean(all_rates[
      all_rates$date == as.Date("2024-12-01"),
      "unemployment_rate"
    ])
    return(list(baseline = round(baseline, 1), current = round(current, 1)))
  }

  overall_data <- combinations[[overall_id]]$data
  baseline_data <- overall_data[format(overall_data$date, "%Y") == "2019", ]
  current_data <- overall_data[overall_data$date == as.Date("2024-12-01"), ]

  list(
    baseline = round(mean(baseline_data$unemployment_rate), 1),
    current = round(current_data$unemployment_rate, 1)
  )
}

# ==============================================================================
# PROMPT CHAIN FUNCTIONS
# ==============================================================================

stage1_data_context <- function(stats, combo_desc) {
  prompt <- sprintf(
    "
You are analyzing unemployment data for a specific demographic group.

Demographic: %s
Baseline rate (2019): %.1f%%
Peak unemployment: %.1f%% in %s
Current rate (Dec 2024): %.1f%%

Write ONE clear sentence stating the most important finding about this group's unemployment journey from 2019-2024.
Focus on the peak or the biggest change. Be specific with numbers.

Example: 'Black women aged 18-24 saw unemployment spike to 28.5%% in April 2020, nearly triple their pre-pandemic rate.'
",
    combo_desc,
    stats$baseline,
    stats$peak,
    stats$peak_date,
    stats$current
  )

  response <- query_ai(key, prompt)
  return(trimws(response))
}

stage2_comparison <- function(stats, overall_stats, stage1_output, combo_desc) {
  prompt <- sprintf(
    "
You are comparing a specific demographic group to the overall population.

Demographic: %s
Context: %s

Demographic current rate: %.1f%%
Overall population current rate: %.1f%%

Write ONE sentence comparing how this group's recovery compares to the overall population.
Be specific about whether they recovered faster/slower or are currently better/worse off.

Example: 'While overall unemployment returned to 4.5%% by 2024, this group remains at 7.2%% - showing a slower recovery.'
",
    combo_desc,
    stage1_output,
    stats$current,
    overall_stats$current
  )

  response <- query_ai(key, prompt)
  return(trimws(response))
}

stage3_human_tooltip <- function(stage1_output, stage2_output) {
  prompt <- sprintf(
    "
You are writing a tooltip for an interactive data visualization about unemployment.
The tooltip should be SHORT (1-2 sentences), CONVERSATIONAL, and EMPATHETIC.

Context from analysis:
%s

%s

Combine these insights into 1-2 conversational sentences that feel human and empathetic.
DO NOT use academic language. Write like you're explaining to a friend.
Be factual but warm in tone.

Good examples:
- 'Young workers aged 18-24 were hit hardest, with unemployment reaching 27%% in April 2020.'
- 'Black women in this age group saw unemployment triple during the pandemic, and their recovery has been slower than most.'

BAD examples (too academic):
- 'The data indicates a statistically significant disparity in unemployment rates.'
",
    stage1_output,
    stage2_output
  )

  response <- query_ai(key, prompt)
  return(trimws(response))
}

stage4_editorial_polish <- function(stage3_output, combo_desc) {
  prompt <- sprintf(
    "
You are a data journalism editor at a major publication like NYT or The Guardian.
Your job is to ensure tooltips are CLEAR, CONCISE, and meet editorial standards.

Demographic: %s
Draft tooltip: %s

Edit this tooltip following these strict rules:
1. Maximum 2 sentences (ideally 1 sentence if possible)
2. Lead with the most newsworthy fact
3. Use active voice
4. Avoid jargon and technical terms
5. Numbers must be precise and accurate
6. No unnecessary adjectives
7. Clear, direct language - every word must earn its place
8. No editorializing - stick to facts

Return ONLY the edited tooltip text, nothing else.

Good example:
Before: 'Black women in this age group experienced a really significant increase in unemployment during the pandemic period.'
After: 'Black women aged 16-24 saw unemployment spike to 28.5%% in April 2020, triple their pre-pandemic rate.'
",
    combo_desc,
    stage3_output
  )

  response <- query_ai(key, prompt)
  return(trimws(response))
}

generate_tooltip_for_combination <- function(combo_id) {
  combo <- combinations[[combo_id]]

  # Create human-readable description
  combo_desc <- sprintf(
    "%s %s aged %s with %s",
    combo$race,
    combo$gender,
    combo$age,
    combo$education
  )

  # Get stats
  stats <- get_combination_stats(combo$data)
  overall_stats <- get_overall_stats()

  # 4-stage prompt chain
  stage1 <- stage1_data_context(stats, combo_desc)
  Sys.sleep(1) # Rate limit

  stage2 <- stage2_comparison(stats, overall_stats, stage1, combo_desc)
  Sys.sleep(1) # Rate limit

  stage3 <- stage3_human_tooltip(stage1, stage2)
  Sys.sleep(1) # Rate limit

  tooltip <- stage4_editorial_polish(stage3, combo_desc)

  return(tooltip)
}

# ==============================================================================
# SELECT KEY COMBINATIONS TO GENERATE
# ==============================================================================

# Rather than generate all 240 (expensive!), select ~30 key combinations
# that tell important stories

key_scenarios <- list(
  # Overall baseline
  "All Races|Men and Women|All ages|All levels of education",

  # Young workers (hit hardest)
  "All Races|Men and Women|16-24|All levels of education",
  "Black|Men and Women|16-24|All levels of education",
  "Hispanic|Men and Women|16-24|All levels of education",
  "White|Men and Women|16-24|All levels of education",

  # Black workers (various intersections)
  "Black|Women|All ages|All levels of education",
  "Black|Men|All ages|All levels of education",
  "Black|Women|16-24|All levels of education",
  "Black|Women|25-44|All levels of education",
  "Black|Women|16-24|College graduate",
  "Black|Women|16-24|Not high school grad",

  # Hispanic workers
  "Hispanic|Women|All ages|All levels of education",
  "Hispanic|Men|All ages|All levels of education",
  "Hispanic|Women|16-24|All levels of education",
  "Hispanic|Women|25-44|Not high school grad",

  # White workers for comparison
  "White|Men|All ages|College graduate",
  "White|Women|All ages|College graduate",
  "White|Men|45 and older|College graduate",

  # Education disparities
  "All Races|Men and Women|All ages|Not high school grad",
  "All Races|Men and Women|All ages|College graduate",
  "Black|Men and Women|All ages|Not high school grad",
  "Hispanic|Men and Women|All ages|Not high school grad",

  # Older workers
  "All Races|Men and Women|45 and older|All levels of education",
  "Black|Men and Women|45 and older|All levels of education",

  # Gender comparisons
  "All Races|Women|All ages|All levels of education",
  "All Races|Men|All ages|All levels of education",
  "Black|Women|25-44|College graduate",
  "White|Women|25-44|College graduate",

  # Intersectional stories
  "Black|Women|16-24|High school graduate",
  "Hispanic|Women|25-44|High school graduate"
)

# Filter to only combinations that exist
key_scenarios <- key_scenarios[key_scenarios %in% names(combinations)]

cat(sprintf(
  "Selected %d key combinations to generate tooltips\n\n",
  length(key_scenarios)
))

# ==============================================================================
# GENERATE TOOLTIPS
# ==============================================================================

cat("Generating tooltips...\n\n")

tooltips <- list()
counter <- 0

for (combo_id in key_scenarios) {
  counter <- counter + 1
  combo <- combinations[[combo_id]]

  combo_desc <- sprintf(
    "%s %s aged %s with %s",
    combo$race,
    combo$gender,
    combo$age,
    combo$education
  )

  cat(sprintf("[%d/%d] %s\n", counter, length(key_scenarios), combo_desc))

  tryCatch(
    {
      tooltip <- generate_tooltip_for_combination(combo_id)
      tooltips[[combo_id]] <- tooltip
      cat(sprintf("  ✓ %s\n\n", tooltip))

      # Longer pause to avoid rate limits
      if (counter < length(key_scenarios)) {
        Sys.sleep(2)
      }
    },
    error = function(e) {
      cat(sprintf("  ✗ Error: %s\n\n", e$message))
      tooltips[[combo_id]] <- "Tooltip not generated due to budget constraints 💸"
    }
  )
}

# ==============================================================================
# EXPORT TO JSON
# ==============================================================================

cat("\n=== Exporting Tooltips ===\n")

# Save generated tooltips to _tooltips.json (hidden by default)
generated_file <- "exercise/1/frontend/public/_tooltips.json"
json_output <- toJSON(tooltips, pretty = TRUE, auto_unbox = TRUE)
write(json_output, generated_file)
cat(sprintf("✓ Saved %d tooltips to: %s\n", length(tooltips), generated_file))

# Create empty tooltips.json (shows fallback message for all combinations)
empty_file <- "exercise/1/frontend/public/tooltips.json"
write("{}", empty_file)
cat(sprintf("✓ Created empty: %s\n\n", empty_file))

cat("=== Generation Complete ===\n")
cat(sprintf("Generated tooltips for %d key combinations.\n", length(tooltips)))
cat("\nFor your live demo:\n")
cat("  - Default: tooltips.json (empty) → shows '💸' fallback message\n")
cat("  - To enable AI tooltips: rename _tooltips.json → tooltips.json\n")
cat("  - To disable again: rename tooltips.json → _tooltips.json\n\n")
