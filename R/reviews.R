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
get_reviews_raw <- function(api_tokens) {
    reviews_route <- "/api/v1/reviews"
    url <- paste0("https://rayyan.ai",  reviews_route)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}


#' get_reviews
#'
#' gets the reviews from the rayyan API and returns the ID, title,
#' and owner in a dataframe
#'
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#'
#' @return a dataframe containing the ID, title, and owner of reviews
get_reviews <- function(api_tokens) {
    revs <- get_reviews_raw(api_tokens)
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
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_review_info_raw <- function(api_tokens, id) {
    reviews_route <- paste0("/api/v1/reviews/", id)
    url <- paste0("https://rayyan.ai",  reviews_route)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}

#' get_review_results_raw
#'
#' gets a review from the rayyan API and outputs the results an R object
#'
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_review_results_raw <- function(api_tokens, id) {
    reviews_route <- paste0("/api/v1/reviews/", id, "/results")
    url <- paste0("https://rayyan.ai",  reviews_route)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}

#' get_review_results_df
#'
#' gets a review from the rayyan API and outputs the results an R object
#'
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_review_results_df <- function(api_tokens, id) {
  body<-get_review_results_raw(api_tokens, id)
  #parse json body (list format) to data.frame with nested lists
  review_results_df<-data.frame(t(sapply(body$data,c)))
  #unlist the 2nd level list of keyphrases, then apply paste on the resulting 1st level list to paste together (after uncapitalising) into one ;-separated string
  review_results_df$keyphrases_arr<-lapply(lapply(review_results_df$keyphrases_arr,unlist),function(x){paste(tolower(x),collapse='; ')})
  #unlist the 2nd level list of authors, then apply paste on the resulting 1st level list to paste together into one ;-separated string
  review_results_df$authors<-lapply(lapply(review_results_df$authors,unlist),function(x){paste(x,collapse='; ')})
  #unnest all the list columns
  review_results_df<-unnest_all(review_results_df)
  #remove redundant _1's (for unnested columns)
  colnames(review_results_df)<-gsub("_1", "", colnames(review_results_df))
  # #rename 'included' as 'decision' because its more intuitive
  #reviews_results_df<-dplyr::rename(reviews_results_df,decision=included)
  
  return(review_results_df)
}


#' get_aws_presigned_url
#'
#' gets a URL to enable uploading of files or artilces
#'
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#' @param id the rayyan ID of the review to get - this can be obtained via
#' get_reviews
#'
#' @keywords internal
#'
#' @return the R object containing the result of the API call
get_aws_presigned_url <- function(api_tokens, id) {
    reviews_route <- paste0("/api/v1/reviews/", id, "/searches/new")
    url <- paste0("https://rayyan.ai",  reviews_route)
    req <- httr2::request(url)
    req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
    resp <- httr2::req_perform(req)
    body <- httr2::resp_body_json(resp)
    return(body)
}



#' rename_included_cols_names
#'
#' renames the included columns' names so that they have explicit reviewer names rather than reviewer id
#'
#' @param review_info a list with the review data from get_review_info() API call function
#' @param review_results_df the dataframe with the review data from get_review_results_df() API call and tidying function
#' @param rename_with what should the IDs be renamed with. Must be 'name' or 'email'.
#' rename_included_cols
#'
#' @keywords internal
#'
#' @return the R object containing the tidied dataframe
#' 
rename_included_cols_names <- function(review_info, review_results_df, rename_with='name') {
  
  if (!rename_with%in%c('name','email')){stop('\'rename with\' must be either \'name\' or \'email\'')}
  
  owner_df<-data.frame(t(sapply(review_info$owner,c)))
  allcollaborators_df<-data.frame(t(sapply(review_info$all_collaborators,c)))
  reviewer_info_df<-rbind(owner_df,allcollaborators_df)
  
  #identify included cols by number
  included_colids<-grep('customizations_included',colnames(review_results_df))
  reviewer_nos<-as.character(readr::parse_number(colnames(review_results_df)[included_colids]))
  
  if(rename_with=='name'){
    #install.packages('stringi')
    reviewer_to_s<-gsub(" ", "",reviewer_info_df$to_s[match(reviewer_nos,reviewer_info_df$id)])
    colnames(review_results_df)[included_colids]<-stringr::str_replace_all(string=colnames(review_results_df)[included_colids],
                                                                           pattern=reviewer_nos,
                                                                           replacement=reviewer_to_s)
  }
  
  if(rename_with=='email'){
    #install.packages('stringi')
    reviewer_emails<-gsub(" ", "",reviewer_info_df$email[match(reviewer_nos,reviewer_info_df$id)])
    colnames(review_results_df)[included_colids]<-stringr::str_replace_all(string=colnames(review_results_df)[included_colids],
                                                                           pattern=reviewer_nos,
                                                                           replacement=reviewer_emails)
  }
  
  return(review_results_df)
}


#' rename_included_cols_values
#'
#' renames the included columns' values so they are explicitly 'Excluded' (-1), 'Maybe' (0), and 'Included' (1)
#'
#' @param review_results_df the dataframe with the review data from get_review_results_df() API call and tidying function
#' rename_included_cols
#'
#' @keywords internal
#'
#' @return the R object containing the tidied dataframe
#' 
rename_included_cols_values <- function(review_results_df) {
  
  #identify included cols by number
  included_colids<-grep('customizations_included',colnames(review_results_df))
  
  #coerce them to character
  review_results_df[,included_colids]<-apply(review_results_df[,included_colids],2,as.character)
  
  #rename them explicitly
  review_results_df[,included_colids][review_results_df[,included_colids]=='-1']<-'Excluded'
  review_results_df[,included_colids][review_results_df[,included_colids]=='0']<-'Maybe'
  review_results_df[,included_colids][review_results_df[,included_colids]=='1']<-'Included'
  
  return(review_results_df)
}



#' calculate_included_consensus
#'
#' calculates consensus based on individual reviewer decisions
#'
#' @param review_results_df the dataframe with the review data from get_review_results_df() API call and tidying function
#' rename_included_cols
#'
#' @keywords internal
#'
#' @return the R object containing the dataframe with a new column 'customizations_included_consensus' with the consensus where there is one (or 'Conflict' if not)
#' 
calculate_included_consensus <- function(review_results_df) {

#add consensus column after the included cols, and populate with 'Conflict' by default
review_results_df<-tibble::add_column(review_results_df,
                                      customizations_included_consensus = 'Conflict',
                                      .after=included_colids[length(included_colids)])

#calculate consensus where there is one
review_results_df$customizations_included_consensus[rowSums(review_results_df[,included_colids]=='Included')==length(included_colids)]<-'Included'
review_results_df$customizations_included_consensus[rowSums(review_results_df[,included_colids]=='Maybe')==length(included_colids)]<-'Maybe'
review_results_df$customizations_included_consensus[rowSums(review_results_df[,included_colids]=='Excluded')==length(included_colids)]<-'Excluded'

return(review_results_df)
}
