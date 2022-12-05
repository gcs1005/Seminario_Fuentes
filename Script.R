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

#Aunque primero vamos a forzar que tengan los mismos datos, en realidad si que
#los tienen pero uno presenta los characteres en miñúsculas y el otro en 
#mayúsculas

muertes_CCAA$`Comunidades y Ciudades Autónomas`<- toupper(muertes_CCAA$`Comunidades y Ciudades Autónomas`)
muertes_CCAA

#ahora cambiamos el nombre del set de datos ejercicio_mujeres_comunidad
ejercicio_mujeres_comunidad<-
  ejercicio_mujeres_comunidad %>% 
  rename( "Comunidades y Ciudades Autónomas" =MUJERES)

#Comprobamos los levels

levels(factor(muertes_CCAA$`Comunidades y Ciudades Autónomas`))
levels(factor(ejercicio_mujeres_comunidad$"Comunidades y Ciudades Autónomas"))



#Una vez tenemos ambas tablas hacemos un left_join, que por defecto realizará un 
#natural join al no especificar las columnas a unir

union_tablas<-left_join(x=ejercicio_mujeres_comunidad,y=muertes_CCAA)
union_tablas

#gracias a la unión mediante left_join, observamos que la comunidad autónoma 
#de CATALUÑA es distinta en un set de datos y otro uno teniendo ñ y otro 
#teniendo otro carácter.
muertes_CCAA$`Comunidades y Ciudades Autónomas`[9]<-"CATALUÑA"
muertes_CCAA

#OBTENCION DE DATOS DE LOS NACIMIENTOS POR COMUNIDAD AUTÓNOMA
#Natalidad_2021 <- read.delim("clipboard")
#visualizamos su estructura para observar lo que nos interesa
str(Natalidad_2021)
#Es la columna de nacidos
Natalidad_2021$Nacidos

#Como solo nos interesa la columna de nacidos y los nombres de las CCAA estan
#desordenados, creamos un dataframe

Natalidad<-data.frame( `Comunidades y Ciudades Autónomas` =muertes_CCAA$`Comunidades y Ciudades Autónomas`,
                       
                       nacimientos=c(65522,9095,4771,9455,13178,3407,14738,13652,58464,843,35761,7380,15247,52357,962,13706,5036,14743,2318))
#Cambiamos valor de la posición 9 de la columna Comunidades.y.Ciudades.Autónomas

Natalidad$Comunidades.y.Ciudades.Autónomas[9]<-"CATALUÑA"



#una vez obtenidos los datos de número de nacimientos por comunidad autónoma, #creamos una nueva columna, que relacione la cantidad de niños muertos por #comunidad sobre la cantidad de nacimientos por comunidad en porcentaje sobre #100.
str(muertes_CCAA)
str(Natalidad)

muertes_CCAA<-
  left_join(muertes_CCAA,Natalidad,by=c("Comunidades y Ciudades Autónomas"="Comunidades.y.Ciudades.Autónomas")) %>% 
  mutate(.data = ., muertes_comunidad_porcentaje = (suma_total /nacimientos)*100)

?left_join
?across

union_tablas<-left_join(x=ejercicio_mujeres_comunidad,y=muertes_CCAA)
union_tablas

#Gráficos:
#Cargamos el paquete ggplot2 y tidyverse
library(ggplot2)
library(tidyverse)

#Gráfico de muertes de niños por Comunidad Autónoma
ggplot(data = muertes_CCAA, aes(x = reorder(muertes_CCAA$`Comunidades y Ciudades Autónomas`,muertes_CCAA$muertes_comunidad_porcentaje), y = muertes_CCAA$muertes_comunidad_porcentaje))+
  geom_bar(stat = "identity",fill="brown",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()+
  theme_bw()+
  labs(x="Comunidades Autónomas",y="Muertes porcentaje",title ="Muertes de niños por Comunidad Autónoma",subtitle = "Porcentajes de muertes de menores de una semana en función del total de nacimientos de cada Comunidad Autónoma")


