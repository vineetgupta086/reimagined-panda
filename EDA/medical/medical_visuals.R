#medical visuals
library(dplyr)
library(ggplot2)

data = read.csv("E:/Vineet/work/projects/eda/medical/medical.txt",
                sep = ",",header = T)
data1=data
str(data1)
list_factor = c('gender','cholesterol','gluc','smoke','alco','alco','active','cardio')
n_factor = c(3,8:13)
data1[,n_factor]=lapply(data1[,n_factor], factor)
str(data1)
hist(x = data1[,n_factor])
