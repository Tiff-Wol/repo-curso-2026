#TAREA 02: INTRODUCCIÓN A LA PROGRAMACIÓN EN R (BASE)


# Intro a R ---------------------------------------------------------------
7+7
#sintaxis
"Thank you so much!"
10
#funcion print para generar codigo
print("Thank you so much!")

#Acá se creo una fila del 1 al 10

for (x in 1:10) {
  print(x)
}


# Variables de R ----------------------------------------------------------

name <- "Tiffany" #la flecha es para asignar valor a la variable
age <- 22

#Concatenar texto con paste()----------------
text <- "maravilloso"

paste("R is", text)

#Sumar texto con paste()
text1 <- "R is"
text2 <- "maravilloso"

paste(text1, text2)

#Sumar los numeros con +
num1 <- 5
num2 <- 10

num1 + num2

#ESTO ES ERRONEO
num <- 5
text <- "Some text"

num + text

#Multiples Variables------------
#asigno el mismo valor a varias variables
var1 <- var2 <- var3 <- "Estrés" #al poner cada variable por separado lo verifico
var1
var2
var3


# TIPOS DE DATOS EN R -----------------------------------------------------

x <- 10.5            #NUMERICO
y <- 55

# me devuelve que valores son x e y
x
y
#me devuelve que tipo de dato es, en este caso numerico
class(x)
class(y)

x <- 1000            #ENTERO
y <- 55L

x <- 3+5i           #COMPLEJO
y <- 5i

#convertir los datos
x <- 1L # integer
y <- 2 # numeric

# convertir de entero a numerico:
a <- as.numeric(x)

# convertir de numerico a entero:
b <- as.integer(y)
x
y
class(a)
class(b)

#Matematicas en R ---------------------------
max(5, 10, 15)

min(5, 10, 15)

abs(-150)                      # Valor absoluto
sqrt(144)                      # Raíz cuadrada
ceiling(40.1)                  # Redondeo hacia arriba
floor(40.9)                    # Redondeo hacia abajo

#Cadenas de texto en R ----------------------
str <- "Hello"
str <- "Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt
ut labore et dolore magna aliqua."
str
cat(str) #cat() es para concatenar y mostrar en pantalla
nchar(str) #nchar() es para contar el numero de caracteres

str <- "Hello World!"

grepl("H", str)   #grepl() es para buscar un patron en una cadena de texto, devuelve TRUE o FALSE
grepl("Hello", str)
grepl("X", str)

str1 <- "Helado de"
str2 <- "Vainilla"

paste(str1, str2) #paste() es para concatenar cadenas de texto

str <- "We are the so-called \"Vikings\", from the north." #usar \ para escapar caracteres especiales

str
cat(str)


# VALORES BOOLEANOS -------------------------------------------------------

salario_mensual <- 450000
salario_anual <- salario_mensual * 13
salario_anual > 5000000
salario_anual<salario_mensual
a <- 200
b <- 33

if (b > a) {
  print ("b is greater than a")
} else {
  print("b is not greater than a")
}


# OPERADORES --------------------------------------------------------------

my_var <- 3 #se usa <- para asignar valor a la variable

3 -> my_var

my_var

# Operadores de comparación IF ELSE ---------------------------------------------

a <- 33
b <- 33

if (b > a) {
  print("b is greater than a")   #uso else if para evaluar otra condicion
} else if (a == b) {
  print ("a and b are equal")
}

a <- 200
b <- 33

if (b > a) {
  print("b is greater than a")   #uso else para cubrir otra condicion
} else if (a == b) {
  print("a and b are equal")
} else {                         
  print("a is greater than b")
}

x <- 41

if (x > 10) {
  print("Above ten")
  if (x > 20) {
    print("and also above 20!")
  } else {
    print("but not above 20.")
  }
} else {
  print("below 10.")
}

#uso & para evaluar dos condiciones al mismo tiempo
a <- 200
b <- 33
c <- 500

if (a > b & c > a) {
  print("Both conditions are true")
}

#uso | para evaluar si al menos una de las condiciones es verdadera
a <- 200
b <- 33
c <- 500

if (a > b | a > c) {
  print("At least one of the conditions is true")
}

#BUCLES - WHILE LOOP-------------------------------------------------------
#while se ejecuta mientras la condicion sea verdadera, si es falsa se detiene
i <- 1
while (i < 6) {
  print(i)
  i <- i + 1
}
#break se usa para salir del bucle cuando se cumple una condicion, en este caso cuando i es igual a 4
i <- 1
while (i < 6) {
  print(i)
  i <- i + 1
  if (i == 4) {
    break
  }
}

#next es para poder omitir una iteración sin terminar el bucle, en este caso cuando i es igual a 3
i <- 0
while (i < 6) {
  i <- i + 1
  if (i == 3) {
    next
  }
  print(i)
}

# Simulación: encuentra trabajo al mes 2
meses_busqueda <- 0
while (TRUE) {
  meses_busqueda <- meses_busqueda + 1
  if (meses_busqueda == 2) {
    print("¡Empleo encontrado!")
    break 
  }
}


