
#' get_user_info
#'
#' Gets the user information from rayyan
#'
#' @param api_env the api envrionment from load_tokens_and_env()
#'
#' @return an object containing the user information from the rayyan API.
get_user_info <- function(api_env){
    api_path <- "api/v1/user_info/"
    url <- paste0(api_env$base_url, "/", api_path)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_env$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    body$request_token = NULL
    return(body)
}