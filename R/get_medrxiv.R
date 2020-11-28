## get medrxiv and biorxiv abstracts on covid from https://connect.medrxiv.org/relate/content/181

get_medrxiv <- function(url){

  require(jsonlite)
  require(dplyr)
  require(purrr)
  require(tidyr)

  json <- "https://connect.medrxiv.org/relate/collection_json.php?grp=181"

  abs_json <- jsonlite::read_json(json, simplifyVector = TRUE)

  abs_df <- abs_json$rels %>%
    mutate(authors = purrr::map(rel_authors, "author_name")) %>%
    select(-rel_authors)

  abs_df_1 <- abs_df %>%
    tidyr::unnest("authors") %>%
    group_by(rel_doi) %>%
    mutate(author = paste(authors, collapse = ", ")) %>%
    select(-authors) %>%
    distinct() %>%
    mutate(rel_date = lubridate::ymd(rel_date))

  out <- list(abstracts = abs_df_1)

}



