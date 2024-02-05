library(dplyr)

api_tokens<-load_tokens(creds = 'test/rayyan_tokens.json')

allreviews_info<-get_reviews_raw(api_tokens)
allreviews_info

id <- '874815'

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
