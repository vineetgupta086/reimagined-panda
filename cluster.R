#clustering basics
library(dplyr)
library(magrittr)
#install.packages("factoextra")
library(factoextra)

#
df<-mtcars 
df<-na.omit(mtcars)
df<-scale(mtcars)
i<-NULL
km<-kmeans(x = df,centers = 5,nstart = 25)
fviz_cluster(object=km,data = df)
head(mtcars)


