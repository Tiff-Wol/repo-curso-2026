
# Tarea 5: Minería de Texto en R - Análisis de Artículos de McKinsey

# 0. Carga de Librerías necesarias --------------------------------------------
library(tidyverse)
library(tidytext)
library(topicmodels)
library(igraph)
library(ggraph)
library(wordcloud)
library(reshape2)
library(scales)

# 1. Carga y preparación inicial del corpus -----------------------------------
# Leo los datos directamente desde la carpeta del proyecto
mckinsey <- read_csv("data/DATA-T9-mckinsey-mind-the-gap-articles-20251020.csv")

# Renombro la primera columna para manejar con más comodidad los IDs de los artículos
mckinsey <- mckinsey |> 
  rename(id_articulo = `...1`)

# Hago un primer chequeo rápido de la estructura
glimpse(mckinsey)


# 2. Exploración y Descripción del Corpus (Basado en Cap. 1 y Cap. 3) ---------
# 2.1 Tokenización: desarmamos el texto para tener una palabra por fila
articulos_desmenuzados <- mckinsey |>
  select(id_articulo, date, article_text) |>
  unnest_tokens(output = word, input = article_text)

# 2.2 Limpieza y manejo de Stopwords personalizadas
# Excluimos palabras cortas clave que no queremos que borren los diccionarios por defecto
terminos_clave <- c("x", "y", "z", "ai", "gen")
stop_words_modificado <- stop_words |> 
  filter(!word %in% terminos_clave)

# Vector de ruido corporativo (nombres de autores, contracciones y términos repetitivos)
basura_corporativa <- c(
  "it's", "they're", "we're", "don't", "there's", "you're", "doesn't", "isn't", "that's", "here's", 
  "it’s", "they’re", "we’re", "don’t", "there’s", "you’re", "doesn’t", "isn’t", "that’s", "here’s", 
  "percent", "mckinsey", "mckinsey.com", "coauthors", "partner", "alex", "axel",
  "liz", "hilton", "segel", "chief", "client", "officer", "hatami", "homayoun", "managing"
)

# Filtro final de limpieza profunda
articulos_limpios <- articulos_desmenuzados |>
  anti_join(stop_words_modificado, by = "word") |>
  anti_join(tibble(word = basura_corporativa), by = "word") |>
  filter(!str_detect(word, "^[0-9]+$")) # Vuelo números sueltos

# 2.3 Evaluación de extensión y comparabilidad de los documentos
longitud_articulos <- articulos_limpios |>
  count(id_articulo, name = "total_palabras")

summary(longitud_articulos$total_palabras) # La mayoría ronda las mismas extensiones, son comparables

# 2.4 Nube de palabras general del corpus
articulos_limpios |>
  count(word) |>
  with(wordcloud(word, n, max.words = 100, random.order = FALSE, colors = "steelblue"))

# 2.5 Análisis de Frecuencia Inversa de Términos (tf-idf) - Capítulo 3
mckinsey_tfidf <- articulos_limpios |>
  count(id_articulo, word, sort = TRUE) |>
  bind_tf_idf(term = word, document = id_articulo, n = n)

# Gráfico de los términos con mayor tf-idf para ver la especificidad por notas
mckinsey_tfidf |>
  arrange(desc(tf_idf)) |>
  slice_head(n = 15) |>
  mutate(word = reorder(word, tf_idf)) |>
  ggplot(aes(tf_idf, word, fill = as.factor(id_articulo))) +
  geom_col(show.legend = FALSE) +
  labs(title = "Palabras con mayor TF-IDF en el corpus",
       x = "TF-IDF", y = NULL) +
  theme_minimal()


# 3. Análisis de Sentimiento (Basado en Capítulo 2) ----------------------------
# 3.1 Diccionario Binario (Bing: positivo vs negativo)
sentimiento_binario <- articulos_limpios |>
  inner_join(get_sentiments("bing"), by = "word", relationship = "many-to-many") |>
  count(id_articulo, sentiment) |>
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) |>
  mutate(sentimiento_neto = positive - negative)

# Nube de palabras comparativa de sentimientos
articulos_limpios |>
  inner_join(get_sentiments("bing"), by = "word", relationship = "many-to-many") |>
  count(word, sentiment, sort = TRUE) |>
  acast(word ~ sentiment, value.var = "n", fill = 0) |>
  comparison.cloud(colors = c("#F8766D", "#00BFC4"), max.words = 100)

