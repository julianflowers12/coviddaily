install.packages("europepmc")
library("languageserver")
library(pacman)

library(europepmc)
p_load(myScrapers, tidytext, tidyverse, Rcpp)
source("R/pubmedAbstractR.R")

search <- "covid mask systematic[sb]"
ncbi_key <- "bd86b3e3500c581cbc6ee0896f551bae0408"
start <- 2020
end <- 2021
n <- 66

result <- pubmedAbstractR(
    search = search,
    n = n,
    ncbi_key = ncbi_key,
    start = start,
    end = end
    )

result$abstracts

summary <- result$abstracts  %>% 
    group_by(pmid) |>
    unnest_tokens(sent, abstract, "sentences") |>
    count(pmid) |>
    filter(n > 2) |>
    left_join(result$abstracts) |>
    mutate(summ = map(abstract, text_summariser)) |>
    unnest("summ")

summary  %>% 
    select(-abstract)  %>% 
    DT::datatable()



europepmc::epmc_details(34161818)    