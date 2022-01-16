#COVID-19 Time Series
##libraries
library(dplyr) #data manipulation
#library(astsa) #sarima()
library(forecast) #forecast()
library(openxlsx) #write.xlsx()
library(ggplot2)
##working with data
#importing data
{
data.world<-read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv",
                     sep = ",",header = T)
}
str(data.world)
#preprocessing data
{
data.india<-data.world %>%
  filter(location=="India") %>%
  select(date,new_cases)
data.india$date<-as.Date(data.india$date)
n<-nrow(data.india)
str(data.india)
}

{
#set working directory
setwd("E:/Vineet/work/projects/covid19_forecast/datasets")
#exporting data
write.xlsx(data.india,"data_india.xlsx")
rm(data.world)
read.xlsx("data_india.xlsx")
}

#plotting daily confirmed cases
daily.confirmed<-as.ts(data.india$new_cases)
str(daily.confirmed)
#plot(y=daily.confirmed,x=data.india$Date[2:n],main="New Infected",
#     ylab="No. of cases",xlab="Time (Months)",type="l",lwd=2,col="#0000ff")
ggplot(data = data.india,aes(y=new_cases,x=date))+geom_line()

#1. automatic modelling using auto.arima() method
model.1<-auto.arima(daily.confirmed);model.1
model.1.forecast<-forecast(daily.confirmed,model = model.1,h = 15)

print(model.1.forecast$mean)
p<-length(model.1$model$phi)
d<-length(model.1$model$Delta)
q<-length(model.1$model$theta)
n<-nrow(daily.confirmed)-1
plot(model.1.forecast,xlab="Time(Day)",ylab="Daily Confirmed Cases",showgap = F, lwd=2,
     xlim=c(400,550))
abline(h=0)
head(model.1.forecast$mean)
head(model.1.forecast$lower)
head(model.1.forecast$upper)
#2. Holt-Winters Model (Double exponential Smoothing)
model.2<-HoltWinters(daily.confirmed,gamma=F)
model.2.forecast<-forecast(model.2,h = 15)
plot(model.2.forecast,lwd=2,xlab="Time (Day)",
     ylab="Daily Confirmed Cases",xlim=c(400,550)); abline(h = 0)
head(model.2.forecast$mean)
head(model.2.forecast$lower)
head(model.2.forecast$upper)

#comparing both plots visually
{
  par(mfrow=c(1,2))
  plot(model.1.forecast,xlim=c(400,550)); abline(h=0)
  plot(model.2.forecast,xlim=c(400,550)); abline(h=0)
  par(mfrow=c(1,1))
}
###end