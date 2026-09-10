# ==============================================================================
# TAREA 03: VISUALIZACIÓN DE DATOS CON GGPLOT2
# Basado en R for Data Science (2da ed.) - Capítulo 1: Data Visualization
# ==============================================================================

# Instalar y cargar los paquetes
install.packages("tidyverse")
library(tidyverse)

install.packages("palmerpenguins")
library(palmerpenguins)

install.packages("ggthemes")
library(ggthemes)


# Primeros pasos ----------------------------------------------------------

#explorar el dataset
penguins
?penguins #ayua para saber sobre el dataset
glimpse(penguins)#Muestra una vista previa rápida del dataframe

#creacion de un gráfico ggplot
ggplot(data = penguins)     #se crea un lienzo en blanco

#agrego mapping para definir variables, X largo de aleta e Y masa corporal
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)     #aes mapea que variables seran los ejes o sus atributos visuales
)

#agrego geom_point para añadir capa de puntos, geom es con que represento los datos, geom point para dispersion
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()

#agrego color y estetica segun las especies
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point()

#geom smoth agrega una línea de tendencia. Al especificar method = "lm", dibuja una regresión lineal.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  geom_smooth(method = "lm")


#Como queremos que los puntos se coloreen según la especie, pero no queremos que las líneas se separen para ellas, debemos especificarlo solo color = species para geom_point().
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")


#Además del color, agrego por formas las especies con shape
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")



#agrego labs (etiquetas) para el título, subtítulo, ejes y leyendas)
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()



# Ejercicios --------------------------------------------------------------

#1.¿Cuántas filas tiene penguins? ¿Cuántas columnas?
#para esto uso el comando penguins, y me sale que tiene 344 filas y 8 columnas
  
#2.¿Qué describe la bill_depth_mmvariable en el penguinsmarco de datos? Consulta la ayuda para ?

#consulto con ?penguins y dice que describe "a number denoting bill depth (millimeters)"

#3. Crea un diagrama de dispersión de bill_depth_mm vs.  bill_length_mm. Es decir, crea un diagrama de dispersión con bill_depth_mmen el eje y y bill_length_mmen el eje x. Describe la relación entre estas dos variables.

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(mapping = aes(color = species)) +
  labs(x = "Largo del pico (mm)", y = "Profundidad del pico (mm)",
       title = "Bill depth vs. Bill length")

#4.¿Qué sucede si haces un diagrama de dispersión de species vs.  bill_depth_mm? ¿Cuál podría ser una mejor opción de geom?
ggplot(penguins, aes(x = species, y = bill_depth_mm)) +
  geom_boxplot(mapping = aes(color = species)) +
  labs(x = "Especie", y = "Profundidad del pico (mm)",
       title = "Profundidad del pico por especie")

#5.¿Por qué se produce el siguiente error y cómo lo solucionarías?

# ggplot(data = penguins) + geom_point() da error porque falta especificar las variables a graficar en aes(). Para solucionarlo, se debe agregar mapping = aes(x = variable_x, y = variable_y) dentro de geom_point() o dentro de ggplot().

#6.¿Qué hace el na.rmargumento en geom_point()? ¿Cuál es el valor predeterminado del argumento? Crea un diagrama de dispersión donde uses correctamente este argumento configurado en TRUE.

#el argumento na.rm en geom_point() indica si se deben eliminar los valores NA antes de graficar. El valor predeterminado es FALSE, lo que significa que los valores NA no se eliminan y pueden causar errores o advertencias. Para usarlo correctamente, se puede configurar na.rm = TRUE dentro de geom_point().
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(na.rm = TRUE) + labs(x = "Largo de la aleta (mm)", y = "Masa corporal (g)",
       title = "Diagrama de dispersión con na.rm = TRUE")

#7.Añade el siguiente título al gráfico que hiciste en el ejercicio anterior: “Los datos provienen del paquete palmerpenguins”. Sugerencia: Consulta la documentación de labs().
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(na.rm = TRUE) + labs(x = "Largo de la aleta (mm)", y = "Masa corporal (g)",
                                  title = "Los datos provienen del paquete palmerpenguins")

#8. Recrea la visualizacion
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = bill_depth_mm)) +
  geom_smooth() #geom smooth se usa para agregar una línea de tendencia al gráfico, mostrando la relación general entre las variables.

#9. me va a mostrar la relación entre el largo de la aleta y la masa corporal de los pingüinos, con los puntos coloreados según las islas. 
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)

# se ven iguales porque usa todo lo mismo por mas ue cambie el orden de los argumentos, pero es una buena práctica mantener un orden consistente para mejorar la legibilidad del código.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )


# 1.3 llamadas a ggplot2 --------------------------------------------------

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()

#más concisa
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()

#aca se usa el pipe para pasar el dataframe penguins a ggplot, lo que permite encadenar operaciones de manera más legible y funcional.
penguins |> 
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()


# 1.4 VISUALIZACION DE DISTRIBUCIONES -------------------------------------

#CATEGORICA
#uso geom_bar() para crear un gráfico de barras que muestra la distribución de las especies de pingüinos en el conjunto de datos. Cada barra representa la cantidad de observaciones para cada especie.
ggplot(penguins, aes(x = species)) +
  geom_bar()


#uso fct_infreq() para reordenar las especies en el eje x según su frecuencia, de manera que la especie más frecuente aparezca primero. Esto mejora la legibilidad del gráfico al mostrar las especies en orden descendente de frecuencia.
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

