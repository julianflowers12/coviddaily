## covid tweets

covid_tweets <- function(){

library(rtweet)
library(tidyverse)
library(lubridate)

q <- "coronavirus.data.gov.uk"

tweets <- search_tweets(q, n = 3000, include_rts = FALSE)

plot <- tweets %>%
  mutate(date = lubridate::floor_date(created_at, "day")) %>%
  count(date) %>%
  ggplot(aes(date, n)) +
  geom_col()

out <- list(plot = plot, tweets = tweets )

}

ct <- covid_tweets()

ct$tweets$text

ct$plot

select(tweets, hashtags) %>%
  unnest(cols = c(hashtags)) %>%
  mutate(hashtags = tolower(hashtags)) %>%
  count(hashtags, sort=TRUE)

lookup_users(unique(tweets$user_id))

library(igraph)
library(hrbrthemes)
library(ggraph)
library(tidyverse)

import_roboto_condensed()

# same as previous recipe
filter(tweets, retweet_count > 0) %>%
  select(screen_name, mentions_screen_name) %>%
  unnest(mentions_screen_name) %>%
  filter(!is.na(mentions_screen_name)) %>%
  graph_from_data_frame() -> rt_g

V(rt_g)$node_label <- unname(ifelse(degree(rt_g)[V(rt_g)] > 4, names(V(rt_g)), ""))
V(rt_g)$node_size <- unname(ifelse(degree(rt_g)[V(rt_g)] > 4, degree(rt_g), 0))

ggraph(rt_g, layout = 'linear', circular = TRUE) +
  geom_edge_arc(edge_width=0.125, aes(alpha=..index..)) +
  geom_node_label(aes(label=node_label, size=node_size),
                  label.size=0, fill="#ffffff66", segment.colour="springgreen",
                  color="slateblue", repel=TRUE, fontface="bold") +
  coord_fixed() +
  scale_size_area(trans="sqrt") +
  labs(title="Retweet Relationships", subtitle="Most retweeted screen names labeled. Darkers edges == more retweets. Node size == larger degree") +
  theme_graph() +
  theme(legend.position="none")


library(rtweet)
library(LSAfun)
library(jerichojars) # hrbrmstr/jerichojars
library(jericho) # hrbrmstr/jericho

stiles <- get_timeline("stiles")

filter(stiles, str_detect(urls_expanded_url, "nyti|reut|wapo|lat\\.ms|53ei")) %>%  # only get tweets with news links
  pull(urls_expanded_url) %>% # extract the links
  flatten_chr() %>% # mush them into a nice character vector
  head(3) %>% # get the first 3
  map_chr(~{
    httr::GET(.x) %>% # get the URL (I'm lazily calling "fair use" here vs check robots.txt since I'm suggesting you do this for your benefit vs profit)
      httr::content(as="text") %>%  # extract the HTML
      jericho::html_to_text() %>% # strip away extraneous HTML tags
      LSAfun::genericSummary(k=3) %>% # summarise!
      paste0(collapse="\n\n") # easier to see
  }) %>%
  walk(cat)

D <- "This is just a test document. It is set up just to throw some random
sentences in this example. So do not expect it to make much sense. Probably, even
the summary won't be very meaningful. But this is mainly due to the document not being
meaningful at all. For test purposes, I will also include a sentence in this
example that is not at all related to the rest of the document. Lions are larger than cats."

LSAfun::genericSummary(D, k = 2)

influence_snapshot <- function(user, trans=c("log10", "identity")) {

  user <- user[1]
  trans <- match.arg(tolower(trimws(trans[1])), c("log10", "identity"))

  user_info <- lookup_users(user)

  user_followers <- get_followers(user_info$user_id)
  uf_details <- lookup_users(user_followers$user_id)

  primary_influence <- scales::comma(sum(c(uf_details$followers_count, user_info$followers_count)))

  filter(uf_details, followers_count > 0) %>%
    ggplot(aes(followers_count)) +
    geom_density(aes(y=..count..), color="lightslategray", fill="lightslategray",
                 alpha=2/3, size=1) +
    scale_x_continuous(expand=c(0,0), trans="log10", labels=scales::comma) +
    scale_y_comma() +
    labs(
      x="Number of Followers of Followers (log scale)",
      y="Number of Followers",
      title=sprintf("Follower chain distribution of %s (@%s)", user_info$name, user_info$screen_name),
      subtitle=sprintf("Follower count: %s; Primary influence/reach: %s",
                       scales::comma(user_info$followers_count),
                       scales::comma(primary_influence))
    ) +
    theme_ipsum_rc(grid="XY") -> gg

  print(gg)

  return(invisible(list(user_info=user_info, follower_details=uf_details)))

}
 influence_snapshot("juliasilge")
