#' get_reviews_raw
#'
#' gets reviews from the rayyan API and outputs an R object
#'
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
#' @export
get_reviews_raw <- function(api_tokens) {
  reviews_route <- "/api/v1/reviews"
  url <- paste0("https://rayyan.ai",  reviews_route)
  req <- httr2::request(url)
  req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
  resp <- httr2::req_perform(req)
  body <- httr2::resp_body_json(resp)
  return(body)
}

