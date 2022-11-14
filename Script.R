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
#utilizar funcion str() para ver el nombre de las columnas, y solo queda 
#utilizar la función rename(), y cambiar su nombre a nivel bajo,moderado y alto


x1_01<-ENSE17_MOD3_REL_1_ %>%
  slice(.data= ENSE17_MOD3_REL_1_, 51:69 ) %>%
  rename(
    nivel_alto=...3,nivel_moderado=...4,nivel_bajo=...5
  )