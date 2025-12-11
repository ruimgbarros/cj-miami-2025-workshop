# GENERATE ALL DEMOGRAPHIC COMBINATION DATA
# Creates unemployment data for all race×gender×age×education combinations

library(jsonlite)

cat("=== Generating All Demographic Combinations ===\n\n")

# ==============================================================================
# DEFINE CATEGORIES
# ==============================================================================

races <- c("All Races", "White", "Black", "Hispanic", "All other races")
genders <- c("Men and Women", "Men", "Women")
ages <- c("All ages", "16-24", "25-44", "45 and older")
education <- c(
  "All levels of education",
  "Not high school grad",
  "High school graduate",
  "College graduate"
)

# Generate monthly data from 2019-2024
months <- seq(as.Date("2019-01-01"), as.Date("2024-12-01"), by = "month")

total_combinations <- length(races) * length(genders) * length(ages) * length(education)
cat(sprintf("Total combinations: %d\n", total_combinations))
cat(sprintf("  Race: %d groups\n", length(races)))
cat(sprintf("  Gender: %d groups\n", length(genders)))
cat(sprintf("  Age: %d groups\n", length(ages)))
cat(sprintf("  Education: %d groups\n", length(education)))
cat(sprintf("  Time points: %d months\n\n", length(months)))

# ==============================================================================
# BASELINE RATES BY DEMOGRAPHIC
# ==============================================================================

get_baseline_rate <- function(race, gender, age, edu) {
  # Base rate starts at 4.5%
  base <- 4.5

  # Race adjustments
  if (race == "White") base <- base - 1.0
  if (race == "Black") base <- base + 2.0
  if (race == "Hispanic") base <- base + 0.3
  if (race == "All other races") base <- base - 0.7

  # Gender adjustments
  if (gender == "Women") base <- base + 0.2
  if (gender == "Men") base <- base - 0.2

  # Age adjustments
  if (age == "16-24") base <- base + 4.0
  if (age == "25-44") base <- base - 0.7
  if (age == "45 and older") base <- base - 1.3

  # Education adjustments
  if (edu == "Not high school grad") base <- base + 2.3
  if (edu == "High school graduate") base <- base + 0.0
  if (edu == "College graduate") base <- base - 2.0

  return(max(base, 2.0))  # Floor at 2%
}

get_covid_peak_rate <- function(baseline) {
  # COVID peak is roughly 2.5-3x baseline, with some variation
  peak <- baseline * 2.8 + rnorm(1, 0, 0.5)
  return(max(peak, baseline * 1.5))  # At least 1.5x baseline
}

# ==============================================================================
# GENERATE TIME SERIES FOR ONE COMBINATION
# ==============================================================================

generate_combination_series <- function(race, gender, age, edu, months) {
  baseline <- get_baseline_rate(race, gender, age, edu)
  covid_peak <- get_covid_peak_rate(baseline)

  rates <- numeric(length(months))

  for (i in seq_along(months)) {
    month_date <- months[i]
    year <- as.numeric(format(month_date, "%Y"))
    month <- as.numeric(format(month_date, "%m"))

    if (year == 2019) {
      # Pre-COVID baseline
      rates[i] <- baseline + rnorm(1, 0, 0.2)

    } else if (year == 2020 && month >= 3) {
      # COVID spike
      if (month == 4) {
        rates[i] <- covid_peak
      } else if (month == 3) {
        # March 2020 - beginning of spike
        rates[i] <- baseline + (covid_peak - baseline) * 0.3
      } else {
        # Recovery begins after April
        decline_factor <- (month - 4) / 8
        rates[i] <- covid_peak - (covid_peak - baseline * 1.5) * decline_factor
      }

    } else if (year >= 2021) {
      # Gradual recovery to new normal (slightly above baseline)
      months_since_2021 <- (year - 2021) * 12 + month
      recovery_progress <- min(months_since_2021 / 36, 1)  # 3-year recovery
      recovery_rate <- baseline * 1.3 - (recovery_progress * baseline * 0.3)
      rates[i] <- recovery_rate + rnorm(1, 0, 0.3)
    }

    rates[i] <- max(rates[i], 2.0)  # Floor at 2%
  }

  return(rates)
}

# ==============================================================================
# GENERATE ALL COMBINATIONS
# ==============================================================================

cat("Generating data for all combinations...\n\n")

combinations <- list()
counter <- 0

for (race in races) {
  for (gender in genders) {
    for (age in ages) {
      for (edu in education) {
        counter <- counter + 1

        # Create unique ID for this combination
        combo_id <- sprintf("%s|%s|%s|%s", race, gender, age, edu)

        # Generate time series
        rates <- generate_combination_series(race, gender, age, edu, months)

        combinations[[combo_id]] <- list(
          race = race,
          gender = gender,
          age = age,
          education = edu,
          data = data.frame(
            date = as.character(months),
            unemployment_rate = round(rates, 1)
          )
        )

        if (counter %% 50 == 0) {
          cat(sprintf("  Generated %d/%d combinations...\n", counter, total_combinations))
        }
      }
    }
  }
}

cat(sprintf("\n✓ Generated all %d combinations\n\n", counter))

# ==============================================================================
# EXPORT TO JSON
# ==============================================================================

cat("Exporting to JSON...\n")

output <- list(
  metadata = list(
    title = "Unemployment by All Demographic Combinations (2019-2024)",
    dateRange = c("2019-01", "2024-12"),
    totalCombinations = total_combinations,
    categories = list(
      race = races,
      gender = genders,
      age = ages,
      education = education
    )
  ),
  combinations = combinations
)

output_file <- "exercise/1/frontend/public/data/unemploymentCombinations.json"

write_json(output, output_file, pretty = TRUE, auto_unbox = TRUE)

cat(sprintf("\n✓ Saved to: %s\n", output_file))
cat(sprintf("  Total combinations: %d\n", total_combinations))
cat(sprintf("  Data points per combination: %d months\n", length(months)))
cat(sprintf("  Total data points: %d\n\n", total_combinations * length(months)))

cat("=== Generation Complete ===\n")