# BUCLES FOR LOOP ---------------------------------------------------------
#for es para iterar una secuencia
for (x in 1:10) {
  print(x)
}
fruits <- list("apple", "banana", "cherry")
for (x in fruits) {print(x)}

fruits <- list("apple", "banana", "cherry")
for (x in fruits) {if (x == "cherry") {break} print(x)}

adj <- list("red", "big", "tasty")

fruits <- list("apple", "banana", "cherry")
for (x in adj) {
  for (y in fruits) {
    print(paste(x, y)) }}

my_function <- function() { print("Hello World!")}


# ESTRUCTURA DE DATOS EN R ------------------------------------------------

#Vectores, elementos del mismo tipo de datos, se crean con c()
edades_hogar <- c(45, 42, 16, 12)
print(edades_hogar)

# Vector con valores numericos uso de : para crear una secuencia de numeros
numbers <- 1:10
numbers

#uso de length() para obtener la longitud del vector
fruits <- c("banana", "apple", "orange")

length(fruits)

#uso de sort() para ordenar un vector
fruits <- c("banana", "apple", "orange", "mango", "lemon")
numbers <- c(13, 3, 5, 7, 20, 2)

sort(fruits)  # Sort a string
sort(numbers) # Sort a number

#uso corchetes [] para acceder a un elemento del vector, en este caso el primer elemento
fruits <- c("banana", "apple", "orange")
fruits[1]

#uso de corchetes [] para acceder a varios elementos del vector, en este caso el primer y tercer element
fruits <- c("banana", "apple", "orange", "mango", "lemon")
fruits[c(1, 3)]

fruits <- c("banana", "apple", "orange", "mango", "lemon")

# Change "banana" to "pear"
fruits[1] <- "pear"
# Print fruits
fruits

#para repetir elementos de un vector se usa rep()
repeat_each <- rep(c(1,2,3), each = 3)
repeat_each

repeat_indepent <- rep(c(1,2,3), times = c(5,2,1))
repeat_indepent

#uso seq() para crear una secuencia de numeros, en este caso del 0 al 100 de 20 en 20
numbers <- seq(from = 0, to = 100, by = 20)

numbers


# LISTAS ------------------------------------------------------------------

thislist <- list("apple", "banana", "cherry")
thislist

thislist <- list("apple", "banana", "cherry")
thislist[1]

thislist <- list("apple", "banana", "cherry")
thislist[1] <- "blackcurrant"
thislist

#uso %in% para verificar si un elemento esta en la lista, devuelve TRUE o FALSE
thislist <- list("apple", "banana", "cherry")

"apple" %in% thislist

#uso append() para agregar un elemento a la lista, en este caso "orange" al final de la lista
thislist <- list("apple", "banana", "cherry")

append(thislist, "orange")

#uso -1 para eliminar un elemento de la lista, en este caso el primer elemento "apple"
thislist <- list("apple", "banana", "cherry")

newlist <- thislist[-1]
newlist

#uso for loop para iterar sobre los elementos de la lista y imprimirlos
thislist <- list("apple", "banana", "cherry")

for (x in thislist) {
  print(x)}
  
#uso c() para combinar dos listas en una sola
  list1 <- list("a", "b", "c")
  list2 <- list(1,2,3)
  list3 <- c(list1,list2)
 list3
 

# MATRICES R --------------------------------------------------------------

 # Crear matriz usando matrix()
 thismatrix <- matrix(c(1,2,3,4,5,6), nrow = 3, ncol = 2)
 
 # Print the matrix
 thismatrix
 
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
 
 thismatrix
 
#uso de corchetes [] para acceder a un elemento de la matriz, en este caso el elemento en la primera fila y segunda columna
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
 
 thismatrix[1, 2]
 
#uso la coma para acceder a una fila o columna de la matriz, en este caso la segunda column
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
 
 thismatrix[,2]
 
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange","grape", "pineapple", "pear", "melon", "fig"), nrow = 3, ncol = 3)
 
 thismatrix[c(1,2),]
 
 #uso de cbind() para agregar una columna a la matriz, en este caso una columna con los valores "strawberry", "blueberry" y "raspberry"
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange","grape", "pineapple", "pear", "melon", "fig"), nrow = 3, ncol = 3)
 
 newmatrix <- cbind(thismatrix, c("strawberry", "blueberry", "raspberry"))
 
 newmatrix
 
#uso de rbind() para agregar una fila a la matriz, en este caso una fila con los valores "strawberry", "blueberry" y "raspberry"
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange","grape", "pineapple", "pear", "melon", "fig"), nrow = 3, ncol = 3)
 
 newmatrix <- rbind(thismatrix, c("strawberry", "blueberry", "raspberry"))
 
 newmatrix
 
#uso de -c() para eliminar una fila o columna de la matriz, en este caso la primera fila y la primera columna
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange", "mango", "pineapple"), nrow = 3, ncol =2)
 
 #Remove the first row and the first column
 thismatrix <- thismatrix[-c(1), -c(1)]
 
 thismatrix
 
