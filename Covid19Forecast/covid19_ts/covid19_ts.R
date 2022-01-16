setwd("E:/Vineet/work/projects/covid19_ts")
#libraries
library(openxlsx) #xsls file
library(dplyr)
library(ggplot2)
#processing raw data
oct_data=read.xlsx("datasets/conf_new_oct.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
nov_data=read.xlsx("datasets/conf_new_nov.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
oct_data[,1]<-as.Date(oct_data[,1])
class(oct_data[,1])
conf<-as.ts(oct_data$Confirmed)
plot.ts(conf,xlim=c(50,320),ylim=c(0,100000))
summary(conf)

ar_conf<-arima(conf,order=c(1,0,0)) #autoregression model
ar_pred<-predict(ar_conf,n.ahead=30)$pred
ar_se<-predict(ar_conf,n.ahead=30)$se

##plot_confirmed
plot.ts(conf,xlim=c(50,320),main="Autoregression Model")
points(ar_pred,type='l',col="blue",lwd=3)
points(ar_pred-ar_se,type='l',col="red",lty=2)
points(ar_pred+ar_se,type='l',col="red",lty=2)
points(nov_data,type='l')

#rm(list=ls(pattern='^conf|^ar|new$|data$'))

##data_deaths
oct_data2=read.xlsx("datasets/dead_new_oct.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
nov_data2=read.xlsx("datasets/dead_new_nov.xlsx",sheet = 1,startRow = 1,colNames = T,rowNames = F,detectDates = T)
oct_data2[,1]<-as.Date(oct_data2[,1])
dead_new<-as.ts(oct_data2$Deaths)
plot(dead_new,ylim=c(0,2000),xlim=c(50,300))

ar_dead<-arima(dead_new,order=c(1,0,0))
ar_pred<-predict(ar_dead,n.ahead=30)$pred
ar_se<-predict(ar_dead,n.ahead=30)$se

##plot_deaths
plot.ts(dead_new,xlim=c(50,320),main="Autoregression Model")
points(ar_pred,type='l',col="blue",lwd=3)
points(ar_pred-ar_se,type='l',col="red",lty=2)
points(ar_pred+ar_se,type='l',col="red",lty=2)
points(nov_data2,type='l')

#rm(list=ls(pattern='^conf|^ar|new$|data2$'))