# 3.2 Diccionario Graduado (AFINN: valor numérico de -5 a +5)
sentimiento_graduado <- articulos_limpios |>
  inner_join(get_sentiments("afinn"), by = "word", relationship = "many-to-many") |>
  group_by(id_articulo) |>
  summarise(sentimiento_neto_afinn = sum(value))

summary(sentimiento_graduado$sentimiento_neto_afinn)


# 4. Topic Modelling (Modelos LDA - Basado en Capítulo 6) -----------------------
# 4.1 Armamos la Matriz Documento-Término (DTM)
matriz_dtm <- articulos_limpios |>
  count(id_articulo, word) |>
  cast_dtm(document = id_articulo, term = word, value = n)

# 4.2 Entrenamos los modelos para k = 10 y k = 15 
set.seed(1234)
modelo_lda_10 <- LDA(matriz_dtm, k = 10, control = list(seed = 1234))
modelo_lda_15 <- LDA(matriz_dtm, k = 15, control = list(seed = 1234))

# 4.3 Extracción y Gráfico de probabilidades Beta (Términos más importantes por tópico) para k = 10
top_terminos_10 <- tidy(modelo_lda_10, matrix = "beta") |>
  group_by(topic) |>
  slice_max(beta, n = 5) |>
  ungroup() |>
  mutate(term = reorder_within(term, beta, topic))

ggplot(top_terminos_10, aes(x = beta, y = term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y", ncol = 2) +
  scale_y_reordered() +
  labs(title = "Términos principales por tópico (k = 10)",
       x = "Probabilidad (beta)", y = NULL) +
  theme_minimal()

# 4.4 Extracción de probabilidades Gamma (Distribución de tópicos en los documentos)
documentos_topicos_10 <- tidy(modelo_lda_10, matrix = "gamma")


# 5. AVANZADO: Relaciones entre palabras, Bigramas y Negaciones (Cap. 4) ------
# 5.1 Extracción de bigramas (parejas de palabras)
bigramas_separados <- mckinsey |>
  select(id_articulo, article_text) |>
  unnest_tokens(bigram, article_text, token = "ngrams", n = 2) |>
  separate(bigram, c("word1", "word2"), sep = " ")

# 5.2 Limpieza estricta de bigramas
bigramas_limpios <- bigramas_separados |>
  filter(!word1 %in% stop_words_modificado$word,
         !word2 %in% stop_words_modificado$word) |>
  filter(!word1 %in% basura_corporativa,
         !word2 %in% basura_corporativa) |>
  filter(!str_detect(word1, "^[0-9]+$"),
         !str_detect(word2, "^[0-9]+$"))

# 5.3 Red de bigramas frecuentes usando igraph y ggraph
red_bigramas <- bigramas_limpios |>
  count(word1, word2, sort = TRUE) |>
  filter(n > 5) |>
  graph_from_data_frame()

set.seed(1234)
ggraph(red_bigramas, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = grid::arrow(type = "closed", length = unit(2.5, "mm")),
                 end_cap = circle(3, "mm")) +
  geom_node_point(color = "steelblue", size = 4) +
  geom_node_text(aes(label = name), vjust = 1.5, hjust = 0.5) +
  theme_void() +
  labs(title = "Red de relaciones conceptuales (Bigramas)")

# 5.4 Análisis de negaciones ("not", "no", "never", "without") cruzado con AFINN
palabras_negacion <- c("not", "no", "never", "without")

bigramas_negados <- bigramas_separados |>
  filter(word1 %in% palabras_negacion) |>
  inner_join(get_sentiments("afinn"), by = c("word2" = "word")) |>
  count(word1, word2, value, sort = TRUE) |>
  mutate(contribucion = n * value)

# Gráfico del impacto de las negaciones
bigramas_negados |>
  head(15) |>
  mutate(word2 = reorder(word2, contribucion)) |>
  ggplot(aes(x = contribucion, y = word2, fill = contribucion > 0)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Impacto de las negaciones en el análisis de sentimiento",
       subtitle = "Palabras precedidas por negaciones evaluadas con AFINN",
       x = "Contribución (Frecuencia x Puntaje)",
       y = "Palabra negada") +
  theme_minimal()