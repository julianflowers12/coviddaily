## model for predicting categories

classify_abstracts_1 <- function(df){

  require(quanteda)
  require(quanteda.textmodels)
  require(dplyr)

  model <- readRDS("data/model_svm_1.rds")
  training <- readRDS("data/new_training.rds")

  abstracts <- df %>%
    dplyr::mutate(absText = paste(title, abstract))

  corp <- corpus(abstracts, text_field = "absText")

  dfm <- dfm(corp, remove = stopwords("en"), remove_punct = TRUE, stem = TRUE)

  dfm_matched <- dfm_match(dfm, features = featnames(training))

  pred <- predict(model, newdata = dfm_matched)
  pm <- data.frame(abstracts, class1 = pred)

}


