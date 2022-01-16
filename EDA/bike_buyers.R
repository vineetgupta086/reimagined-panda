#bike buyers: EDA
#univariate
library(dplyr)

setwd("E:/Vineet/work/projects/eda")
bikebuyers<-read.csv(file="bike_buyers.csv",stringsAsFactors = TRUE)
str(bikebuyers)
summary(bikebuyers)
bikebuyers<-select(bikebuyers,-ï..ID)

str(bikebuyers)
##
hist(bikebuyers$Income)
summary(bikebuyers$Income)
plot(density(bikebuyers$Income))

#MINI CHALLENGE
#most common commute distance
summary(bikebuyers$Commute.Distance)
plot(bikebuyers$Commute.Distance,main="Commute Distance")

#did more people buy bikes or not buy bikes?
summary(bikebuyers$Purchased.Bike)
plot(bikebuyers$Purchased.Bike,main="Purchased or Not Purchased")
##########
#multivariate
?by
by(bikebuyers$Income,bikebuyers$Education,summary)

boxplot(bikebuyers$Income~bikebuyers$Education,notch=TRUE) #col=c("grey","gold",...)

install.packages("sm")
library(sm)