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
#' @export
rename_included_cols_values <- function(review_results_df) {
  
  #identify included cols by number
  included_colids<-grep('customizations_included',colnames(review_results_df))
  
  #coerce them to character
  review_results_df[,included_colids]<-lapply(review_results_df[,included_colids],as.character)
  
  #rename them explicitly
  review_results_df[,included_colids][review_results_df[,included_colids]=='-1']<-'Excluded'
  review_results_df[,included_colids][review_results_df[,included_colids]=='0']<-'Maybe'
  review_results_df[,included_colids][review_results_df[,included_colids]=='1']<-'Included'
  
  return(review_results_df)
}