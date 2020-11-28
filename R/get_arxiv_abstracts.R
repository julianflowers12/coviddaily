## get arxiv abstracts

get_arxiv <- function(url){
  require(rvest)
  require(httr)
  require(xml2)
  pages <- read_html(url) %>%
    html_nodes(".arxiv-result") %>%
    html_text() %>%
    stringr::str_squish()

pages <- pages %>%
  enframe() %>%
  mutate(val = map(value, unlist)) %>%
  unnest("val") %>%
  mutate(arXiv = str_extract(val, "arXiv:\\d{4}.\\d{5}"),
         date = str_extract(val, "[Ss]ubmitted\\s\\d{1,}.*\\d{4};"),
         date = str_remove(date, "[Ss]ubmitted"),
         date = tm::removePunctuation(date),
         date = tm::stripWhitespace(date),
         date = lubridate::dmy(date))
pages

}
