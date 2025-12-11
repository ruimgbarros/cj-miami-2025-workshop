# PATTERN 6: AUTONOMOUS AGENT
# Agent makes decisions and chooses actions

source("./code/r/utils/helpers.R")

# Simple "tools" the agent can use
tools_available <- "
Available actions:
1. LOOK - examine your surroundings
2. TAKE [item] - pick up an item
3. USE [item] - use an item you have
4. GO [direction] - move in a direction
"

# Game state
inventory <- c()
location <- "dark forest"
max_turns <- 5

cat("You are in a", location, "\n")
cat("Goal: Find a way out of the forest\n\n")

for (turn in 1:max_turns) {
  cat("--- TURN", turn, "---\n\n")

  # Agent decides what to do
  cat("Agent thinking...\n")
  decision <- query_ai(
    api_key = key,
    prompt = paste(
      "You are playing a text adventure game.",
      "Location:",
      location,
      "Inventory:",
      if (length(inventory) > 0) paste(inventory, collapse = ", ") else "empty",
      tools_available,
      "What do you do? Choose ONE action and explain why briefly.",
      "Format: ACTION: [your choice] REASON: [why]"
    )
  )
  cat(decision, "\n\n")

  # Simulate game response (this would be a real game engine)
  cat("Game responds:\n")
  response <- query_ai(
    api_key = key,
    prompt = paste(
      "You are a game master. The player did:",
      decision,
      "Current location:",
      location,
      "Describe what happens next in 2 sentences. Be creative and fun!"
    )
  )
  cat(response, "\n\n")

  # Check if goal achieved
  if (grepl("exit|escape|leave|out of", response, ignore.case = TRUE)) {
    cat("🎉 Success! You escaped the forest!\n")
    break
  }

  if (turn == max_turns) {
    cat("⏱️ Out of turns! Game over.\n")
  }

  cat(strrep("-", 60), "\n\n")
}

cat("\n=== GAME OVER ===\n")
cat("The agent made", turn, "autonomous decisions\n")
