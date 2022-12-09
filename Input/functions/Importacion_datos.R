#Importación de los datos
# *
library(readr)
Muerte_niños_semana <- read_delim("Input/data/Muerte_niños_semana.csv", 
                                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Muerte_niños_semana)
# *
library(readxl)
Encuesta_nacional_2017 <- read_excel("Input/data/Encuesta_nacional_2017.xlsx", 
                                     sheet = "Hoja1")
<<<<<<< HEAD
View(Encuesta_nacional_2017)
=======
>>>>>>> af3e5aa98e59b440e9b28de4b5c6fa2e6870b56b
