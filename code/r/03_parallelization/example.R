# PATTERN 3: PARALLELIZATION
# Run multiple LLM calls at the same time

source("./code/r/utils/helpers.R")

# Install and load future package for parallel processing
if (!require("future", quietly = TRUE)) {
  install.packages("future")
  library(future)
}

# Enable parallel processing
plan(multisession)

cat("=== PARALLELIZATION: Travel Guide Generator ===\n\n")

city <- "Miami"
cat("Generating travel guide for:", city, "\n\n")

# Start timing
start_time <- Sys.time()

# Launch multiple parallel tasks
cat("Launching parallel tasks...\n")
food_future <- future({
  query_ai(key, paste("List 3 must-try foods in", city, "in one sentence each"))
})

sights_future <- future({
  query_ai(
    key,
    paste("List 3 must-see attractions in", city, "in one sentence each")
  )
})

tips_future <- future({
  query_ai(
    key,
    paste("Give 3 travel tips for visiting", city, "in one sentence each")
  )
})

# Collect results (waits for all to finish)
cat("Waiting for all tasks to complete...\n\n")
food <- value(food_future)
sights <- value(sights_future)
tips <- value(tips_future)

end_time <- Sys.time()

# Display results
cat("=== COMPLETE TRAVEL GUIDE ===\n\n")
cat("🍜 FOOD:\n", food, "\n\n")
cat("🗼 SIGHTS:\n", sights, "\n\n")
cat("💡 TIPS:\n", tips, "\n\n")
cat(
  "Time:",
  round(as.numeric(end_time - start_time, units = "secs"), 1),
  "seconds\n"
)
