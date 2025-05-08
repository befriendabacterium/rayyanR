#' login_tokens
#'
#' imports the API tokens from function arguments
#' @param creds local path to the json file containing the credentials exported from rayyan
#'
#' @return an api environment to be passed to the other functions
#' @export
login_tokens <- function(
    access_token,
    refresh_token
) {
  api_tokens <- NULL
  api_tokens$access_token <- access_token
  api_tokens$refresh_token <- refresh_token
  return(api_tokens)
}