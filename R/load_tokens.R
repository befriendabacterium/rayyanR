
#' load_tokens
#'
#' loads API credentials from a JSON file
#' @param creds local path to the json file containing the credentials exported from rayyan
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
#' @param creds local path to the json file containing the credentials exported from rayyan
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


#' refresh_tokens
#'
#' refreshes the API tokens from function arguments
#' @param creds local path to the json file containing the credentials exported from rayyan
#' @param update_local option to overwrite existing json file containing the credentials with the new, updated credentials. Defaults to TRUE.
#'
#' @return an api environment to be passed to the other functions
refresh_tokens <- function(
    creds, update_local=T
) {
    api_tokens <- jsonlite::read_json(creds)
    api_tokens_fresh <- suppressWarnings(
                        oauth_flow_refresh(
                        httr2::oauth_client("rayyan.ai", "https://rayyan.ai/oauth/token"),
                        refresh_token = api_tokens$refresh_token,
                        scope = NULL,
                        token_params = list())
                        )
    
    #simplify the updated tokens file to a list in same format as downloadable ones
    api_tokens_fresh <- list(access_token = api_tokens_fresh$access_token,
                              refresh_token = api_tokens_fresh$refresh_token)
    
    #if update_local is true, overwrite existing rayyan creds file with new tokens
    if(update_local==T){
      jsonlite::write_json(api_tokens_fresh, creds, auto_unbox=T)
      message('Access and refresh tokens updated, and local credentials file was updated.')
    }
    else{
    warning('Access and refresh tokens updated, but local credentials file was not updated! You will need to manually download new tokens from https://rayyan.ai/users/edit to refresh tokens again')
    }

    return(api_tokens_fresh)
}

# run at end to update documentation
# devtools::document()