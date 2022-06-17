## script for pubmed abstracts for covid in 2020 - full extract
## search srategy based on SOP - have excluded non human articles

library(pacman)
p_load(tidyverse, myScrapers, languageserver)
here::set_here()
#source("pubmedAbstractR.R")

## initialise

q <- "(COVID-19[All Fields] OR COVID-2019[All Fields] OR 2019-nCoV[All Fields] OR SARS-Cov-2[All Fields] OR (Wuhan[tiab] AND coronavirus[tiab]) OR (novel[tiab] AND coronavirus[tiab]) OR ((china OR chinese) AND coronavirus) NOT (Comment [ptyp] OR Editorial [ptyp] OR News [ptyp]) NOT animals[mh]"
key <- "bd86b3e3500c581cbc6ee0896f551bae0408"
start <- 2020
end <- 2021

pubtest <- pubmedAbstractR(search = q, start = start, end = end, ncbi_key = key, n = 1)

pubmed_extract <- pubmedAbstractR(search = q, start = start, end = end, ncbi_key = key, n = pubtest$n_articles)




# pubmed_extract$abstracts %>%
#   write_csv(., paste0("data/full_extract_to_", Sys.Date(), ".csv"))

# pubmed_extract$abstracts %>%
#   filter(pubDate >= "2020-01-01") %>%
#   count(pubDate) %>%
#   ggplot(aes(pubDate, n)) +
#   geom_col() +
#   labs(title = paste("Daily Pubmed COVID publications from 1st Jan 2020 to", format(Sys.Date(), "%d %B %Y"))) +
#   theme(plot.title.position = "plot") +
#   ggsave(paste0("coviddaily/daily_covid_pubs_", Sys.Date(), ".png"))