#uso dim() para obtener las dimensiones de la matriz, en este caso el numero de filas y columnas
 thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
 
 dim(thismatrix)
 
 # Combine matrices
 Matrix1 <- matrix(c("apple", "banana", "cherry", "grape"), nrow = 2, ncol = 2)
 Matrix2 <- matrix(c("orange", "mango", "pineapple", "watermelon"), nrow = 2, ncol = 2)
 
 # Adding it as a rows
 Matrix_Combined <- rbind(Matrix1, Matrix2)
 Matrix_Combined
 
 # Adding it as a columns
 Matrix_Combined <- cbind(Matrix1, Matrix2)
 Matrix_Combined
 
 #uso de array() para crear un array, en este caso un array con los valores del 1 al 24 y dimensiones 4x3x2
 thisarray <- c(1:24)
 thisarray
 
 # An array with more than one dimension
 multiarray <- array(thisarray, dim = c(4, 3, 2))
 multiarray
 
 #uso de corchetes [] para acceder a un elemento del array, en este caso el elemento en la segunda fila, tercera columna y segunda capa
 thisarray <- c(1:24)
 multiarray <- array(thisarray, dim = c(4, 3, 2))
 
 multiarray[2, 3, 2]
 
 thisarray <- c(1:24)
 
 # Access all the items from the first row from matrix one
 multiarray <- array(thisarray, dim = c(4, 3, 2))
 multiarray[c(1),,1]
 
 # Access all the items from the first column from matrix one
 multiarray <- array(thisarray, dim = c(4, 3, 2))
 multiarray[,c(1),1]
 

# MARCOS DE DATOS ---------------------------------------------------------

 # Create a data frame
 Data_Frame <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 # Print the data frame
 Data_Frame
 
 #uso de summary() para obtener un resumen del data frame, en este caso el numero de filas, columnas y los tipos de datos de cada columna
 Data_Frame <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 Data_Frame
 
 summary(Data_Frame)
 
 Data_Frame <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 Data_Frame[1]
 
 Data_Frame[["Training"]]
 
 Data_Frame$Training
 
 #uso de rbind() para agregar una fila al data frame, en este caso una fila con los valores "Strength", 110 y 110
 Data_Frame <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 # Add a new row
 New_row_DF <- rbind(Data_Frame, c("Strength", 110, 110))
 
 # Print the new row
 New_row_DF
 
 #uso de cbind() para agregar una columna al data frame
 Data_Frame <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 # Add a new column
 New_col_DF <- cbind(Data_Frame, Steps = c(1000, 6000, 2000))
 
 # Print the new column
 New_col_DF
 
 #uso ncol y nrow para obtener el numero de columnas y filas del data frame
 Data_Frame <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 ncol(Data_Frame)
 nrow(Data_Frame)
 
 #uso rbind() para agregar una fila al data frame
 Data_Frame1 <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 Data_Frame2 <- data.frame (
   Training = c("Stamina", "Stamina", "Strength"),
   Pulse = c(140, 150, 160),
   Duration = c(30, 30, 20)
 )
 
 New_Data_Frame <- rbind(Data_Frame1, Data_Frame2)
 New_Data_Frame
 
 #uso cbind() para agregar una columna al data frame
 Data_Frame3 <- data.frame (
   Training = c("Strength", "Stamina", "Other"),
   Pulse = c(100, 150, 120),
   Duration = c(60, 30, 45)
 )
 
 Data_Frame4 <- data.frame (
   Steps = c(3000, 6000, 2000),
   Calories = c(300, 400, 300)
 )
 
 New_Data_Frame1 <- cbind(Data_Frame3, Data_Frame4)
 New_Data_Frame1
 

# FACTORES R --------------------------------------------------------------

 # Create a factor
 music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"))
 
 # Print the factor
 music_genre
 
 #uso levels() para obtener los niveles del factor, en este caso los generos musicales
 music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"), levels = c("Classic", "Jazz", "Pop", "Rock", "Other"))
 
 levels(music_genre)
 
 #uso length() para obtener la longitud del factor, en este caso el número de observaciones
 music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"))
 
 length(music_genre)
 
 #cambiar el valor de un elemento del factor, en este caso cambiar el tercer elemento de "Classic" a "Pop"
 music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"))
 
 music_genre[3] <- "Pop"
 
 music_genre[3]
 
 #cambiar el valor de un elemento del factor a un nivel que no existe, en este caso cambiar el tercer elemento de "Classic" a "Opera"
 music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"), levels = c("Classic", "Jazz", "Pop", "Rock", "Opera"))
 
 music_genre[3] <- "Opera"
 
 music_genre[3]
 
# Uso específico para datos categóricos de encuestas.
 vector_estados <- c("Ocupado", "Desocupado", "Inactivo", "Ocupado")
 estado_factor <- factor(vector_estados)
 
 
 #Visualización y manejo de los "Niveles".
 levels(estado_factor) # Devuelve: "Desocupado" "Inactivo" "Ocupado"

 
 