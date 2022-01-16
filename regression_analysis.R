#importing dataset
data1<-read.csv("https://raw.githubusercontent.com/AdiPersonalWorks/Random/master/student_scores%20-%20student_scores.csv")
str(data1)

summary(data1)
cor(data1$Hours,data1$Scores)

#our input
x<-9.5
model1<-lm(Scores~Hours,data=data1)
model1$coefficients
m<-model1[["coefficients"]][["Hours"]]
c<-model1[["coefficients"]][["(Intercept)"]]
y<-m*x+c
y
