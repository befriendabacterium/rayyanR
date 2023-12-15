#' get_reviews_raw
#'
#' gets reviews from the rayyan API and outputs an R object
#'
#' @param api_env the api envrionment from load_tokens_and_env()
#' or login_tokens_and_env()
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_reviews_raw <- function(api_env) {
    api_path <- "/api/v1/reviews"
    url <- paste0(api_env$base_url, "/", api_path)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_env$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}


#' get_reviews
#'
#' gets the reviews from the rayyan API and returns the ID, title,
#' and owner in a dataframe
#'
#' @param api_env the api envrionment from load_tokens_and_env()
#' or login_tokens_and_env()
#'
#' @return a dataframe containing the ID, title, and owner of reviews
get_reviews <- function(api_env) {
    revs <- get_reviews_raw(api_env)
    reviews <- data.frame(
        id = integer(),
        title = character(),
        owner = character()
    )
    for (rev in revs$owned_reviews){
        new_row <- data.frame(
            id = rev$rayyan_id,
            title = rev$title,
            owner = rev$owner$to_s
        )
        reviews <- rbind(reviews, new_row)
    }

    for (rev in revs$collab_reviews){
        new_row <- data.frame(
            id = rev$rayyan_id,
            title = rev$title,
            owner = rev$owner$to_s
        )
        reviews <- rbind(reviews, new_row)
    }
    return(reviews)
}

#' get_review_info_raw
#'
#' gets a review from the rayyan API and outputs the metadata an R object
#'
#' @param api_env the api envrionment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_review_info_raw <- function(api_env, id) {
    api_path <- paste0("/api/v1/reviews/", id)
    url <- paste0(api_env$base_url, "/", api_path)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_env$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}

#' get_review_results_raw
#'
#' gets a review from the rayyan API and outputs the results an R object
#'
#' @param api_env the api envrionment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_review_results_raw <- function(api_env, id) {
    api_path <- paste0("/api/v1/reviews/", id, "/results")
    url <- paste0(api_env$base_url, "/", api_path)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_env$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}


#' get_aws_presigned_url
#'
#' gets a URL to enable uploading of files or artilces
#'
#' @param api_env the api envrionment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_aws_presigned_url <- function(api_env, id) {
    api_path <- paste0("/api/v1/reviews/", id, "/searches/new")
    url <- paste0(api_env$base_url, "/", api_path)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_env$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}
