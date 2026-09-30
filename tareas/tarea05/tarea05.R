
# Tarea 5: Minería de Texto - Artículos de McKinsey


# 1. Carga de Librerías ----------------------------------------------------
library(tidyverse)
library(tidytext)
library(topicmodels)
library(igraph)
library(ggraph)
library(wordcloud)
library(reshape2)
library(scales)

# 2. Lectura y preparación de la base --------------------------------------
# Cargamos los datos desde la carpeta correspondiente de la tarea
articles <- read_csv("data/DATA-T9-mckinsey-mind-the-gap-articles-20251020.csv")

# Ajustamos una estructura básica para trabajar cómodos con los identificadores y fechas
articles_procesados <- articles |>
  mutate(id = row_number(),
         year = year(date),
         article_text = article_text |>
           str_replace_all("’", "'") |>
           str_remove("^Brought to you by[^\n]*\n") |>
           str_remove(regex("Welcome to the latest edition of Mind the Gap.*?—Alex and Axel",
                            dotall = TRUE)))

# 3. Limpieza de palabras y tokenización ------------------------------------
# Pasamos el texto a formato token (una palabra por fila)
tokens_articulos <- articles_procesados |>
  unnest_tokens(output = word, input = article_text)

# Definimos términos específicos de ruido que aparecen en los artículos de McKinsey
firmas_autores <- c("partner", "partners", "senior", "managing", "coauthors", 
                    "aaron", "smet", "bryan", "hancock", "erica", "coe", 
                    "kweilin", "ellingrud", "brooke", "weddle", "bill", "schaninger",
                    "alex", "axel", "liz", "hilton", "segel", "hatami", "homayoun")

exclusiones_contexto <- tibble(word = c("gen", "z", "z's", "zers", "mckinsey", "percent"))

# Limpiamos sacando stop words, números y el vocabulario corporativo propio del corpus
palabras_limpias <- tokens_articulos |>
  anti_join(stop_words, by = "word") |>
  anti_join(exclusiones_contexto, by = "word") |>
  filter(!word %in% firmas_autores) |>
  filter(!str_detect(word, "^[0-9]+$"))

# Revisamos brevemente la longitud de los textos para ver si son comparables
largo_articulos <- tokens_articulos |> count(id, name = "total_palabras")
summary(largo_articulos$total_palabras)
# El rango intercuantil nos muestra que los artículos manejan extensiones similares.


# 4. Análisis exploratorio y TF-IDF ----------------------------------------
# Frecuencia simple de palabras en el corpus
frecuencia_palabras <- palabras_limpias |>
  count(word, sort = TRUE)

# Calculamos el TF-IDF para ver qué tan relevantes son los términos por cada artículo
articles_tfidf <- palabras_limpias |>
  count(id, title, word) |>
  bind_tf_idf(word, id, n) |>
  arrange(desc(tf_idf))

# Visualizamos las palabras con mayor peso específico
articles_tfidf |>
  slice_head(n = 15) |>
  mutate(word = reorder(word, tf_idf)) |>
  ggplot(aes(tf_idf, word, fill = as.factor(id))) +
  geom_col(show.legend = FALSE) +
  labs(title = "Términos más distintivos según TF-IDF",
       x = "TF-IDF", y = NULL) +
  theme_minimal()


# 5. Análisis de Sentimientos ---------------------------------------------
# A. Usando diccionario binario (Bing)
sentimientos_bing <- palabras_limpias |>
  inner_join(get_sentiments("bing"), by = "word", relationship = "many-to-many") |>
  count(id, date, year, title, sentiment) |>
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) |>
  mutate(balance_sentimiento = positive - negative)

# Gráfico de evolución temporal del sentimiento
ggplot(sentimientos_bing, aes(date, balance_sentimiento, fill = balance_sentimiento > 0)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(vars(year), scales = "free_x") +
  theme_minimal() +
  labs(title = "Evolución temporal del sentimiento (Diccionario Bing)",
       x = "Fecha", y = "Balance (Positivo - Negativo)")

# B. Usando diccionario graduado (Afinn)
sentimientos_afinn <- palabras_limpias |>
  inner_join(get_sentiments("afinn"), by = "word", relationship = "many-to-many") |>
  group_by(id, date, year, title) |>
  summarise(puntaje_afinn = sum(value), .groups = "drop")

# Con esto confirmamos si la tendencia general de los textos se alinea con tonos positivos.


# 6. Modelado de Tópicos (Topic Modeling - LDA) ---------------------------
# Armamos la Matriz Documento-Término
matriz_dtm <- palabras_limpias |>
  count(id, word) |>
  cast_dtm(document = id, term = word, value = n)

# Corremos los modelos LDA probando con k = 10 y k = 15
set.seed(1234)
lda_10 <- LDA(matriz_dtm, k = 10, control = list(seed = 1234))
lda_15 <- LDA(matriz_dtm, k = 15, control = list(seed = 1234))

# Visualizamos los términos principales del modelo con k = 10
top_terminos_10 <- tidy(lda_10, matrix = "beta") |>
  group_by(topic) |>
  slice_max(beta, n = 8) |>
  ungroup() |>
  mutate(term = reorder_within(term, beta, topic))

ggplot(top_terminos_10, aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free", ncol = 2) +
  scale_y_reordered() +
  theme_minimal() +
  labs(title = "Principales tópicos detectados en los artículos (k = 10)",
       x = "Probabilidad (beta)", y = NULL)


# 7. Análisis de Bigramas y Redes ------------------------------------------
# Generamos las parejas de palabras para entender asociaciones conceptuales
bigramas_corpus <- articles_procesados |>
  unnest_tokens(bigram, article_text, token = "ngrams", n = 2) |>
  separate(bigram, c("word1", "word2"), sep = " ")

bigramas_filtrados <- bigramas_corpus |>
  filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word) |>
  filter(!word1 %in% exclusiones_contexto$word, !word2 %in% exclusiones_contexto$word) |>
  filter(!word1 %in% firmas_autores, !word2 %in% firmas_autores)

conteo_bigramas <- bigramas_filtrados |>
  count(word1, word2, sort = TRUE)

# Armado de la red de bigramas frecuentes
red_asociacion <- conteo_bigramas |>
  filter(n > 5) |>
  graph_from_data_frame()

set.seed(2017)
ggraph(red_asociacion, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE) +
  geom_node_point(color = "darkcyan", size = 3) +
  geom_node_text(aes(label = name), repel = TRUE, size = 3) +
  theme_void() +
  labs(title = "Red de co-ocurrencia de palabras (Bigramas)")
