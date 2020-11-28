library(data.table)
library(text2vec)


## Common crawl and wikipedia fasttext vector file
file <- "https://fasttext.cc/docs/en/crawl-vectors.html"
fasttext_file <- "crawl-300d-2M.vec"
fasttext_vectors <- fread(fasttext_file, header = FALSE, quote = "")
fasttext_vectors <- as.matrix(fasttext_vectors, rownames = "V1")
head(fasttext_vectors)

similar_words <- function(harm_word, vector_object, min_similarity = 0.5, top_num = 25) {
  if (!(harm_word %in% rownames(vector_object))) return(data.frame(harm_word = character(),
                                                                   word = character(),
                                                                   similarity = numeric(),
                                                                   stringsAsFactors = FALSE))
  harm <- vector_object[harm_word, , drop = FALSE]
  cos_sim <- sim2(x = vector_object, y = harm, method = "cosine", norm = "l2")
  outputs <- sort(cos_sim[,1], decreasing = TRUE)
  similar_words <- outputs[1:top_num]
  return(similar_words)
}

similar_words("cancer", fasttext_vectors, top_num = 50)

