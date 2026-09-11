# ==============================================================================
# TAREA 04: TRANSFORMACION DE DATOS
# Basado en R for Data Science (2da ed.) - Capítulo 3
# ==============================================================================

# 3.1 INTRO ---------------------------------------------------------------


install.packages("nycflights13")
library(nycflights13)
install.packages("tidyverse")
library(tidyverse)

flights
?flights

View(flights) #me muestra la tabla de datos en una ventana aparte
print(flights, width = Inf) #me muestra la tabla de datos en la consola complet
glimpse (flights) #me muestra la tabla de datos en la consola de manera resumida

flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE) ) # el simbolo |>, es el operador pipe, que permite encadenar varias funciones de manera legible y concisa. En este caso, se filtran los vuelos con destino a "IAH", se agrupan por año, mes y día, y luego se calcula el retraso promedio de llegada (arr_delay) para cada grupo, ignorando los valores NA.


# FILAS -------------------------------------------------------------------
#filter() es una función que se utiliza para seleccionar filas de un data frame que cumplen con ciertas condiciones. La sintaxis básica de filter() es la siguiente: filter(data, condition1, condition2, ...). Donde data es el data frame que se desea filtrar y condition1, condition2, ... son las condiciones que deben cumplirse para que una fila sea seleccionada.
flights |> 
  filter(dep_delay > 120) # filtra los vuelos con retraso en la salida mayor a 120 minutos

flights |> 
  filter(month == 1 & day == 1) # filtra los vuelos del 1 de enero

flights |> 
  filter(month == 1 | month == 2) # filtra los vuelos del mes 1 o 2

flights |> 
  filter(month %in% c(1, 2)) # filtra los vuelos del mes 1 o 2
#el comando %in% es un operador que se utiliza para verificar si un valor está presente en un vector o conjunto de valores. En este caso, se utiliza para filtrar los vuelos que tienen un mes igual a 1 o 2.

jan1 <- flights |>  filter(month == 1 & day == 1) #uso <- para asignar el resultado del filtro a un objeto llamado jan1

flights |>  filter(month = 1) #error porque usa = en lugar de == para comparar valores. El operador = se utiliza para asignar valores a variables, mientras que == se utiliza para comparar valores.

#arrange() es una función que se utiliza para ordenar las filas de un data frame según una o más columnas. La sintaxis básica de arrange() es la siguiente: arrange(data, column1, column2, ...). Donde data es el data frame que se desea ordenar y column1, column2, ... son las columnas por las que se desea ordenar. Por defecto, arrange() ordena de manera ascendente, pero se puede utilizar la función desc() para ordenar de manera descendente.
flights |> 
  arrange(year, month, day, dep_time) #aca ordena los vuelos por año, mes, día y hora de salida (dep_time) de manera ascendente.flights |> 


# distint se usa para eliminar filas duplicadas de un data frame. La sintaxis básica de distinct() es la siguiente: distinct(data, column1, column2, ...). Donde data es el data frame del que se desea eliminar filas duplicadas y column1, column2, ... son las columnas que se desean considerar para determinar si una fila es duplicada o no. Si no se especifican columnas, distinct() eliminará filas duplicadas considerando todas las columnas del data frame.
flights |>  distinct()

flights |> distinct(origin, dest) # elimina filas duplicadas considerando solo las columnas origin y dest

flights |> distinct(origin, dest, .keep_all = TRUE)
#se utiliza el argumento .keep_all = TRUE para mantener todas las columnas del data frame original en el resultado, incluso si se eliminan filas duplicadas. Si no se especifica este argumento, distinct() solo devolverá las columnas que se utilizaron para determinar la duplicidad.

flights |> count(origin, dest, sort = TRUE)
# se utiliza la función count() para contar el número de vuelos para cada combinación de origen y destino, y se ordena el resultado de manera descendente utilizando el argumento sort = TRUE. Esto permite identificar rápidamente las rutas más populares en el conjunto de datos de vuelos.


# 3.2.5 EJERCICIOS --------------------------------------------------------

#1
#retraso de mas de 2 horas
flights |> filter(arr_delay >= 120)
#Voló a Houston ( IAHo HOU)
flights |> filter(dest %in% c("IAH", "HOU"))
#Compañías aéreas específicas
flights |> filter(carrier %in% c("UA", "AA", "DL"))
#Partió en verano (julio, agosto y septiembre).
flights |> filter(month %in% 7:9)
#Vuelos con retraso en la llegada mayor a 2 horas y sin retraso en la salida
flights |> filter(arr_delay > 120, dep_delay <= 0)
#Vuelos con retraso en la salida mayor a 1 hora y diferencia positiva entre retraso en salida y llegada
flights |> filter(dep_delay >= 60, dep_delay - arr_delay > 30)


