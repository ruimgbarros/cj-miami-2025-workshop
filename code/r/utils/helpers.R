# Install and load required packages
required_packages <- c("httr", "jsonlite")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    message(sprintf("Installing package: %s", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org/")
    library(pkg, character.only = TRUE)
  }
}

#' Query OpenRouter API
#'
#' @param api_key OpenRouter API key
#' @param prompt Text prompt to send to the model
#' @param model Model to use (default: "anthropic/claude-3.5-sonnet")
#'
#' @return Text response from the model
#' @export
query_ai <- function(api_key, prompt, model = "anthropic/claude-3.5-sonnet") {
  # Validate inputs
  if (missing(api_key) || is.null(api_key) || api_key == "") {
    stop("API key is required")
  }

  if (missing(prompt) || is.null(prompt) || prompt == "") {
    stop("Prompt is required")
  }

  # API endpoint
  url <- "https://openrouter.ai/api/v1/chat/completions"

  # Prepare request body
  body <- list(
    model = model,
    messages = list(
      list(
        role = "user",
        content = prompt
      )
    )
  )

  # Make API request
  response <- httr::POST(
    url,
    httr::add_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ),
    body = jsonlite::toJSON(body, auto_unbox = TRUE),
    encode = "raw"
  )

  # Check for errors
  if (httr::http_error(response)) {
    stop(sprintf(
      "OpenRouter API request failed with status %s: %s",
      httr::status_code(response),
      httr::content(response, "text", encoding = "UTF-8")
    ))
  }

  # Parse response
  content <- httr::content(response, "parsed", encoding = "UTF-8")

  # Extract text response
  if (!is.null(content$choices) && length(content$choices) > 0) {
    return(content$choices[[1]]$message$content)
  } else {
    stop("No response content found in API response")
  }
}
