list_reviews <- function(api_env){
    api_path <- "/api/v1/reviews"
    url <- paste0(api_env$base_url, "/", api_path)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_env$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}

get_review_info <- function(api_env, id){
    api_path <- paste0("/api/v1/reviews/",id)
    url <- paste0(api_env$base_url, "/", api_path)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_env$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}