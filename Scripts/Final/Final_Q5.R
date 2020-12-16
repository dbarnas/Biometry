# Barnas Final Practical

library(tidyverse)
#########################
# Question 5
#########################

rm(list=ls())

mydata<-read_csv("Data/Final/cancerdrug.csv")
View(mydata)

# one-way anova
mydata$cell<-mydata$'cell proliferation'
mydata<-mydata[,-2]

mydata$treatment<-as.factor(mydata$treatment)
summary(mydata) # equal sample size

model<-lm(cell~treatment, data=mydata)
anova(model)

qqp(residuals(model),"norm")

mydata<-mydata%>%
  mutate(logcell=log(cell))
model<-aov(logcell~treatment, data=mydata)

qqp(residuals(model),"norm")
plot(model)
#log better than square root

anova(model)

library(emmeans)
graphdata<-as.data.frame(emmeans(model, "treatment"))
graphdata

#To do a post-hoc Tukey test
TukeyHSD(model) # requires aov() instead of lm() for model function







