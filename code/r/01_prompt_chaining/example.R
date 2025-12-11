# PATTERN 1: PROMPT CHAINING
# Output of one LLM call becomes input to the next

source("./code/r/utils/helpers.R")

cat("=== PROMPT CHAINING: Story Evolution ===\n\n")

# Start with a simple concept
concept <- "a confused robot"

cat("Starting concept:", concept, "\n\n")

# STEP 1: Create a character
cat("STEP 1: Create character\n")
character <- query_ai(
  api_key = key,
  prompt = paste(
    "Create a funny character description in 2 sentences for:",
    concept
  )
)
cat(character, "\n\n")

# STEP 2: Add a problem (using the character)
cat("STEP 2: Give them a problem\n")
problem <- query_ai(
  api_key = key,
  prompt = paste("Give this character a silly problem (1 sentence):", character)
)
cat(problem, "\n\n")

# STEP 3: Create solution (using the problem)
cat("STEP 3: Create solution\n")
solution <- query_ai(
  api_key = key,
  prompt = paste("How do they solve it? Be creative (2 sentences):", problem)
)
cat(solution, "\n\n")

cat("=== COMPLETE STORY ===\n")
cat(character, "\n")
cat(problem, "\n")
cat(solution, "\n")
