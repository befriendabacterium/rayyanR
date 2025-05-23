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

records_and_reports_results<-records_and_reports_results %>% rename(abstract=abstracts_content)
records_and_reports_results<-records_and_reports_results %>% rename(author=authors)
records_and_reports_results<-records_and_reports_results %>% rename(DOI=doi)

synthesisr::write_refs(records_and_reports_results,file='recs_and_reps.bib', format='bib')

devtools::document()
#usethis document package or in API
#Update documentation