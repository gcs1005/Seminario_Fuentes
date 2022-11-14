#IMportación de los datos de causas de muerte en niños de un semana, un arvhivo
#CSV delimitado por puntos y comas

library(readr)
Causas_de_muerte_en_ninos_de_una_semana <- read_delim("Input/data/02022.csv", 
delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(Causas_de_muerte_en_ninos_de_una_semana)

library(dplyr)
x1<-Causas_de_muerte_en_ninos_de_una_semana %>%
  group_by(`Comunidades y Ciudades Autónomas`, Sexo) %>%
  select(Total)%>%
  summarise(suma_total = sum(Total)
  )
x1
x2<-na.omit(x1)
x2
x3<-filter(x2,Sexo=="Ambos sexos")
x3
#Importacion excel
library(readxl)
ENSE17_MOD3_REL_1_ <- read_excel("Input/data/ENSE17_MOD3_REL (1).xlsx", 
                                 sheet = "Tabla 3.069")
View(ENSE17_MOD3_REL_1_)

x1_01<-ENSE17_MOD3_REL_1_ %>%
  slice(.data= ENSE17_MOD3_REL_1_, 51:69 ) %>%
  rename(
    nivel_alto=...3,nivel_moderado=...4,nivel_bajo=...5
  )


# Carga de paquetes -------------------------------------------------------
library(dplyr)

# Filtrado datos niños muertos: Ambos sexos por CCAA----------------------------------------------------------
x1 <- 
  Muerte_niños_semana %>%
  group_by(`Comunidades y Ciudades Autónomas`, Sexo) %>%
  select(Total) %>%
  summarise(
    suma_total = sum(Total)
  )

x2 <- na.omit(x1)

muertes_CCAA <- filter(x2, Sexo == "Ambos sexos")
muertes_CCAA #Visualizamos el filtrado

# Filtrado datos deportes: Mujeres por CCAA y su nivel de act.física-------------------------------------------




