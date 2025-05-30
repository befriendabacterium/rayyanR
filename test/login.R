#ref: https://httr2.r-lib.org/
#install.packages('httr2')
library(httr2)

url<-'https://rayyan.ai/api/v1/user_info/'
req <- httr2::request(url)
rayyan_tokens<-jsonlite::read_json("rayyan_tokens.json")
token <- rayyan_tokens$access_token
token

req<-httr2::req_auth_bearer_token(req, token)

#dry run
httr2::req_dry_run(req)

#perform the request
resp<-httr2::req_perform(req)

resp


#get json on user_info
httr2::resp_body_json(resp)
