  ## word similarity

similar_words <- function(sim_word, vector_object, min_similarity = 0.5, top_num = 25) {
  if (!(sim_word %in% rownames(vector_object))) return(data.frame(sim_word = character(),
                                                                   word = character(),
                                                                   similarity = numeric(),
                                                                   stringsAsFactors = FALSE))
  sim <- vector_object[sim_word, , drop = FALSE]
  cos_sim <- sim2(x = vector_object, y = sim, method = "cosine", norm = "l2")
  outputs <- sort(cos_sim[,1], decreasing = TRUE)
  similar_words <- outputs[1:top_num]
  return(similar_words)
}


## create word vectors with text2vec

create_word_vec <- function(abstracts){

  require(text2vec)
  require(dplyr)


  ## clean
  abstracts <- str_remove_all(abstracts, '\\n|"|$')
  abstracts <- tolower(abstracts)
  abstracts <- tm::removeWords(abstracts, stopwords("en"))
  abstracts <- tm::removeNumbers(abstracts)
  abstracts <- tm::removePunctuation(abstracts)


  # Create iterator over tokens
  tokens = space_tokenizer(abstracts)
  # Create vocabulary. Terms will be unigrams (simple words).
  it = itoken(tokens, progressbar = FALSE)
  vocab = create_vocabulary(it)

  vocab = prune_vocabulary(vocab, term_count_min = 5L)
  vectorizer = vocab_vectorizer(vocab)
  # use window of 5 for context words
  tcm = create_tcm(it, vectorizer, skip_grams_window = 8L)

  glove = GlobalVectors$new(rank = 100, x_max = 10)
  wv_main = glove$fit_transform(tcm, n_iter = 100, convergence_tol = 0.01, n_threads = 8)
  wv_context = glove$components
  word_vectors = wv_main + t(wv_context)

out <- list(clean_abstracts = abstracts, vocab = vocab, word_vectors = word_vectors)

}


library(tm)

m <- get_rxiv()

test2vec <- create_word_vec(m$abstracts)
glimpse(test2vec)

test <- test2vec$word_vectors["covid", , drop = FALSE]
str(test)

test

cos_sim <- sim2(x = test2vec, y = test, method = "cosine", norm = "l2")
outputs <- sort(cos_sim[,1], decreasing = TRUE)
similar_words <- outputs[1:top_num]

cos_sim <- textstat_simil(x = as.dfm(test2vec), y = as.dfm(test),
                          method = "cosine")
head(sort(cos_sim[, 1], decreasing = TRUE), 40)

similar_words("ace", test2vec$word_vectors)



mortality <- test2vec["symptoms", , drop = FALSE]
cos_sim = sim2(x = test2vec, y = mortality, method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 20)
