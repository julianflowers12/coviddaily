## script for pubmed abstracts for covid in 5 day extract
## search srategy based on SOP - have excluded non human articles
get_recent_pubmed <- function(){


library(pacman)
p_load(tidyverse, myScrapers)
#source("R/pubmedAbstractR.R")


key <- Sys.getenv("ncbi_key")

d <- Sys.Date()
d <- d %>%
  str_replace_all(., "-", "/") %>%
  as.character()

d4 <- Sys.Date() - 4
d4 <- d4 %>%
  str_replace_all(., "-", "/") %>%
  as.character()

d3 <- Sys.Date() - 3
d3 <-d3 %>%
  str_replace_all(., "-", "/") %>%
  as.character()

d2 <- Sys.Date() - 2
d2<- d2 %>%
  str_replace_all(., "-", "/") %>%
  as.character()

d1 <- Sys.Date() - 1
d1 <- d1 %>%
  str_replace_all(., "-", "/") %>%
  as.character()

start = 2020
end = 2020

key <- Sys.getenv("ncbi_key")

q <- "(COVID-19[All Fields] OR COVID-2019[All Fields] OR 2019-nCoV[All Fields] OR SARS-Cov-2[All Fields] OR (Wuhan[tiab] AND coronavirus[tiab]) OR (novel[tiab] AND coronavirus[tiab]) OR ((china OR chinese) AND coronavirus) NOT (Comment [ptyp] OR Editorial [ptyp] OR News [ptyp]) NOT animals[mh]"
dates <- paste0("(", d, "[crdt] OR ", d1, "[crdt] OR ", d2, "[crdt] OR ", d3, "[crdt] OR ", d4, "[crdt]", ")")
s <- paste(q, dates)

pubtest1 <- pubmedAbstractR(search = s, start = start, end = end, ncbi_key = key, n = 1)

pubmed_extract_5 <- pubmedAbstractR(search = s, start = start,  end = end, ncbi_key = key, n = pubtest1$n_articles)

}


