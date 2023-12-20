#' unnest_all
#'
#' recursively unnests all the list columns in a dataframe. borrowed from:
#' https://stackoverflow.com/questions/63786411/how-to-unnest-wider-with-loop-over-all-the-columns-containing-lists
#'
#' @param df the dataframe that came from the json file
#' @importFrom magrittr %>%
#' @importFrom purrr keep
#' @importFrom tidyr unnest
#' @importFrom tidyr unnest_wider
#' @keywords internal
#'
#' @return the R object containing the unnested dataframe
unnest_all <- function(df) {
  list_columns <- df %>% purrr::keep(is.list) %>% names()
  
  if (length(list_columns) == 0) {
    return(df)
  }
  
  for (list_column in list_columns) {
    df <-
      df %>%
      tidyr::unnest_wider(list_column, names_sep = "_")
  }
  unnest_all(df)
}