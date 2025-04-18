source('R/load_tokens.R')

library(httr2)

base_url<-'https://new.rayyan.ai/'
api_tokens<-refresh_tokens(creds = 'rayyan_tokens.json', update_local = T)
api_tokens
id <- '874815'
reviews_route <- paste0("/api/v1/reviews/", id, "/results")
url <- paste0(base_url,reviews_route)

#direct
req <- httr2::request(url)
req <- httr2::req_auth_bearer_token(req, api_tokens$access_token)
resp <- httr2::req_perform(req)


body <- httr2::resp_body_json(resp)

rm(req,resp,body)

api_tokens<-refresh_tokens(api_tokens = api_tokens)



newtokens<-tokens

api



req <- httr2::request(url)
req <- req_oauth_refresh(req=req, client=client, refresh_token = api_env$refresh_token)
resp <- httr2::req_perform(req)
body <- httr2::resp_body_json(resp)










req <- httr2::request(url)
resp <- httr2::req_perform(req)
resp

                  


req <- httr2::req_auth_bearer_token(req, api_env$access_token)
resp <- httr2::req_perform(req)







req <- httr2::req_auth_bearer_token(req, api_env$access_token)


req <- request("rayyan.ai")
req
class(req)
