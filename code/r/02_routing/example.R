# PATTERN 2: ROUTING
# Different inputs go to different specialized handlers

source("./code/r/utils/helpers.R")

cat("=== ROUTING: Question Classifier ===\n\n")

# Function to route questions to the right expert
route_question <- function(question) {
  cat("Question:", question, "\n")

  # First, classify the question
  classification <- query_ai(
    api_key = key,
    prompt = paste(
      "Classify this question as one of: MATH, SCIENCE, CREATIVE, or OTHER:",
      question
    )
  )

  cat("Route:", trimws(classification), "\n")

  # Route to appropriate expert based on classification
  if (grepl("MATH", classification, ignore.case = TRUE)) {
    prompt <- "You are a math expert. Be precise and show your work."
  } else if (grepl("SCIENCE", classification, ignore.case = TRUE)) {
    prompt <- "You are a science expert. Explain clearly with examples."
  } else if (grepl("CREATIVE", classification, ignore.case = TRUE)) {
    prompt <- "You are a creative writer. Be imaginative and fun."
  } else {
    prompt <- "You are a general assistant. Be helpful and friendly."
  }

  # Get answer from the specialized expert
  answer <- query_ai(
    api_key = key,
    prompt = paste(prompt, "Answer this:", question)
  )

  cat("Answer:", answer, "\n\n")
  cat(strrep("-", 60), "\n\n")
}

# Test different types of questions
route_question("What is 47 × 23?")
route_question("Why is the sky blue?")
route_question("Write a haiku about coffee")
