remotes::install_github("njahn82/semscholar")
library(semscholar)
library(tidyverse)
library(rvest)
s2 <- s2_papers(
  c("10.1093/nar/gkr1047",
             "14a22b032524573d15593abed170f9f76359e581", 
             "10.7717/peerj.2323", 
             "arXiv:0711.0914")
  )
glimpse(s2) 



base <- "https://www.semanticscholar.org/search?q=large%20blue%20butterfly&sort=relevance&pdf=true"
search_term <- "large blue butterfly uk"
search_term <- str_replace_all(search_term, "\\s", "%20")
search_term
url <- glue::glue("https://www.semanticscholar.org/search?q=", {search_term}, "&sort=relevance&pdf=true")
url
browseURL(url)

pages <- read_html(url)  %>% html_nodes(".cl-paper-title") %>% html_text()
pages