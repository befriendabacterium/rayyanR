api_tokens<-jsonlite::read_json("rayyan_tokens.json")
review_id = "1441821"
stages = 'both'
remotes::install_github("https://github.com/befriendabacterium/rayyanR", ref = 'dev', force=T)
library(dplyr)
library(rayyanR)


reports_raw<-rayyanR::reviewresults_req_reports(api_tokens = api_tokens, review_id = "1441821")

test_df<-reviewresults(api_tokens = api_tokens, review_id = "1441821",stages = 'both')


devtools::document()
#usethis document package or in API
#Update documentation