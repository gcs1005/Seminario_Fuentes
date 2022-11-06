library(dplyr)
x1<-Muerte_niños_semana %>%
  group_by(`Comunidades y Ciudades Autónomas`, Sexo) %>%
  select(Total) %>%
  summarise(
    suma_total = sum(Total)
  )
  na.omit(x1)
  
x1
x2<-na.omit(x1)
x2
x3<-filter(x2,Sexo=="Ambos sexos")
