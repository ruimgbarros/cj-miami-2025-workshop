# PATTERN 5: EVALUATOR-OPTIMIZER
# Generate, evaluate, and iterate to improve

source("./code/r/utils/helpers.R")

cat("=== EVALUATOR-OPTIMIZER: Joke Improvement ===\n\n")

# Initial request
topic <- "programmers"
cat("Task: Write a funny joke about", topic, "\n\n")

# Maximum iterations
max_iterations <- 3
current_joke <- ""

for (i in 1:max_iterations) {
  cat("--- ITERATION", i, "---\n\n")

  # GENERATE: Create or improve joke
  if (i == 1) {
    prompt <- paste("Write a short, funny joke about", topic)
  } else {
    prompt <- paste(
      "Here's a joke:",
      current_joke,
      "\nHere's feedback:",
      feedback,
      "\nWrite an improved version."
    )
  }

  cat("Generator:\n")
  current_joke <- query_ai(api_key = key, prompt = prompt)
  cat(current_joke, "\n\n")

  # EVALUATE: Score the joke
  cat("Evaluator:\n")
  feedback <- query_ai(
    api_key = key,
    prompt = paste(
      "Rate this joke from 1-10 and explain why:",
      current_joke,
      "\nBe specific about what could be funnier."
    )
  )
  cat(feedback, "\n\n")

  # Check if good enough (contains "10" or "9")
  if (grepl("10|9/10", feedback)) {
    cat("✓ Joke approved! Stopping iterations.\n\n")
    break
  }

  if (i < max_iterations) {
    cat("→ Not good enough, iterating...\n\n")
  }
}

cat("=== FINAL JOKE ===\n")
cat(current_joke, "\n\n")
cat("Completed in", i, "iteration(s)\n")
