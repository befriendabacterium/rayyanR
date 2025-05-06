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
#' @export
rename_included_cols_names <- function(review_results_df, review_info, rename_with='name') {
  
  if (!rename_with%in%c('name','email')){stop('\'rename with\' must be either \'name\' or \'email\'')}
  
  #parse dfs of owners, reviewers and viewers (all team members)
  owner_df<-data.frame(t(sapply(review_info$owner,c)))
  reviewers_df<-data.frame(t(sapply(review_info$reviewers,c)))
  collaborators_df<-data.frame(t(sapply(review_info$collaborators,c)))
  viewers_df<-data.frame(t(sapply(review_info$viewers, c)))
  
  #where the dataframe has entries, add cols to specify roles
  if(ncol(owner_df)!=0){owner_df<-tibble::add_column(owner_df, .after='id', role='owner')}
  if(ncol(reviewers_df)!=0){reviewers_df<-tibble::add_column(reviewers_df, .after='id', role='reviewer')}
  if(ncol(collaborators_df)!=0){collaborators_df<-tibble::add_column(collaborators_df, .after='id', role='viewer')}
  if(ncol(viewers_df)!=0){viewers_df<-tibble::add_column(viewers_df, .after='id', role='viewer')}
  
  #bind into one df
  member_info_df<-rbind(owner_df,reviewers_df,viewers_df)
  
  #identify included cols by number
  included_colids<-grep('customizations_included',colnames(review_results_df))
  member_nos<-as.character(readr::parse_number(colnames(review_results_df)[included_colids]))
  
  if(rename_with=='name'){
    #install.packages('stringi')
    member_to_s<-gsub(" ", "",member_info_df$to_s[match(member_nos,member_info_df$id)])
    colnames(review_results_df)[included_colids]<-stringr::str_replace_all(string=colnames(review_results_df)[included_colids],
                                                                           pattern=member_nos,
                                                                           replacement=member_to_s)
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