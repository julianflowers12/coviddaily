## abstract topic visualisation


abstract_topic_viz <-function(x, m, scores, n = 1){


library(igraph)
library(ggraph)
library(ggplot2)
library(qgraph)

n = n
x <- x %>%
  mutate(topic_id = as.character(topic_id))

x_topic <- x %>% left_join(scores, by = c("doc_id" = "doc_id"))
topicterminology <- predict(abs_topics$model, type = "terms", min_posterior = 0.05, min_terms = 20)
termcorrs <- filter(x_topic, topic %in% n & lemma %in% topicterminology[[n]]$term)
termcorrs <- document_term_frequencies(termcorrs, document = "topic_id", term = "lemma")
termcorrs <- document_term_matrix(termcorrs)
termcorrs <- dtm_cor(termcorrs)
termcorrs[lower.tri(termcorrs)] <- NA
diag(termcorrs) <- NA
library(qgraph)
qgraph(termcorrs, layout = "spring", labels = colnames(termcorrs), directed = FALSE,
       borders = FALSE, label.scale = FALSE, label.cex = 1, node.width = 0.5)

}



