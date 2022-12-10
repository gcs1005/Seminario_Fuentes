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
    tamaño_muestral=...2,nivel_alto=...3,nivel_moderado=...4,nivel_bajo=...5
  )
ejercicio_mujeres_comunidad

# Union de ambas tablas----
#Busco un atributo común a ambos set de datos
attributes(muertes_CCAA)
attributes(ejercicio_mujeres_comunidad)
#Sí que presentan un atributo pero no con el mismo nombre, uno se llama 
#"Comunidades y Ciudades Autónomas" y el otro "Mujeres"
#De forma que vamos a cambiar el nombre del atributo perteneciente al data_set de
#ejercicio_mujeres_comunidad

#Aunque primero vamos a forzar que tengan los mismos datos, en realidad si que
#los tienen pero uno presenta los characteres en minúsculas y el otro en 
#mayúsculas

muertes_CCAA$`Comunidades y Ciudades Autónomas`<- toupper(muertes_CCAA$`Comunidades y Ciudades Autónomas`)
muertes_CCAA

#ahora si, cambiamos el nombre de MUJERES del set de datos ejercicio_mujeres_comunidad
#por Comunidades y Ciudades Autónomas para que coincidan con el de el set de datos muertes_CCAA
ejercicio_mujeres_comunidad<-
  ejercicio_mujeres_comunidad %>% 
  rename( "Comunidades y Ciudades Autónomas" = MUJERES)
ejercicio_mujeres_comunidad

#Comprobamos los levels
levels(factor(muertes_CCAA$`Comunidades y Ciudades Autónomas`))
levels(factor(ejercicio_mujeres_comunidad$"Comunidades y Ciudades Autónomas"))

#Una vez tenemos ambas tablas con los atributos "sincronizados"
#hacemos un left_join, que por defecto realizará un 
#natural join al no especificar las columnas a unir

union_tablas<-left_join(x=ejercicio_mujeres_comunidad,y=muertes_CCAA)
union_tablas

#gracias a la unión mediante left_join, observamos NA en la fila de
#de CATALUÑA. Esto se debe a que en muertes_CCAA no se imprime de forma adecuada
#el caracter ñ, teniendo otro caracter. 
muertes_CCAA$`Comunidades y Ciudades Autónomas`[9]<-"CATALUÑA"
muertes_CCAA
#Solucionado
union_tablas<-left_join(x=ejercicio_mujeres_comunidad,y=muertes_CCAA)
union_tablas

# OBTENCION DE DATOS DE LOS NACIMIENTOS POR COMUNIDAD AUTÓNOMA ------------

#Los datos de natalidad que hemos introducido a mano salen de aquí:
#Natalidad_2021 <- read.delim("clipboard")
#visualizamos su estructura para observar lo que nos interesa
#str(Natalidad_2021)
#Es la columna de nacidos
#Natalidad_2021$Nacidos

#Como solo nos interesa la columna de nacidos y los nombres de las CCAA estan
#desordenados, creamos un dataframe

Natalidad<-data.frame( `Comunidades y Ciudades Autónomas` =muertes_CCAA$`Comunidades y Ciudades Autónomas`,
                       
                       nacimientos=c(65522,9095,4771,9455,13178,3407,14738,13652,58464,843,35761,7380,15247,52357,962,13706,5036,14743,2318))
Natalidad

#Cambiamos valor de la posición 9 de la columna Comunidades.y.Ciudades.Autónomas
Natalidad$Comunidades.y.Ciudades.Autónomas[9]<-"CATALUÑA"



#una vez obtenidos los datos del número de nacimientos por comunidad autónoma
#creamos una nueva columna, que relacione la cantidad de niños muertos por
#comunidad sobre la cantidad de nacimientos por comunidad en porcentaje sobre 100.
str(muertes_CCAA)
str(Natalidad)

muertes_CCAA<-
  left_join(muertes_CCAA,Natalidad,by=c("Comunidades y Ciudades Autónomas"="Comunidades.y.Ciudades.Autónomas")) %>% 
  mutate(.data = ., muertes_comunidad_porcentaje = (suma_total /nacimientos)*100)


union_tablas<-left_join(x=ejercicio_mujeres_comunidad,y=muertes_CCAA)
union_tablas

#Gráficos:-------------------------------------------------------------------
#Cargamos el paquete ggplot2 y tidyverse
library(ggplot2)
library(tidyverse)

