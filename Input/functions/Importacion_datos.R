#Importación de los datos
# *
library(readr)
Muerte_niños_semana <- read_delim("Input/data/Muerte_niños_semana.csv", 
                                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Muerte_niños_semana)

# *
library(readxl)
<<<<<<< HEAD
Encuesta_nacional_2017 <- read_excel("Input/data/Encuesta_nacional_2017.xlsx", 
                                     sheet = "Hoja1")
View(Encuesta_nacional_2017)
=======
ENS_2017 <- read_excel("Input/data/Encuesta_nacional_2017.xlsx")
View(ENS_2017)

#intento eliminar el merge
>>>>>>> 78f4e12aeff9d4b5cffc12b877cd1050354134b2
