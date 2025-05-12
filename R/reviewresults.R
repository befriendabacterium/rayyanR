#' reviewresults
#'
#' gets a review from the rayyan API and outputs the results a tidied R object
#' @param api_tokens the api environment from load_tokens_and_env() or login_tokens_and_env()
#' @param review_id the rayyan ID of the review to get - this can be obtained via
#' @param recordsandreports_review_id f there is a single review containing both the records/abstract and reports/full text stages (intended implementation of Rayyan), specify it here (N.B. This is currently a placeholder and won't work as there is currently no API endpoint from which to read the full text stage of a Rayyan review, as far as I can tell)
#' @param records_review_id if there is a separate review for the records/abstract (rather than it being in a single review with the reports/full text stage), specify it here'.
#' @param reports_review_id if there is a separate review for the reports/full text (rather than it being in a single review with the records/abstract stage), specify it here'.
#' @keywords internal
#' @return the R object containing the result of the API call #' 
#' @export

reviewresults <- function(api_tokens, recordsandreports_review_id=NULL, records_review_id=NULL, reports_review_id=NULL) {
  
  bodies<-list()
  
  #if there is a recordsandreports review id (intended implementation of Rayyan), get results for both stages
  if (!is.null(recordsandreports_review_id)){
    body_records<-reviewresults_req_records(api_tokens, review_id=recordsandreports_review_id)
    bodies[[length(bodies)+1]]<-body_records #add record body to list
    names(bodies)[length(bodies)]<-c('records')
    body_reports<-reviewresults_req_reports(api_tokens, review_id='1441821') #temporarily specify review id as currently only works with this function
    bodies[[length(bodies)+1]]<-body_records #add report body to list
    names(bodies)[length(bodies)]<-c('reports')
  }
  
  #if there is a records stage ID, get results for the records stage
  if (!is.null(records_review_id)){
    body_records<-reviewresults_req_records(api_tokens, review_id=records_review_id)
    bodies[[length(bodies)+1]]<-body_records #add record body to list
    names(bodies)[length(bodies)]<-c('records')
    
  }
  
  #if there is a reports stage ID, get results for the records stage (N.B. if there's a separate records stage ID, the reports stage will be added after in the list)
  if (!is.null(reports_review_id)){
    body_reports<-reviewresults_req_records(api_tokens, review_id=reports_review_id)
    bodies[[length(bodies)+1]]<-body_reports #add report body to list
    names(bodies)[length(bodies)]<-c('reports')
  }
    
  #then apply to all bodies  
  for (i in 1:length(bodies)){
    
    #parse json body (list format) to data.frame with nested lists
    review_results_df<-data.frame(t(sapply(bodies[[i]]$data,c)))
    #unlist the 2nd level list of keyphrases, then apply paste on the resulting 1st level list to paste together (after uncapitalising) into one ;-separated string
    review_results_df$keyphrases_arr<-lapply(lapply(review_results_df$keyphrases_arr,unlist),function(x){paste(tolower(x),collapse='; ')})
    #unlist the 2nd level list of authors, then apply paste on the resulting 1st level list to paste together into one ;-separated string
    review_results_df$authors<-lapply(lapply(review_results_df$authors,unlist),function(x){paste(x,collapse='; ')})
    #unnest all the list columns
    review_results_df<-unnest_all(review_results_df)
    #remove redundant _1's (for unnested columns)
    colnames(review_results_df)<-gsub("_1", "", colnames(review_results_df))
    #move search ids to start of dataframe after IDs for neatness/order everything in order of review
    review_results_df<-review_results_df %>% relocate(search_ids, .after = 'id')
    #check if fulltext metadata cols
    fulltext_metadata_cols<-grep('fulltexts',colnames(review_results_df))
    #remove columns with 'fulltexts' in colnames because these have not very useful metadata for fulltexts (e.g. pdf names)
    if (length(fulltext_metadata_cols)!=0){review_results_df<-review_results_df[,-grep('fulltexts',colnames(review_results_df))]}
    #calculate included consensus
    review_results_df<-reviewresults_calculateconsensus(review_results_df = review_results_df)
    
    #if records/abstracts stage
    if (names(bodies)[i]=='records'){
    #Rename 'customizations' columns to a more tidy format 
    ##replace 'customizations_included_' with 'record_decision_'
    colnames(review_results_df) <- gsub("customizations_included_", "record_decision_", colnames(review_results_df))
    ##replace 'customizations___EXR_' with 'record_exreason_'
    colnames(review_results_df) <- gsub("customizations___EXR_", "record_exreason_", colnames(review_results_df))
    ##replace 'customizations_labels' with 'record_label'
    colnames(review_results_df) <- gsub("customizations_labels", "record_label", colnames(review_results_df))
    #rename (rayyan) id column to 'record_id'
    review_results_df <- review_results_df %>% rename(screening_id=id)
    #assign results df to explicitly stage-labelled df
    review_results_df_records<-review_results_df
    }
    
    #if reports/full texts stage
    if (names(bodies)[i]=='reports'){
    #Rename 'customizations' columns to a more tidy format 
    ##replace 'customizations_included_' with 'record_decision_'
    colnames(review_results_df) <- gsub("customizations_included_", "report_decision_", colnames(review_results_df))
    ##replace 'customizations___EXR_' with 'record_exreason_'
    colnames(review_results_df) <- gsub("customizations___EXR_", "report_exreason_", colnames(review_results_df))
    ##replace 'customizations_labels' with 'record_label'
    colnames(review_results_df) <- gsub("customizations_labels", "report_label", colnames(review_results_df))
    ##rename (rayyan) screening id column to 'record_id'
    review_results_df <- review_results_df %>% rename(screening_id=sid)
    ##rename (rayyan) full text id column to 'record_id'
    review_results_df <- review_results_df %>% rename(fulltextscreening_id=id)
    #clear "rayyan-" from string and coerce to integer
    review_results_df$screening_id <- as.integer(gsub("rayyan-", "", review_results_df$screening_id))
    #move screening ids to start of dataframe after IDs for neatness/order everything in order of review
    review_results_df<-review_results_df %>% relocate(screening_id, .before = 'fulltextscreening_id')
    #assign results df to explicitly stage-labelled df
    review_results_df_reports<-review_results_df
    }
  }
   
  # if there is a records id AND a reports ID, bind into one
  # NB it appears that things marked as 'Maybe' in a Rayyan export have their sid (screening id?) turned to NA
  # therefore when matching this way, 'Maybes' are removed
  # therefore as you cannot currently delete records in Rayyan, 
  # a workaround if you have accidently screened something at full text stage which you shouldn't have
  # is to get all reviewers to mark it as 'Maybe'..
  # a bit janky and should watch out for bugs but currently seems to work and
  # should be a better fix if Rayyan make it possible to remove/censor records in future
  # or better, avoidable if users just do abstract and full text in one Rayyan review as intended (and Rayyan get API working for full text stage...)
  if (length(bodies)==2){
    #merge stages into one df
    review_results_df <- dplyr::left_join(review_results_df_records, review_results_df_reports, by='screening_id', suffix=c("",".y")) %>%  select(-ends_with(".y"))
    #check results (excluded at record stage should have no decisions at report)
    #test<-review_results_df[,c("record_decision_consensus","report_decision_consensus")]
      }
    
    #review_info<-get_review_info_raw(api_tokens, review_id)
    #NB DISABLED RENAMING AS NOT WORKING - CHECK RENAME_INCLUDED_COLS_NAMES/VALUES() FUNCTIONS
    #review_results_df<-rename_included_cols_names(review_results_df = review_results_df, review_info=review_info, rename_with = 'name')
    #review_results_df<-rename_included_cols_values(review_results_df = review_results_df)
    #if one reviewer is NA, remove
  
  return(review_results_df)
}

# run at end to update documentation
# devtools::document()
