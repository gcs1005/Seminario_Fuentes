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


ejercicio_mujeres_comunidad<-
  Encuesta_nacional_2017 %>%
  slice(.data=.,2:20) %>% 
  rename(
    nivel_alto=...3,nivel_moderado=...4,nivel_bajo=...5
  )
ejercicio_mujeres_comunidad

#Union de ambas tablas
#Busco un atributo común a ambas set de datos
attributes(muertes_CCAA)
attributes(ejercicio_mujeres_comunidad)
#Si que presenan un atributo pero no con el mismo nombre, uno se llama 
#"Comunidades y Ciudades Autónomas" y el otro "Mujeres"
#De forma que vamos a cambiar el nombre del atributo perteneciente al data_set:
#ejercicio_mujeres_comunidad
ejercicio_mujeres_comunidad<-
  ejercicio_mujeres_comunidad %>% 
  rename( "Comunidades y Ciudades Autónomas" =MUJERES) %>% 
  mutate("Comunidades y Ciudades Autónomas"=factor("Comunidades y Ciudades Autónomas",across()))
ejercicio_mujeres_comunidad
?acr
#Species <-
#   Species %>% 
#   mutate(Island = factor(Island, levels = c("Pinzón", "Santa Cruz","Santa Fé", "Seymour" )))



#Una vez tenemos ambas tablas hacemos un left_join, que por defecto realizará un 
#natural join al no especificar las columnas a unir

union_tablas<-left_join(x=ejercicio_mujeres_comunidad,y=muertes_CCAA)
union_tablas
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


ejercicio_mujeres_comunidad<-
  Encuesta_nacional_2017 %>%
  slice(.data=.,2:20) %>% 
  rename(
    nivel_alto=...3,nivel_moderado=...4,nivel_bajo=...5
  )
ejercicio_mujeres_comunidad

#Union de ambas tablas
#Busco un atributo común a ambas set de datos
attributes(muertes_CCAA)
attributes(ejercicio_mujeres_comunidad)
#Si que presenan un atributo pero no con el mismo nombre, uno se llama 
#"Comunidades y Ciudades Autónomas" y el otro "Mujeres"
#De forma que vamos a cambiar el nombre del atributo perteneciente al data_set:
#ejercicio_mujeres_comunidad
muertes_CCAA<-
  muertes_CCAA %>%
  mutate(.data=.,"Comunidades y Ciudades Autónomas"=ejercicio_mujeres_comunidad$MUJERES)
muertes_CCAA

#Comprobamos los levels

levels(muertes_CCAA$`Comunidades y Ciudades Autónomas`)
levels(ejercicio_mujeres_comunidad$MUJERES)

#Species <-
#   Species %>% 
#   mutate(Island = factor(Island, levels = c("Pinzón", "Santa Cruz","Santa Fé", "Seymour" )))
?mutate


#Una vez tenemos ambas tablas hacemos un left_join, que por defecto realizará un 
#natural join al no especificar las columnas a unir

union_tablas<-left_join(x=ejercicio_mujeres_comunidad,y=muertes_CCAA)
union_tablas

