#COVID-19 Time Series
##libraries
library(dplyr) #data manipulation
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
  #read.xlsx("data_india.xlsx")
}

confirmed_train = data.india %>%
  select(date, new_cases) %>%
  filter(date < as.Date("2021-06-07"))

confirmed_eval = data.india %>%
  select(date, new_cases) %>%
  filter(date >= as.Date("2021-06-07"))

ggplot(data = confirmed_train,aes(y=new_cases,x=date))+geom_line()

#1. automatic modelling using auto.arima() method
confirmed_train<-as.ts(confirmed_train$new_cases)
model.conf<-auto.arima(confirmed_train);model.conf
model.conf.forecast<-forecast(confirmed_train,model = model.conf,h = 14)

conf_pred<- model.conf.forecast$mean
p<-length(model.conf$model$phi)
d<-length(model.conf$model$Delta)
q<-length(model.conf$model$theta)

plot(model.conf.forecast,xlab="Time(Day)",ylab="Daily Confirmed Cases",showgap = F, lwd=2,
     xlim=c(400,550))
chisq.test(x = conf_pred, y = confirmed_eval$new_cases)

abline(h=0)
head(model.conf.forecast$mean)
head(model.conf.forecast$lower)
head(model.conf.forecast$upper)
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