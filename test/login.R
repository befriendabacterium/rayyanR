#ref: https://httr2.r-lib.org/

#install.packages('httr2')
library(httr2)
url<-'https://rayyan.ai/api/v1/user_info/'
req <- request(url)
rayyan_tokens<-jsonlite::read_json("rayyan_tokens.json")
token<-rayyan_tokens$access_token
req<-httr2::req_auth_bearer_token(req, token)

httr2::req_dry_run(req)

resp<-httr2::req_perform(req)
resp