#NUMERICA
#uso geom_histogram() para crear un histograma que muestra la distribución de la masa corporal de los pingüinos.
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

#con binwidth = 200, se establece el ancho de cada barra del histograma en 200 gramos, lo que permite visualizar la distribución de la masa corporal con mayor detalle.
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 2000)

#usar geom_density muestra la densidad como un espaguetti
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()


# Ejercicios 1.4.3 --------------------------------------------------------------
#1.Crea un gráfico de barras speciesde penguins, donde asignas speciesa la yestética. ¿En qué se diferencia este gráfico?

ggplot(penguins, aes(y = species)) +
  geom_bar() +
  labs(y = "Especies de pingüinos", title = "Distribución de especies de pingüinos")

#2.¿En qué se diferencian los dos gráficos siguientes? ¿Qué estética, coloro fill, es más útil para cambiar el color de las barras?
#usar fill es mejor para cambiar el color de las barras, ya que afecta el interior de las barras, mientras que color cambia el borde de las barras.
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")

#3.¿Qué hace el bins argumento geom_histogram()?
#bins determina el número de barras (o "bins") en el histograma. Un mayor número de bins proporciona una representación más detallada de la distribución, mientras que un menor número de bins ofrece una visión más general.
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(bins = 300) +
  labs(x = "Masa corporal (g)", title = "Histograma de masa corporal de pingüinos")

#4. Crea un histograma de la caratvariable en el diamondsconjunto de datos disponible al cargar el paquete tidyverse. Experimenta con diferentes anchos de intervalo. ¿Qué ancho de intervalo revela los patrones más interesantes?
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1) +
  labs(x = "Carat", title = "Histograma de Carat de Diamantes")

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.8) +
  labs(x = "Carat", title = "Histograma de Carat de Diamantes")


# 1.5 VISUALIZACION DE RELACIONES -----------------------------------------

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)


# 1.5.2 Dos variables categóricas -----------------------------------------
#visualizo la relación entre dos variables categóricas, island y species, en el conjunto de datos penguins. Cada barra representa la cantidad de observaciones para cada combinación de isla y especie.
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

#visualizo la proporción de especies dentro de cada isla. Al establecer position = "fill", las barras se normalizan para que tengan la misma altura, lo que permite comparar las proporciones relativas de especies en cada isla.
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")

#visualizo la proporción de especies dentro de cada isla, y agrego etiquetas a los ejes y un título al eje y para indicar que se trata de proporciones.
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") +
  labs(y = "proportion")


# 1.5.3 Dos variables numéricas -------------------------------------------

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

# 1.5.4 Tres o más variables ----------------------------------------------

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

#uso facet_wrap() para crear subgráficos separados para cada isla, lo que permite comparar la relación entre el largo de la aleta y la masa corporal de los pingüinos en diferentes islas.
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)


# 1.5.5 Ejercicios --------------------------------------------------------

?mpg
#categoricas son manufacturer, model, trans, drv, fl, class y las numericas son displ, year, cyl, cty, hwy
glimpse(mpg)

#2
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, color = year)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, size = year)) +
  geom_point() 

ggplot(mpg, aes(x = displ, y = hwy, color = year, size = year)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, shape = year)) +        
  geom_point()
#este ultimo da error

#el color es más útil para representar la variable year en este caso, ya que permite distinguir visualmente los puntos según el año de fabricación del vehículo. El tamaño puede ser menos efectivo, especialmente si hay muchos puntos superpuestos, lo que dificulta la interpretación de la relación entre las variables.


#3.En el diagrama de dispersión de hwyvs.  displ, ¿qué sucede si asignas una tercera variable a linewidth?

ggplot(mpg, aes(x = displ, y = hwy, linewidth = year)) +
  geom_point()

#4. sin cambios

#5. Se observa que dentro de cada grupo la relación es en realidad positiva (a mayor largo de pico, mayor profundidad)
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(na.rm = TRUE)

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(na.rm = TRUE) +
  facet_wrap(~ species) #separa por especies en distintos graficos

#6.para arreglar la separacion puedo poner el mismo título idéntico tanto a color como a shape dentro de la función labs()
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species )) +
  geom_point() +
  labs(color = "Species")

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species)) +
  geom_point() +
  labs( color = "Species",shape = "Species")

#7.la primera me muestra la proporción de especies dentro de cada isla, mientras que la segunda me muestra la proporción de islas dentro de cada especie. La elección entre estas dos visualizaciones depende del enfoque que se quiera dar al análisis: si se quiere comparar la distribución de especies en cada isla o la distribución de islas para cada especie.
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")


# 1.6 Guardar tus parcelas ------------------------------------------------

#uso ggsave() para guardar el gráfico actual en un archivo. El argumento filename especifica el nombre del archivo de salida, y la extensión del archivo determina el formato (por ejemplo, .png, .pdf, .jpg).
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
ggsave(filename = "penguin-plot.png")


# 1.6.1 Ejercicios --------------------------------------------------------
#el segundo se guarda como "mpg-plot.png" porque usa ggsave
ggplot(mpg, aes(x = class)) +
  geom_bar()

ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()

#2. cambio el nombre del archivo a "mpg-plot.pdf" para guardar el gráfico en formato PDF.
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.pdf")

ggsave("mpg-plot.png")
