
#' load_tokens_and_env
#'
#' loads API credentials from a JSON file
#' and returns an object containing the tokens and
#' API URL
#' @param creds the json file containing the credentials exported from rayyan
#' @param base_url the API base URL (defaults to production)
#'
#' @return an api environment to be passed to the other functions
load_tokens_and_env <- function(
    creds,
    base_url = "https://rayyan.ai"
) {
    api_env <- jsonlite::read_json(creds)
    api_env$base_url <- base_url
    return(api_env)
}


#' login_tokens_and_env
#'
#' imports the API tokens from function arguments
#' and returns an object containing the tokens and
#' API URL
#' @param creds the json file containing the credentials exported from rayyan
#' @param base_url the API base URL (defaults to production)
#'
#' @return an api environment to be passed to the other functions
login_tokens_and_env <- function(
    access_token,
    refresh_token,
    base_url = "https://rayyan.ai"
) {
    api_env <- NULL
    api_env$access_token <- access_token
    api_env$refresh_token <- refresh_token
    api_env$base_url <- base_url
    return(api_env)
}
