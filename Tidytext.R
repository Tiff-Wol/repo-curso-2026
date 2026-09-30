install.packages("tidyverse")
library(tidyverse)
install.packages("janeaustenr")
library(janeaustenr)
library(dplyr)
library(stringr)

austen_books()
original_books <- austen_books() |>
  group_by(book) |>
  mutate(
    line = row_number(),
    chapter = cumsum(str_detect(
      text,
      regex("^chapter [\\divxlc]", ignore_case = TRUE) #es una expresion regular, debe cumplir con tal condicion
    ))
  ) |>
  ungroup()

original_books



install.packages("tidytext")
library(tidytext)
tidy_books <- original_books |>
  unnest_tokens(output = word, input = text)

tidy_books

cleaned_books <- tidy_books |>
  anti_join(get_stopwords())

#extraigo los pensamientos positivos

positive <- get_sentiments("bing") |>
  filter(sentiment == "positive")

tidy_books |> colnames()
tidy_books 
  


tidy_books |>
  filter(book == "Emma") |>
  semi_join(positive) |>
  count(word, sort = TRUE)

install.packages("tidyr")
library(tidyr)
bing <- get_sentiments("bing")


janeaustensentiment <- 
  tidy_books |>
  inner_join(bing, relationship = "many-to-many") |>
  #agarro y calculo sentimiento de 80 palabras
  count(book, index = line %/% 80, sentiment) |>
  #filas a columnas con pilot wider
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) |>
  #genera columna
  mutate(sentiment = positive - negative)

janeaustensentiment|>print(n=500)

library(ggplot2)

