library(pacman)
p_load(myScrapers, tidyverse, text2vec, quanteda, rvest, data.table, tictoc, tidytext)
## fetches med and biorxiv

source("R/data_import.R")

corp <- corpus(final_abs, text_field = "absText")

abs_toks = tokens(corp)

feats <- dfm(abs_toks, verbose = TRUE) %>%
  dfm_trim(min_termfreq = 2) %>%
  featnames()

abs_toks <- tokens_select(abs_toks, feats, padding = TRUE)

glove <- GlobalVectors$new(rank = 50, x_max = 10)

abs_fcm <- fcm(abs_toks, context = "window", count = "weighted", weights = 1 / (1:5), tri = TRUE)


wv_main <- glove$fit_transform(abs_fcm, n_iter = 100,
                               convergence_tol = 0.01, n_threads = 6)

wv_context <- glove$components

word_vectors <- wv_main + t(wv_context)

test <- word_vectors["COVID", , drop = FALSE] +
  word_vectors["corona", , drop = FALSE]

test

cos_sim <- textstat_simil(x = as.dfm(word_vectors), y = as.dfm(test),
                          method = "cosine")
head(sort(cos_sim[, 1], decreasing = TRUE), 40)


