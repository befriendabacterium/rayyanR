#' get_review_info_raw
#'
#' gets a review from the rayyan API and outputs the metadata an R object
#'
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param review_id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call 
#' @export
get_review_info_raw <- function(api_tokens, review_id) {
  reviews_route <- paste0("/api/v1/reviews/", review_id)
  url <- paste0("https://rayyan.ai",  reviews_route)
  req <- httr2::request(url)
  req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
  resp <- httr2::req_perform(req)
  body <- httr2::resp_body_json(resp)
  return(body)
}
