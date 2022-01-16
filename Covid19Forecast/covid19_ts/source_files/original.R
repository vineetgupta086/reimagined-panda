#covid-19 time series analysis for INDIA

#libraries
library(readxl) #xsls file
library(magrittr)#%>%
library(MASS) #select()
library(dplyr)
library(ggplot2)
library(tibble) #view()
library(scales)
install.packages("openxlsx")
library(openxlsx)
#objective: to analyse the time-series of SARS-CoV-2/Covid-19
#confirmed and death cases and study the trends to forecast 
#expected future trends

#data sources:
#www.data.world/shad/covid-19-time-series-data
#https://github.com/datasets/covid-19/blob/master/data/countries-aggregated.csv

#source files: www.github.com/vineetgupta086/reimagined-panda

###################
#importing data
setwd("E:/Vineet/work/projects/project_covid/datasets")
ind_data<-read_xlsx(path="india.xlsx")
str(ind_data)
typeof(ind_data$Date)
ind_data$Date<-as.Date(ind_data$Date)
is.ts(ind_data)
ind_data<-as.ts(ind_data)
view(ind_data)
plot.ts(ind_data[,3],ylab="New Confirmed")
conf_new<-ind_data[,3]

view(conf_new)
plot(conf_new)
acf(conf_new,na.action)
###################

###################
#tidying data
#Separating new cases for confirmed and death

#separating confirmed data
attach(ind_data)
ind_conf<-ind_data %>%
  mutate(Status="Confirmed") %>%
  select(Date,new_cases,Status) %>%
  rename(Value=new_cases)
view(ind_conf)
#separating death data
ind_dead<-ind_data %>%
  mutate(Status="Dead") %>%
  select(Date,new_deaths,Status) %>%
  rename(Value=new_deaths)
view(ind_dead)
#combining data
 ind_tdata<-rbind(ind_conf,ind_dead)
view(ind_tdata)
ind_tdata$Status<-as.factor(ind_tdata$Status)
str(ind_tdata)
ind_ts<-ind_tdata %>%
  select(Value,Status)
ind_ts<-ts(ind_ts,start=2020,frequency = 365)
ts.plot(ind_ts)
rm(ind_conf,ind_dead)

###################

###################
#plotting
ggplot(ind_tdata,aes(x=Date,y=Value))+geom_line()+
  facet_grid(Status~.)+
  scale_y_discrete(expand = expansion())
ggplot(ind_conf,aes(x=Date,y=Value,col=Status))+geom_line()
ggplot(ind_dead,aes(x=Date,y=Value,col=Status))+geom_line()
###################
#time series#
###################
setwd("E:/Vineet/work/projects/project_covid/datasets")
oct_data=read.xlsx("oct_data.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
nov_data=read.xlsx("nov_data.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)

view(oct_data); view(nov_data)
oct_data[,1]<-as.Date(oct_data[,1])
class(oct_data[,1]) #date

#For now we do not use data_nov as it will be later used to compare to the model
conf<-as.ts(oct_data$Confirmed)
conf_new<-diff(conf)
view(conf_new,title = "Confirmed")
plot.ts(conf_new,xlim=c(50,300),ylim=c(0,100000))

abline(v = 100,col='red')
summary(conf_new)

rw_conf<-arima(conf_new,order=c(0,1,0)) #random walk model
ar_conf<-arima(conf_new,order=c(1,0,0)) #autoregression model
ma_conf<-arima(conf_new,order=c(0,0,1)) #moving average model

#Random Walk Model and comparison
rw_pred<-predict(rw_conf,n.ahead = 30)$pred
rw_se<-predict(rw_conf,n.ahead = 30)$se
plot.ts(conf_new,xlim=c(50,320),main="Random Walk Model")
points(rw_pred,type='l',col="red")
points(rw_pred-rw_se,type='l',col="red",lty=2)
points(rw_pred+rw_se,type='l',col="red",lty=2)
points(data_nov,type='l',col="blue",lty=2)

#Autoregression Model for confirmed
ar_pred<-predict(ar_conf,n.ahead=30)$pred
ar_se<-predict(ar_conf,n.ahead=30)$se
plot.ts(conf_new,xlim=c(50,320),main="Autoregression Model")
points(ar_pred,type='l',col="green")
points(ar_pred-ar_se,type='l',col="green",lty=2)
points(ar_pred+ar_se,type='l',col="green",lty=2)
points(data_nov,type='l',col="blue",lty=2)

#Moving Average Model and comparison
ma_pred<-predict(ma_conf,n.ahead=30)$pred
ma_se<-predict(ma_conf,n.ahead=30)$se
plot.ts(conf_new,xlim=c(50,320),main="Moving Average Model")
points(ma_pred,type='l',col="blue")
points(ma_pred-ma_se,type='l',col="blue",lty=2)
points(ma_pred+ma_se,type='l',col="blue",lty=2)
points(data_nov,type='l',col="red",lty=2)

####
library(readxl) #xsls file
library(magrittr)#%>%
library(MASS) #select()
library(dplyr)
library(ggplot2)
library(scales)
library(openxlsx)
library(forecast)
detach("package:astsa")
setwd("E:/Vineet/work/projects/covid19_ts")

#####Confirmed data
#Confirmed Cases Jan-Oct
conf<-read.xlsx("datasets/conf_new.xlsx")
conf$Date <- as.Date(conf$Date)
str(conf)
#Confirmed Cases Jan-Nov
conf2<-read.xlsx("datasets/conf_new2.xlsx")
conf2$Date <- as.Date(conf2$Date)
str(conf2)

plot(conf2$Confirmed~conf2$Date,type="l",main="Jan-Nov Covid Confirmed Cases")
conf.ma<-auto.arima(conf$Confirmed,approximation = F)
conf.ar<-arima(conf$Confirmed,order=c(1,0,0))
conf.ma_predict<-predict(conf.ma,n.ahead = 30)$pred
conf.ar_predict<-predict(conf.ar,n.ahead = 30)$pred
conf.ma_df<-data.frame(conf.ma_predict,conf$Date[285:314])
conf.ar_df<-data.frame(conf.ar_predict,conf$Date[285:314])
points(conf.ma_df$conf.ma_predict,col="red",type="l",lwd=2)
points(conf.ar_df$conf.ar_predict,col="blue",type="l",lwd=2)
#####Death data
#Deaths Jan-Oct
dead<-read.xlsx("datasets/dead_new.xlsx")
dead$Date <- as.Date(dead$Date)
str(dead)
#Deaths Jan-Nov
dead2<-read.xlsx("datasets/dead_new2.xlsx")
dead2$Date <- as.Date(dead2$Date)
str(dead2)

