## get daily update of medrxiv from json feed


get_latest_medRxiv <- function(){

library(tidyverse)
library(jsonlite)
library(lubridate)
library(tictoc)


json <- "https://connect.medrxiv.org/relate/collection_json.php?grp=181"

cat("Please wait...")

tic()
abs_json <- jsonlite::read_json(json, simplifyVector = TRUE)
abs_df <- abs_json$rels %>%
  mutate(authors = map(rel_authors, "author_name")) %>%
  select(-rel_authors)

abs_df_1 <- abs_df %>%
  unnest("authors") %>%
  group_by(rel_doi) %>%
  mutate(author = paste(authors, collapse = ", ")) %>%
  select(-authors) %>%
  distinct() %>%
  mutate(rel_date = lubridate::ymd(rel_date))

plot <- abs_df_1 %>%
  ungroup() %>%
  count(rel_date) %>%
  filter(rel_date >= "2020-01-01") %>%
  ggplot(aes(rel_date, n)) +
  geom_col() +
  geom_smooth(method = 'gam', se  = FALSE) +
  labs(title = paste("Daily medrxiv/biorxiv COVID publications to: ",  format(Sys.Date(), "%d %B %Y") )) +
  theme(plot.title.position = "plot")

latest_medrxiv <- abs_df_1 %>%
  filter(rel_date >= lubridate::today() - lubridate::days(5))
toc()
out <- list(latest_medRxiv = latest_medrxiv, plot = plot)

}

