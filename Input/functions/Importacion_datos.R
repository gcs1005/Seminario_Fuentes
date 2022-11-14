#Importación de los datos
# *
library(readr)
Muerte_niños_semana <- read_delim("Input/data/02022.csv", 
                                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Muerte_niños_semana)

# *
library(readxl)
ENS_2017 <- read_excel("Trabajo_DAG/Input/data/ENSE17_MOD3_REL (1).xlsx")
View(ENS_2017)
