#libraries
library(dplyr)
library(magrittr) #for %>% operator

#import data
data<-read.csv("datasets/iris.csv")
str(iris)
#Separating sepal data
iris1a<-iris %>%
  mutate(Part="Sepal") %>%
  select(Species,Part,Sepal.Length,Sepal.Width) %>%
  rename(Length=Sepal.Length,Width=Sepal.Width)
str(iris1a)
#Separating petal data
iris1b<-iris %>%
  mutate(Part="Petal") %>%
  select(Species,Part,Petal.Length,Petal.Width) %>%
  rename(Length=Petal.Length,Width=Petal.Width)

#Combining sepal and petal data
iris2<-rbind(iris1a,iris1b)

iris2a<-iris2 %>%
  mutate(Measure="Length") %>%
  select(Species,Part,Measure,Length) %>%
  rename(Value=Length)

iris2b<-iris2 %>%
  mutate(Measure="Width") %>%
  select(Species,Part,Measure,Width) %>%
  rename(Value=Width)

iris3<-rbind(iris2a,iris2b)