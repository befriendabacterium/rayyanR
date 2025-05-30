% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reviewresults_req_records.R
\name{reviewresults_req_records}
\alias{reviewresults_req_records}
\title{reviewresults_req_records}
\usage{
reviewresults_req_records(api_tokens, review_id)
}
\arguments{
\item{api_tokens}{the api environment from load_tokens_and_env()
or login_tokens_and_env()}

\item{review_id}{the rayyan ID of the review to get - this can be obtained via
get_reviews}
}
\value{
the R object containing the result of the API call
}
\description{
gets a review results for records/abstracts from the rayyan API and outputs the results an R object
}
\keyword{internal}
