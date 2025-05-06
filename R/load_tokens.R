#' load_tokens
#'
#' loads API credentials from a JSON file
#' @param creds local path to the json file containing the credentials exported from rayyan
#'
#' @return an api environment to be passed to the other functions
#' #' @export
load_tokens <- function(
    creds
) {
  api_tokens <- jsonlite::read_json(creds)
  return(api_tokens)
}