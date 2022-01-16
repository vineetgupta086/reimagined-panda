#covid-19 time series analysis for INDIA

#libraries
library(openxlsx)#xsls file
library(magrittr)#%>%
library(MASS) #select()
library(dplyr)
library(ggplot2)
library(tibble) #view()

#objective: to analyse the time-series of SARS-CoV-2/Covid-19
#confirmed and death cases and study the trends to forecast 
#expected future trends

#data sources:
#www.data.world/shad/covid-19-time-series-data

#source files: www.github.com/vineetgupta086/reimagined-panda
setwd("E:/Vineet/work/projects/covid19_ts/datasets")
###################
#processing raw data

oct_data=read.xlsx("conf_new_oct.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
nov_data=read.xlsx("conf_new_nov.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)

oct_data[,1]<-as.Date(oct_data[,1])
class(oct_data[,1]) #date

#For now we do not use data_nov as it will be later used to compare to the model
conf_new<-as.ts(oct_data$Confirmed)
view(conf_new,title = "Confirmed")
plot.ts(conf_new,xlim=c(50,320),ylim=c(0,100000))
summary(conf_new)

#confirmed_new
ar_conf<-arima(conf_new,order=c(1,0,0)) #autoregression model
#Autoregression Model for confirmed
ar_pred<-predict(ar_conf,n.ahead=30)$pred
ar_se<-predict(ar_conf,n.ahead=30)$se
plot.ts(conf_new,xlim=c(50,320),main="Autoregression Model")
points(ar_pred,type='l',col="blue",lwd=3)
points(ar_pred-ar_se,type='l',col="red",lty=2)
points(ar_pred+ar_se,type='l',col="red",lty=2)
points(nov_data,type='l')


##dead_new
rm(list=ls(pattern='^ar|new$|data$'))
setwd("E:/Vineet/work/projects/project_covid/datasets")
oct_data2=read.xlsx("dead_new_oct.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
nov_data2=read.xlsx("dead_new_nov.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
view(oct_data2)
oct_data2[,1]<-as.Date(oct_data2[,1])
#Autoregression Model for deaths
dead_new<-as.ts(oct_data2$Deaths)
plot(dead_new,ylim=c(0,2000),xlim=c(50,300))

ar_dead<-arima(dead_new,order=c(1,0,0))
ar_pred<-predict(ar_dead,n.ahead=30)$pred
ar_se<-predict(ar_dead,n.ahead=30)$se
plot.ts(dead_new,xlim=c(50,320),main="Autoregression Model")
points(ar_pred,type='l',col="blue",lwd=3)
points(ar_pred-ar_se,type='l',col="red",lty=2)
points(ar_pred+ar_se,type='l',col="red",lty=2)
points(nov_data2,type='l')

rm(list=ls(pattern='^ar|new$|data2$'))
#concluded

#####
conf_new<-as.ts(oct_data$Confirmed)
conf<-as.ts(conf_new)
plot(conf)
plot(conf.ts)
conf.ts<-diff(conf)
arima(conf.ts,order=c(1,0,0),include.mean=F)
arima(conf.ts,order=c(2,0,0),include.mean=F)
arima(conf.ts,order=c(3,0,0),include.mean=F)
