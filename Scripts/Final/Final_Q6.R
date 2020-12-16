# Barnas Final Practical

library(tidyverse)
#########################
# Question 6
#########################

rm(list=ls())

mydata<-read_csv("Data/Final/SeaTurtle.csv")
View(mydata)

mydata$Site<-as.factor(mydata$Site)

# Regression of Egg Clutch and Turtle Size
model1<-lm(Eggs ~ Size, data=mydata)
qqp(residuals(model1),"norm")
# plot the data
plot(mydata$Eggs ~mydata$Size)
abline(model1)
summary(model1) # R2 = 0.1 yikes
anova(model1)

# full model
model<-lm(Eggs ~ Site * Size, data=mydata)

# covariates-only models based on site
data1<-mydata%>%
  filter(Site=="Bahamas")
data2<-mydata%>%
  filter(Site=="Florida")
data3<-mydata%>%
  filter(Site=="NorthCarolina")

model1<-lm(Eggs~Size, data1)
model2<-lm(Eggs~Size, data2)
model3<-lm(Eggs~Size, data3)

#Check assumptions
plot(model) # full model looks good
plot(model1)
plot(model2)
plot(model3)

#Remember that you also want to make sure that the relationship with covariate is linear
plot(Eggs~Size, data=data1, col="blue", ylab="Clutch Size", xlab="Carapace Size")
abline(model1, col="blue") #adds fit from the model
summary(model1)

plot(Eggs~Size, data=data2, col="blue", ylab="Clutch Size", xlab="Carapace Size")
abline(model2, col="blue")
summary(model2)

plot(Eggs~Size, data=data3, col="blue", ylab="Clutch Size", xlab="Carapace Size")
abline(model3, col="blue")
summary(model3)

summary(mydata) # balanced data

summary(model)
anova(model)

#for plotting the data
#To plot the data:

predEggs<-predict(model) #Gets the predicted values from the regression lines in the ANCOVA
graphdata<-cbind(mydata, predEggs) #attaches those predictions to the dataset

library(ggplot2)
ggplot(data=graphdata, aes(Size, Eggs, color=Site)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=10), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() + geom_line(aes(y=predWeight)) +
  labs(x="Turtle Carapace Length", y="Clutch Size", fill="Site") +
  ggsave("Output/Final/Final_6.png")












