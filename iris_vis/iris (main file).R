#Data Manipulation + Visualisation: Iris

#dataset
iris
head(iris)
str(iris)
#refer str(iris).png

#setting working directory and exporting data
setwd("E:/Documents")
write.table(iris,file="iris.csv",sep=',')

#libraries:
library(MASS)
library(dplyr)
library(tibble) #view() funtion
library(ggplot2)
library(magrittr) #%>% operator
library(tidyr)

view(iris)
#rearranging columns
iris1<-iris[c(5,1:4)]
str(iris1)

#tidying data using tidyr
iris.tidy <- iris1 %>%
  gather(key, Value, -Species) %>%
  separate(key, c("Part", "Measure"), "\\.")
str(iris.tidy)
#refer str(iris.tidy).png

#additional file for tidying data manually using data manipulation

#barplot
plot(Value~Species,data = iris.tidy)
#refer plot(values~species).png
#this shows how the three species vary in terms of length
#but still we don't have clarity about measure or part of the flowers.

ggplot(data = iris,aes(x=Sepal.Length,y=Sepal.Width,col=Species))+
  geom_jitter()
#refer Sepal_W~L.png 
ggplot(data = iris,aes(x=Petal.Length,y=Petal.Width,col=Species))+
  geom_jitter()
#refer Petal_W~L.png

#The plots in the graphs aren't accurate because we used the function geom_jitter
#Funtion geom_point() maps the data as it is, but geom_jitter() adds a little variance to data
#for better representation in several cases and avoid overlapping of same values.
ggplot(data=iris.tidy,aes(x=Measure,y=Value,col=Species))+
  geom_jitter()+
  facet_grid(.~Part)
#refer iris_tidy_Value~Measure.png