ggplot(janeaustensentiment, aes(index, sentiment, fill = book)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(vars(book), ncol = 2, scales = "free_x")#para cada categoria me da un grafico
 
#palabras positivas y negativas en comun
bing_word_counts <- tidy_books |>
  inner_join(bing, relationship = "many-to-many") |>
  count(word, sentiment, sort = TRUE)

bing_word_counts
bing_word_counts |>
  group_by(sentiment) |>
  slice_max(n, n = 10) |>
  mutate(word = reorder(word, n)) |>
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(vars(sentiment), scales = "free_y") +
  labs(x = "Contribution to sentiment", y = NULL)


install.packages("wordcloud")
library(wordcloud)

library(wordcloud)

cleaned_books |>
  count(word) |>
  with(wordcloud(word, n, max.words = 100))




PandP_sentences <- 
  tibble(text = prideprejudice) |>
  unnest_tokens(output = sentence, 
                input = text, token = "sentences")


PandP_sentences$sentence[2]



austen_chapters <- 
  austen_books() |>
  group_by(book) |>
  unnest_tokens(
    chapter,
    text,
    token = "regex",
    pattern = "Chapter|CHAPTER [\\dIVXLC]"
  ) |>
  ungroup()

austen_chapters |>
  group_by(book) |>
  summarise(chapters = n())


bingnegative <- get_sentiments("bing") |>
  filter(sentiment == "negative")

wordcounts <- tidy_books |>
  group_by(book, chapter) |>
  summarize(words = n())


bingnegative <- get_sentiments("bing") |>
  filter(sentiment == "negative")

wordcounts <- tidy_books |>
  group_by(book, chapter) |>
  summarize(words = n())

tidy_books |>
  semi_join(bingnegative) |>
  group_by(book, chapter) |>
  summarize(negativewords = n()) |>
  left_join(wordcounts, by = c("book", "chapter")) |>
  mutate(ratio = negativewords / words) |>
  filter(chapter != 0) |>
  slice_max(ratio, n = 1)



## 3. Análisis de la frecuencia de palabras y documentos: tf-idf -----------

library(dplyr)
library(janeaustenr)
library(tidytext)

book_words <- austen_books() %>%
  unnest_tokens(word, text) %>%
  count(book, word, sort = TRUE)

total_words <- book_words %>% 
  group_by(book) %>% 
  summarize(total = sum(n))

book_words <- left_join(book_words, total_words)

book_words


library(ggplot2)

ggplot(book_words, aes(n/total, fill = book)) +
  geom_histogram(show.legend = FALSE) +
  xlim(NA, 0.0009) +
  facet_wrap(~book, ncol = 2, scales = "free_y")



freq_by_rank <- book_words %>% 
  group_by(book) %>% 
  mutate(rank = row_number(), 
         term_frequency = n/total) %>%
  ungroup()


freq_by_rank %>% 
  ggplot(aes(rank, term_frequency, color = book)) + 
  geom_line(linewidth = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()

freq_by_rank

rank_subset <- freq_by_rank %>% 
  filter(rank < 500,
         rank > 10)

lm(log10(term_frequency) ~ log10(rank), data = rank_subset)

freq_by_rank %>% 
  ggplot(aes(rank, term_frequency, color = book)) + 
  geom_abline(intercept = -0.62, slope = -1.1, 
              color = "gray50", linetype = 2) +
  geom_line(linewidth = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()


# 3.2 ---------------------------------------------------------------------

freq_by_rank <- book_words %>% 
  group_by(book) %>% 
  mutate(rank = row_number(), 
         term_frequency = n/total) %>%
  ungroup()

freq_by_rank


freq_by_rank %>% 
  ggplot(aes(rank, term_frequency, color = book)) + 
  geom_line(linewidth = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()


rank_subset <- freq_by_rank %>% 
  filter(rank < 500,
         rank > 10)

lm(log10(term_frequency) ~ log10(rank), data = rank_subset)


freq_by_rank %>% 
  ggplot(aes(rank, term_frequency, color = book)) + 
  geom_abline(intercept = -0.62, slope = -1.1, 
              color = "gray50", linetype = 2) +
  geom_line(linewidth = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()



# 3.3 ---------------------------------------------------------------------

book_tf_idf <- book_words %>%
  bind_tf_idf(word, book, n)

book_tf_idf

book_tf_idf %>%
  select(-total) %>%
  arrange(desc(tf_idf))

library(forcats)

book_tf_idf %>%
  group_by(book) %>%
  slice_max(tf_idf, n = 15) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, fct_reorder(word, tf_idf), fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL)



# 3.4 ---------------------------------------------------------------------
install.packages("gutenbergr")

library(gutenbergr)
physics <- gutenberg_download(c(37729, 14725, 13476, 30155), 
                              meta_fields = "author")

physics_words <- physics %>%
  unnest_tokens(word, text) %>%
  count(author, word, sort = TRUE)

physics_words


plot_physics <- physics_words %>%
  bind_tf_idf(word, author, n) %>%
  mutate(author = factor(author, levels = c("Galilei, Galileo",
                                            "Huygens, Christiaan", 
                                            "Tesla, Nikola",
                                            "Einstein, Albert")))

plot_physics %>% 
  group_by(author) %>% 
  slice_max(tf_idf, n = 15) %>% 
  ungroup() %>%
  mutate(word = reorder(word, tf_idf)) %>%
  ggplot(aes(tf_idf, word, fill = author)) +
  geom_col(show.legend = FALSE) +
  labs(x = "tf-idf", y = NULL) +
  facet_wrap(~author, ncol = 2, scales = "free")


library(stringr)

physics %>% 
  filter(str_detect(text, "_k_")) %>% 
  select(text)

physics %>% 
  filter(str_detect(text, "RC")) %>% 
  select(text)

mystopwords <- tibble(word = c("eq", "co", "rc", "ac", "ak", "bn", 
                               "fig", "file", "cg", "cb", "cm",
                               "ab", "_k", "_k_", "_x"))

physics_words <- anti_join(physics_words, mystopwords, 
                           by = "word")

plot_physics <- physics_words %>%
  bind_tf_idf(word, author, n) %>%
  mutate(word = str_remove_all(word, "_")) %>%
  group_by(author) %>% 
  slice_max(tf_idf, n = 15) %>%
  ungroup() %>%
  mutate(word = fct_reorder(word, tf_idf)) %>%
  mutate(author = factor(author, levels = c("Galilei, Galileo",
                                            "Huygens, Christiaan",
                                            "Tesla, Nikola",
                                            "Einstein, Albert")))

ggplot(plot_physics, aes(tf_idf, word, fill = author)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~author, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL)
