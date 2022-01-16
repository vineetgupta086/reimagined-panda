#Data Manipulation + Visualisation: Iris

#dataset
iris
head(iris)
str(iris)

#setting working directory and exporting data
setwd("E:/Vineet/work/projects/IrisVisualize")
write.table(iris,file="iris.csv",sep=',')

#libraries:
#library(MASS)
#library(tibble) #view() funtion
#library(magrittr) #%>% operator
library(ggplot2) #graphics
library(dplyr) #%>% and manipulation
library(tidyr) #tidy data

View(iris)
#rearranging columns
iris1<-iris[c(5,1:4)]
str(iris1)

#tidying data using tidyr
iris.tidy <- iris1 %>%
  gather(key, Value, -Species) %>%
  separate(key, c("Part", "Measure"), "\\.")
str(iris.tidy)

#additional file for tidying data manually using data manipulation

#barplot
plot(Value~Species,data = iris.tidy)
#this shows how the three species vary in terms of length
#but still we don't have clarity about measure or part of the flowers.

ggplot(data = iris,aes(x=Sepal.Length,y=Sepal.Width,col=Species))+
  geom_jitter()
#refer Sepal_W~L.png 
ggplot(data = iris,aes(x=Petal.Length,y=Petal.Width,col=Species))+
  geom_jitter()

#The plots in the graphs aren't accurate because we used the function geom_jitter
#Funtion geom_point() maps the data as it is, but geom_jitter() adds a little variance to data
#for better representation in several cases and avoid overlapping of same values.
ggplot(data=iris.tidy,aes(x=Measure,y=Value,col=Species))+
  geom_jitter()+
  facet_grid(.~Part)
