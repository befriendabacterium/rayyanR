api_tokens<-jsonlite::read_json("rayyan_tokens.json")
review_id = "1441821"
stages = 'both'
fulltextreview_id = NULL
remotes::install_github("https://github.com/befriendabacterium/rayyanR", ref = 'dev', force=T)
library(dplyr)
library(rayyanR)

recordsreview_id = "1441821"
reportreview_id = "1445423"

generic_results<-reviewresults(api_tokens = api_tokens, review_id = "1441821", stages='one')

records_results<-reviewresults(api_tokens = api_tokens, recordsreview_id = "1441821", stages='one')

reports_results<-reviewresults(api_tokens = api_tokens, reportsreview_id = "1445423",  stages='one')

records_and_reports_results<-reviewresults(api_tokens = api_tokens, recordsreview_id = "1441821", reportsreview_id = "1445423", stages='one')


devtools::document()
#usethis document package or in API
#Update documentation