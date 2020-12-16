# Barnas Final Practical

library(tidyverse)
#########################
# Question 7
#########################

rm(list=ls())

mydata<-read_csv("Data/Final/armadillos.csv")
View(mydata)

hist(mydata$Burrows)

library(lme4)
library(car)
model <- glm(Burrows ~ GrainSize, family = "binomial"(link="logit"), data=mydata)
Anova(model)

library(pscl)
pR2(model) #gives pseudo R^2
#The last three columns are all different types of pseudo-R^2s.
#I usually use McFadden's rho-square

#Here's some code for making a nicer plot with ggplot
predicted.data<-as.data.frame(predict(model, type="response", se=TRUE))

library(ggplot2)
plot<-ggplot(mydata, aes(x=mydata$GrainSize, y=mydata$Burrows)) +
  theme_bw() +
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() +
  geom_smooth(data = predicted.data, aes(y=fit)) +
  labs(x="Soil Grain Size", y="Presence of Burrows") +
  ggsave("Output/Final/Final_7.png")
plot





