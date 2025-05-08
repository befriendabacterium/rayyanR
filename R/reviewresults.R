#' reviewresults
#'
#' gets a review from the rayyan API and outputs the results a tidied R object
#' @param api_tokens the api environment from load_tokens_and_env() or login_tokens_and_env()
#' @param review_id the rayyan ID of the review to get - this can be obtained via
#' @param stages specify if both stages present in the review
#' @param recordsreview_id if there is a separate review for the records/abstract (rather than it being in), specify it here'.
#' @param reportsreview_id if there is a separate review for the reports/full text (rather than it being in), specify it here'.
#' @keywords internal
#' @return the R object containing the result of the API call #' 
#' @export

reviewresults <- function(api_tokens, review_id=NULL, stages=c('both','records'), recordsreview_id=NULL, reportsreview_id=NULL) {
  
  bodies<-list()
  
  #if there is only a review id with two stages, get results for both stages
  if (!is.null(review_id)&stages=='both'){
    body_records<-reviewresults_req_records(api_tokens, review_id)
    body_reports<-reviewresults_req_reports(api_tokens, review_id='1441821') #temporarily specify review id as currently only works with this function
    bodies<-list(body_records, body_reports)
    names(bodies)<-c('records','reports')
    
  }
    
  #if there is only a review id with only records stage, get results for the records stage
  if (!is.null(review_id)&stages=='one'){
    #reset bodies
    bodies<-list() 
    #get JSON bodies for both stages  
    body_records<-reviewresults_req_records(api_tokens, review_id)
    bodies[[length(bodies)+1]]<-body_records
    names(bodies)[[length(bodies)]]<-'reports'
  }
  
  #if there is a records id, get results for the records stage
  if (!is.null(recordsreview_id)){
    #reset bodies
    bodies<-list() 
    #get JSON bodies for both stages  
    body_records<-reviewresults_req_records(api_tokens, review_id=recordsreview_id)
    bodies[[length(bodies)+1]]<-body_records
    names(bodies)[[length(bodies)]]<-'records'
  }
  
  #if there is a reports id, get results for the reports stage
  if (!is.null(reportsreview_id)){
    #get JSON bodies for both stages  
    body_reports<-reviewresults_req_reports(api_tokens, review_id='1441821') #temporarily specify review id as currently only works with this function
    bodies[[length(bodies)+1]]<-body_reports
    names(bodies)[[length(bodies)]]<-'reports'
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
    #remove columns with 'fulltexts' in colnames because these have not very useful metadata for fulltexts (e.g. pdf names)
    review_results_df<-review_results_df[,-grep('fulltexts',colnames(review_results_df))]
    
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
    #assign results df to explicitly stage-labelled df
    review_results_df_reports<-review_results_df
    }
  }
   
  #if there is a records id AND a reports ID, bind into one
  if (stages=='both'){
    #merge stages into one df
    review_results_df <- dplyr::left_join(review_results_df_records, review_results_df_reports)
  }
  
  #if there is a records id AND a reports ID, bind into one
  if (!is.null(recordsreview_id)&!is.null(reportsreview_id)){
    #merge stages into one df
    review_results_df <- dplyr::left_join(review_results_df_records, review_results_df_reports)
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
