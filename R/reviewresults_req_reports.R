reviewresults_reports <- function(api_tokens, review_id) {
  reviews_route <- paste0("/api/v1/reviews/", review_id, "/results/?extra[stages]=__SYSTEM__STAGE__113306")
  url <- paste0("https://rayyan.ai",  reviews_route)
  req <- httr2::request(url)
  req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
  resp <- httr2::req_perform(req)
  body <- httr2::resp_body_json(resp)
  return(body)
}
