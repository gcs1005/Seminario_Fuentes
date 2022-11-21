#Importación de los datos
# *
library(readr)
Muerte_niños_semana <- read_delim("Input/data/Muerte_niños_semana.csv", 
                                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Muerte_niños_semana)

# *
library(readxl)
ENS_2017 <- read_excel("Input/data/Encuesta_nacional_2017.xlsx")
View(ENS_2017)

#intento eliminar el merge