#Gráfico de muertes de niños por Comunidad Autónoma
ggplot(data = muertes_CCAA, aes(x = reorder(`Comunidades y Ciudades Autónomas`,muertes_comunidad_porcentaje), y = muertes_comunidad_porcentaje))+
  geom_bar(stat = "identity",fill="cornflowerblue",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()+
  theme_bw()+
  labs(x="Comunidades Autónomas",y="Muertes porcentaje",title ="Muertes de niños por Comunidad Autónoma",subtitle = "Porcentajes de muertes de menores de una semana en función del total de nacimientos de cada Comunidad Autónoma")

#Gráfico del nivel de deporte realizado por las mujeres en cada CA(nivel alto)

grafico_alto<-ggplot(data = ejercicio_mujeres_comunidad, aes(x = reorder(`Comunidades y Ciudades Autónomas`,nivel_alto), y = nivel_alto))+
  geom_bar(stat = "identity",fill="green4",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()+
  expand_limits(y=c(0,100))+
  theme_bw()+
  labs(x="Comunidades Autónomas",y="Deporte porcentaje",title ="Deporte de nive alto de mujeres por Comunidad Autónoma",subtitle = "Porcentaje del nivel de ejercicio alto en mujeres en función de la Comunidad Autónoma")

#Gráfico del nivel de deporte realizado por las mujeres en cada CA(nivel moderado)

grafico_moderado<-ggplot(data = ejercicio_mujeres_comunidad, aes(x = reorder(`Comunidades y Ciudades Autónomas`,nivel_moderado), y = nivel_moderado))+
  geom_bar(stat = "identity",fill="gold2",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()+
  expand_limits(y=c(0,100))+
  theme_bw()+
  labs(x="Comunidades Autónomas",y="Deporte porcentaje",title ="Deporte de nivel moderado de mujeres por Comunidad Autónoma",subtitle = "Porcentajes del nivel de ejercicio moderado en mujeres en función de la Comunidad Autónoma")

#Gráfico del nivel de deporte realizado por las mujeres en cada CA(nivel bajo)

grafico_bajo<-ggplot(data = ejercicio_mujeres_comunidad, aes(x = reorder(`Comunidades y Ciudades Autónomas`,nivel_bajo), y = nivel_bajo))+
  geom_bar(stat = "identity",fill="red",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()+
  expand_limits(y=c(0,100))+
  theme_bw()+
  labs(x="Comunidades Autónomas",y="Deporte porcentaje",title ="Deporte de nivel bajo de mujeres por comunidad Autónoma",subtitle = "Porcentajes del nivel de ejercicio bajo en mujeres en función de la Comunidad Autónoma")


grafico_alto
grafico_moderado
grafico_bajo

#install.packages("pacthwork")
#install.packages("hrbrthemes")
library("hrbrthemes")
library("patchwork") # To display 2 charts together

grafico_deporte <- grafico_alto+grafico_moderado+grafico_bajo
grafico_deporte
#Gráfico de relación

#vamos a crear una nueva columna con los niveles de deporte en mujeres en la #tabla union_tablas para utilizar facet_grid y factor (esto al final no ha sido #tal cual)
#Hay que hacer un gráfico lollypop (al final no se ha realizado este tipo de #gráfico)

union_tablas<- union_tablas[,-c(2,6)]
union_tablas

?pivot_longer

long_union_tablas<-pivot_longer(data = union_tablas, names_to = "Variable", values_to = "Valores", cols = c(nivel_alto:nivel_bajo))


#GRÁFICO DE LA RELACION ENTRE MUERTE Y PORCENTAJE DE EJERCICIO EN MUJERES
#(CON ERROR ESTÁNDAR DE ESTIMACIÓN/"MÁS REALISTA")
ggplot(data=long_union_tablas,aes(x=Valores,y =muertes_comunidad_porcentaje,colour=Variable))+
  geom_point()+
  geom_smooth()+
  expand_limits(x=c(0,100),y=c(0,1))+
  scale_color_manual(values=c("green4","red","gold2"))+
  theme_bw()+
  labs(x="Porcentaje de deporte en mujeres",y="Porecentaje de muertes",title ="Relación entre  porcentaje de ejercicio y muertes",subtitle = "Representación del porcentaje de ejercicio de las mujeres de todas las CCAA en función del nivel, y su relación con la muerte de niños menores a una semana",colour= "Nivel de ejercicio")


#GRÁFICO DE LA RELACION ENTRE MUERTE Y PORCENTAJE DE EJERCICIO EN MUJERES
#(SIMPLIFICADO/LIMPIO)
ggplot(data=long_union_tablas,aes(x=Valores,y =muertes_comunidad_porcentaje,colour=Variable))+
  geom_point()+
  #geom_smooth()
  expand_limits(x=c(0,100),y=c(0,1))+
  geom_smooth(method = "nls", formula = y ~ a * x + b, se = F,
              method.args = list(start = list(a = 0.1, b = 0.1)))+
  scale_color_manual(values=c("green4","red","gold2"))+
  theme_bw()+
  labs(x="Porcentaje de deporte en mujeres",y="Porecentaje de muertes",title ="Relación entre  porcentaje de ejercicio y muertes",subtitle = "Representación del porcentaje de ejercicio de las mujeres de todas las CCAA en función del nivel, y su relación con la muerte de niños menores a una semana",colour= "Nivel de ejercicio")
    





