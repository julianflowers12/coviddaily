## arxiv covid
url <- "https://arxiv.org/search/advanced?advanced=&terms-0-operator=AND&terms-0-term=COVID-19&terms-0-field=title&terms-1-operator=OR&terms-1-term=SARS-CoV-2&terms-1-field=abstract&terms-3-operator=OR&terms-3-term=COVID-19&terms-3-field=abstract&terms-4-operator=OR&terms-4-term=SARS-CoV-2&terms-4-field=title&terms-5-operator=OR&terms-5-term=coronavirus&terms-5-field=title&terms-6-operator=OR&terms-6-term=coronavirus&terms-6-field=abstract&classification-physics_archives=all&classification-include_cross_list=include&date-filter_by=all_dates&date-year=&date-from_date=&date-to_date=&date-date_type=submitted_date&abstracts=show&size=200&order=-announced_date_first&source=home-covid-19"
url1 <- paste0(url, "&start=", c(200, 400, 600, 800, 1000, 1200))
urls <- as.character(c(url , url1))
source("R/get_arxiv_abstracts.R")
library(tidyverse)
library(xml2)

get_page_links(url) %>%
  .[grepl("abs",.)] %>%
  .[11:200]



get_arxiv <- function(url){
  require(rvest)
  require(httr)
  require(xml2)
  pages <- read_html(url) %>%
  html_nodes(".arxiv-result") %>%
  html_text() %>%
  stringr::str_squish()

  pages
}


test <- map(urls, get_arxiv) %>%
  map_dfr(., data.frame)

test %>%
  filter(is.na(date)) %>%
  View()
