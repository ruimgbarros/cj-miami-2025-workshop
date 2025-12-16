# Load required libraries
source("./code/r/utils/helpers.R")

key <- "put_your_api_key_here"

test <- query_ai(
  api_key = key,
  prompt = "Write a haiku about data journalsm."
)