#2
flights |> arrange(desc(dep_delay)) #ordena los vuelos por retraso en la salida de manera descendente
flights |> arrange(dep_time) #ordena los vuelos por hora de salida de manera ascendente

#3 encuentra los vuelos más rápidos
flights |> arrange(distance / air_time) 

#4 hubo vuelos todos los dias en 2013?
flights |> count(year, month, day) |> nrow() == 365

#5 ¿Qué vuelos recorrieron la mayor distancia? ¿Cuáles recorrieron la menor distancia?
# Mayor distancia
flights |> filter(distance == max(distance, na.rm = TRUE))

# Menor distancia
flights |> filter(distance == min(distance, na.rm = TRUE)) 

#6 orden en que se usan filter()y arrange()
#El orden no altera el resultado final, pero conviene filtrar primero para reducir filas y al usar arrange ordene más rapido


# 3.3 COLUMNAS ------------------------------------------------------------
#MUTATE
#usar mutate sirve para poner columnas con data de filas existentes, pone de lado derecho
flights |> mutate( gain = dep_delay - arr_delay, speed = distance / air_time * 60 )
#si uso before () las pone del izq
flights |>  mutate( gain = dep_delay - arr_delay, speed = distance / air_time * 60,
                    .before = 1)
#el punto indica que before es argumento
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

#al usar keep controlo variables, y used las columns que estan involucradas
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used" 
  )

#SELECT
flights |>  select(year, month, day) #seleccione las columnas 
flights |> select(year:day) #selecciona columnas en tal rango
flights |> select(!year:day) #Selecciona todas las columnas excepto las que van desde el año hasta el día de hoy 
flights |> select(where(is.character)) #selecciona las columnas con caracter
?select

#puedo renombrar las variables
flights |> select(tail_num = tailnum)


# RENAME -------------------------------------------------------------------
flights |>  rename(tail_num = tailnum) #para cambiar nombre de algunas variables


# RELOCATE ----------------------------------------------------------------
#uso relocate() para organizar variables en este caso por hora
flights |> 
  relocate(time_hour, air_time)

flights |> 
  relocate(year:dep_time, .after = time_hour)
flights |> 
  relocate(starts_with("arr"), .before = dep_time)


# 3.3.5 EJERCICIOS --------------------------------------------------------

#1. sched_dep_time: Hora programada de salida.
#dep_delay: Retraso en minutos (positivo si salió tarde, negativo si salió adelantado).
#dep_time: Hora real en la que despegó el avión.

#2
flights |> 
  select(dep_time, dep_delay, arr_time, arr_delay)

#3 Ignora a los duplicados
flights |> 
  select(dep_time, dep_delay, dep_time)
# Devuelve solo las columnas dep_time y dep_delay (en ese orden).

#4 para que sirve any of
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
#any of sirve para seleccionar columnas que cumplan con cierta condición

#5
flights |> select(contains("TIME"))
#el resultado esta bien porque contains no distingue entre min y mayusculas

#6 cambie el nombre de la columna air_time a air_time_min y la reubique al final del data frame.
  rename(air_time_min = air_time) |> 
  relocate(air_time_min)

#7 no funciona porque select(tailnum) descarta todas las columnas del dataset excepto tailnum. Cuando el código intenta ejecutar arrange(arr_delay), la variable arr_delay ya no existe en la tabla.
  flights |> 
    select(tailnum) |> 
    arrange(arr_delay)

# 3.4 LA TUBERIA ----------------------------------------------------------
#me indica los vuelos más rápidos al aeropuerto IAH de Houston
  flights |> 
    filter(dest == "IAH") |> 
    mutate(speed = distance / air_time * 60) |> 
    select(year:day, dep_time, carrier, flight, speed) |> 
    arrange(desc(speed))
  
  arrange(
    select(
      mutate(
        filter(
          flights, 
          dest == "IAH"
        ),
        speed = distance / air_time * 60
      ),
      year:day, dep_time, carrier, flight, speed
    ),
    desc(speed)
  )

  flights1 <- filter(flights, dest == "IAH")
  flights2 <- mutate(flights1, speed = distance / air_time * 60)
  flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
  arrange(flights3, desc(speed)) 
  

