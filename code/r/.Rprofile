# R Profile for AI Agent Workshop
# This file activates renv for package management

# Activate renv if it exists
if (file.exists("renv/activate.R")) {
  source("renv/activate.R")
}

# Load environment variables from .env file
if (file.exists(".env")) {
  readRenviron(".env")
}

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Welcome message
message("AI Agents Workshop - R Environment Loaded")
message("Make sure you have configured your .env file with API keys")
