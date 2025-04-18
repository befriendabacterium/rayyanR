#ref: https://httr2.r-lib.org/

#install.packages('httr2')
library(httr2)

#urls
base_url<-'https://rayyan.ai'
reviews_route<-'api/v1/reviews'
request_url<-paste(base_url,reviews_route,sep='/')
req <- request(request_url)

#rayyan tokens
rayyan_tokens<-jsonlite::read_json("rayyan_tokens.json")
token<-rayyan_tokens$access_token
req<-httr2::req_auth_bearer_token(req, token)

#perform the request
resp<-httr2::req_perform(req)

#get json on user_info
reviews<-resp_body_json(resp)

reviews<-resp_body_json(resp)

# DONT RUN PAST HERE ------------------------------------------------------


#begin to get results of 1st review (needs to be moved to retrieve_review_results)
review1_id<-reviews["owned_reviews"]$owned_reviews[[1]]$rayyan_id

results_route<-'results'
request_url<-paste(base_url,reviews_route,review1_id,results_route,sep='/')
req <- request(request_url)
#perform the request
resp<-httr2::req_perform(req)
#get json on user_info
x<-resp_body_json(resp)
x