# 3.5 GRUPOS --------------------------------------------------------------

# group_by() es una función que se utiliza para agrupar filas de un data frame según una o más columnas. 
  flights |> 
    group_by(month)
  
#summarize() es una función que se utiliza para calcular estadísticas resumidas de un data frame agrupado. 
  flights |> 
    group_by(month) |> 
    summarize(
      avg_delay = mean(dep_delay))
  
#uso na.rm = TRUE para ignorar los valores NA 
flights |> 
    group_by(month) |> 
    summarize(
      avg_delay = mean(dep_delay, na.rm = TRUE))

# uso n() para contar el número de filas en cada grupo

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n())


# FUNCION SLICE -----------------------------------------------------
#uso slice() para seleccionar filas específicas de un data frame agrupado.
flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |>
  relocate(dest)
#uso daily para agrupar los vuelos por año, mes y día
daily <- flights |>  
  group_by(year, month, day)
daily

#DESAGRUPACION
#ungroup() es una función que se utiliza para desagrupar un data frame que ha sido previamente agrupado con group_by().
daily |> 
  ungroup()

#Se obtiene una sola fila porque dplyr trata todas las filas de un marco de datos no agrupado como si pertenecieran a un solo grupo.
daily |> 
ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    flights = n())

#.BY es una variable especial que se utiliza dentro de la función summarize() para hacer referencia a las columnas que se utilizaron para agrupar el data frame.
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = month
  )

flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  )


# 3.5.7 Ejercicios --------------------------------------------------------

#1 ¿Qué aerolínea tiene los peores retrasos promedio? Desafío: ¿puedes diferenciar los efectos de los aeropuertos deficientes de los de las aerolíneas deficientes? 
flights |> group_by(carrier, dest) |> summarize(n())
flights |> 
  group_by(carrier) |> 
  summarize(
    promedio_dep_delay = mean(dep_delay, na.rm = TRUE),
    promedio_arr_delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  arrange(desc(promedio_arr_delay)) #la F9 es la que tiee mas retrasos de vuelos

#2 Encuentra los vuelos con mayor retraso en la salida hacia cada destino.
flights|> 
  group_by(dest) |> 
  slice_max(dep_delay, n = 1) |>
  relocate(dest)
#3 ¿Cómo varían los retrasos a lo largo del día? Ilustre su respuesta con un gráfico.
flights |> 
  group_by(hour) |> 
  summarize(prom_retraso = mean(arr_delay, na.rm = TRUE)) |> 
  ggplot(aes(x = hour, y = prom_retraso)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Evolución del retraso promedio según la hora de salida",
    x = "Hora de salida programada",
    y = "Retraso promedio en la llegada (min)"
  )

#4 usar slice me devuelve las 5 filas con mayor distancia y las 5 filas con menor distancia en este caso

flights |> 
  slice_max(distance, n = -5)

flights |> 
  slice_max(distance, n = 5)
 #5
#count() es una función que se utiliza para contar el número de ocurrencias de cada combinación única de valores en un data frame. 
# y sort (count()) es un argumento que se utiliza para ordenar el resultado de la función count() en orden descendente según el número de ocurrencias. Cuando se establece sort = TRUE, la función count() devuelve un data frame ordenado por la columna de conteo en orden descendente, lo que permite identificar rápidamente las combinaciones más frecuentes de valores en el data frame.)


#6
df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

#si lo uso con group by espero el resultado del mismo tamaño que el data frame original
#si utilizo arrange el resultado es un data frame ordenado según las columnas especificadas.
# si uso summarize(mean_x = mean(x)) me mostrara un data frame con una sola fila que contiene el valor promedio de la columna x para todo el data frame, en lugar de un resumen por grupo.
# si uso df |> group_by(y, z) |> summarize(mean_x = mean(x)) nos Nos da 3 filas (una para la combinación a-K, otra para a-L y otra para b-K).
# si uso df |> group_by(y, z) |> summarize(mean_x = mean(x), .groups = "drop") nos da 3 filas (una para la combinación a-K, otra para a-L y otra para b-K), pero el resultado no está agrupado por las columnas y y z.

#con summarize() se obtiene un resumen de los datos agrupados, mientras que con mutate() se agrega una nueva columna al data frame original con los valores calculados para cada grupo.
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))


# CONTINUAR ---------------------------------------------------------------


