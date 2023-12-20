
#' load_tokens
#'
#' loads API credentials from a JSON file
#' @param creds the json file containing the credentials exported from rayyan
#' @param base_url the API base URL (defaults to production)
#'
#' @return an api environment to be passed to the other functions
load_tokens <- function(
    creds
) {
    api_tokens <- jsonlite::read_json(creds)
    return(api_tokens)
}


#' login_tokens
#'
#' imports the API tokens from function arguments
#' @param creds the json file containing the credentials exported from rayyan
#' @param base_url the API base URL (defaults to production)
#'
#' @return an api environment to be passed to the other functions
login_tokens <- function(
    access_token,
    refresh_token
) {
    api_tokens <- NULL
    api_tokens$access_token <- access_token
    api_tokens$refresh_token <- refresh_token
    return(api_tokens)
}
