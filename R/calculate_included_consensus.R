#' calculate_included_consensus
#'
#' calculates consensus based on individual reviewer decisions
#'
#' @param review_results_df the dataframe with the review data from get_review_results_df() API call and tidying function
#' rename_included_cols
#'
#' @keywords internal
#'
#' @return the R object containing the dataframe with a new column 'customizations_included_consensus' with the consensus where there is one (or 'conflict' if not)
#' @export
calculate_included_consensus <- function(review_results_df, review_info) {
  
  #identify included cols by number
  included_colids<-grep('customizations_included',colnames(review_results_df))
  
  #add consensus column after the included cols, and populate with 'Conflict' by default
  review_results_df<-tibble::add_column(review_results_df,
                                        customizations_included_consensus = 'conflict',
                                        .after=included_colids[length(included_colids)])
  
  #coerce them to character
  review_results_df[,included_colids]<-lapply(review_results_df[,included_colids],as.character)
  
  #rename individual reviewer decisions with human-readable decisions
  review_results_df[,included_colids][review_results_df[,included_colids]=='-1']<-'excluded'
  review_results_df[,included_colids][review_results_df[,included_colids]=='0']<-'maybe'
  review_results_df[,included_colids][review_results_df[,included_colids]=='1']<-'included'
  
  #calculate consensus where there is one
  review_results_df$customizations_included_consensus[apply(review_results_df[,included_colids],1,function(x){all(x=='included', na.rm = T)})]<-'included'
  review_results_df$customizations_included_consensus[apply(review_results_df[,included_colids],1,function(x){all(x=='maybe', na.rm = T)})]<-'maybe'
  review_results_df$customizations_included_consensus[apply(review_results_df[,included_colids],1,function(x){all(x=='excluded', na.rm = T)})]<-'excluded'
  
  #coerce to factor
  review_results_df$customizations_included_consensus<-as.factor(review_results_df$customizations_included_consensus)
  
  return(review_results_df)
}
