#libraries
library(dplyr) #data manipulation
library(forecast) #forecast()
library(openxlsx) #write.xlsx()
library(ggplot2)

#data.global<-read.csv(file='https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv',
#                      sep=',',header = T)
#data.india <- data.global %>%
#  filter(iso_code=="IND") %>%
#  select(date,new_cases,new_deaths)

data.india<-read.xlsx("E:/Vineet/work/projects/covid19_forecast/datasets/data_india.xlsx")
write.xlsx(data.india,"E:/Vineet/work/projects/covid19_forecast/datasets/data_india.xlsx")

ggplot(data.india)+
  geom_area(aes(x=date,y=new_cases),fill="#0088FF")+
  geom_area(aes(x=date,y=new_deaths),fill="#FF0000",na.rm = TRUE)

ggplot(data=data.india)+
  geom_area(aes(x=date,y=new_deaths),fill="#FF0000",na.rm = TRUE)

model.1<-auto.arima(data.india$new_cases); model.1
model.1.forecast<-forecast(data.india$new_cases,model = model.1,h = 15)
head(model.1.forecast$mean)
{ 
		plot(model.1.forecast,xlab="Time(Day)",
		ylab="Daily Confirmed Cases",xlim=c(365,550))
		abline(h=0)
}

model.2<-auto.arima(data.india$new_deaths); model.2
model.2.forecast<-forecast(data.india$new_deaths,model = model.2,h = 15)
head(model.2.forecast$mean)
{ 
	plot(model.2.forecast,xlab="Time(Day)",
	ylab="Daily Deaths",xlim=c(365,550))
	abline(h=0)
}
