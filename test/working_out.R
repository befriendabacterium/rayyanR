library(dplyr)
sapply(list.files('./R',full.names = T,  ignore.case=TRUE),source,.GlobalEnv)

source('R/load_tokens.R')
source('R/reviews.R')
source('R/reviews.R')

api_tokens<-load_tokens(creds = 'rayyan_tokens.json')

allreviews_info<-get_reviews_raw(api_tokens)
allreviews_info

id <- '979908'


get_inclusion_counts(api_tokens=api_tokens ,id='979908')

#get_reviews_raw(api_tokens)
review_info<-get_review_info_raw(api_tokens, id)
#review_results<-get_review_results_raw(api_tokens, id)
review_results_df<-get_review_results_df(api_tokens, id)
#rename included columns' names
review_results_df<-rename_included_cols_names(review_info,review_results_df,rename_with = 'name')
#rename included columns' values
review_results_df<-rename_included_cols_values(review_results_df)
#calculate reviewer consensus
review_results_df<-calculate_included_consensus(review_results_df)

#write.csv(review_results_df,'rayyanR_exampleoutput_201223.csv', row.names = F)
