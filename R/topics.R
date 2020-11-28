## topic model
library(pacman)
p_load(topicmodels, tidyverse, udpipe)
#source("R/data_import.R")

abstracts_all <- abstracts_all %>%
  mutate(absText = paste(title, absText))

anno <- annotate_abstracts(abstracts_all$absText, abstracts_all$pmid)
np <- abstract_nounphrases(anno)
topics <- abstract_topics(np, k = 20)

topic <- topics$scores %>%
  mutate(topic = ifelse(nchar(topic) > 1, paste0("topic_0", topic), paste0("topic_00", topic))) %>%
  select(doc_id, topic)


terms <- topics$terms %>%
  enframe() %>%
  unnest("value") %>%
  group_by(name) %>%
  select(-prob) %>%
  mutate(topic_terms = paste(term, collapse = ", ")) %>%
  select(-term) %>%
  distinct()

final_abs <- topic %>%
  left_join(terms, by = c("topic"  = "name")) %>%
  left_join(abstracts_all, by = c("doc_id" = "pmid"))

final_abs %>%
  count(topic_terms)
