#' get_review_results_df
#'
#' gets a review from the rayyan API and outputs the results an R object
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
get_review_results_df <- function(api_tokens, review_id) {
  body<-get_review_results_raw(api_tokens, review_id)
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
