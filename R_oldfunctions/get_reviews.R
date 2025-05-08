#' get_reviews
#'
#' gets the reviews from the rayyan API and returns the ID, title,
#' and owner in a dataframe
#'
#' @param api_tokens the api environment from load_tokens_and_env()
#' or login_tokens_and_env()
#'
#' @return a dataframe containing the ID, title, and owner of reviews
#' @export
get_reviews <- function(api_tokens) {
  revs <- get_reviews_raw(api_tokens)
  reviews <- data.frame(
    review_id = integer(),
    title = character(),
    owner = character()
  )
  for (rev in revs$owned_reviews){
    new_row <- data.frame(
      review_id = rev$rayyan_id,
      title = rev$title,
      owner = rev$owner$to_s
    )
    reviews <- rbind(reviews, new_row)
  }
  
  for (rev in revs$collab_reviews){
    new_row <- data.frame(
      review_id = rev$rayyan_id,
      title = rev$title,
      owner = rev$owner$to_s
    )
    reviews <- rbind(reviews, new_row)
  }
  return(reviews)
}