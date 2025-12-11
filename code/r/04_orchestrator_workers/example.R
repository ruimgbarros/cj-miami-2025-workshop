# PATTERN 4: ORCHESTRATOR-WORKERS
# One orchestrator delegates tasks to specialized workers

source("./code/r/utils/helpers.R")

cat("=== ORCHESTRATOR-WORKERS: Party Planning ===\n\n")

# The task
task <- "Plan a surprise birthday party for a 10-year-old who loves dinosaurs"
cat("Task:", task, "\n\n")

# STEP 1: Orchestrator breaks down the task
cat("STEP 1: Orchestrator planning...\n")
plan <- query_ai(
  api_key = key,
  prompt = paste(
    "You are a party planning orchestrator. Break down this task into 3 subtasks:",
    "1. Theme & decorations",
    "2. Food & cake",
    "3. Games & activities",
    "For each, write one sentence describing what needs to be done.",
    "Task:",
    task
  )
)
cat(plan, "\n\n")
cat(strrep("-", 60), "\n\n")

# STEP 2: Delegate to specialized workers
cat("STEP 2: Delegating to workers...\n\n")

cat("→ Worker 1 (Decorator):\n")
decorations <- query_ai(
  api_key = key,
  prompt = paste(
    "You are a party decorator. Suggest decorations for a dinosaur-themed",
    "10-year-old's birthday party. Be creative! (2-3 sentences)"
  )
)
cat(decorations, "\n\n")

cat("→ Worker 2 (Chef):\n")
food <- query_ai(
  api_key = key,
  prompt = paste(
    "You are a party caterer. Suggest food and cake ideas for a dinosaur-themed",
    "10-year-old's birthday party. Make it fun! (2-3 sentences)"
  )
)
cat(food, "\n\n")

cat("→ Worker 3 (Activities):\n")
games <- query_ai(
  api_key = key,
  prompt = paste(
    "You are a kids' party entertainer. Suggest games and activities for a",
    "dinosaur-themed 10-year-old's birthday party. (2-3 sentences)"
  )
)
cat(games, "\n\n")

cat(strrep("-", 60), "\n\n")

# STEP 3: Orchestrator synthesizes
cat("STEP 3: Orchestrator synthesizing plan...\n")
final_plan <- query_ai(
  api_key = key,
  prompt = paste(
    "Create a final party plan summary from these worker reports:",
    "\nDecorations:",
    decorations,
    "\nFood:",
    food,
    "\nActivities:",
    games,
    "\nWrite a brief, exciting summary (3-4 sentences)."
  )
)
cat(final_plan, "\n\n")

cat("=== PARTY PLAN COMPLETE ===\n")
