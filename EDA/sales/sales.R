#sales: exploratory data analysis
#library
#install.packages("openxlsx") #quotes
library(openxlsx)

#data extraction
sales_data<-read.csv("https://raw.githubusercontent.com/ine-rmotr-curriculum/FreeCodeCamp-Pandas-Real-Life-Example/master/data/sales_data.csv")
write.xlsx(sales_data,file="E:/Downloads/sales_data.xlsx")

#View(sales_data)
