#How to do logistic regression

#This example examine the effect of perimeter to area ratio (PA) of islands on 
#the presence of lizards on the island

#Clear the environment
rm(list=ls())


#Import the data
mydata <- read.csv("Data/lizards.csv")
View(mydata)

hist(mydata$Present)
#Notice that the data is binomially distributed. There are only two possible outcomes
#(present or absent). So we can fit a binomial error distribution to our data

library(lme4)
library(car)
model1 <- glm(Present ~ PA_ratio, family = "binomial"(link="logit"), data=mydata)
Anova(model1)

#We'd also like to get a pseudo R^2 value that tells us how much of the variance
#in lizard presence is explained by the PA ratio of the island

library(pscl)
pR2(model1) #gives pseudo R^2
#The last three columsn are all different types of pseudo-R^2s.
#I usually use McFadden's rho-square


#To plot the data
#Simple plot
plot(mydata$PA_ratio,mydata$Present,xlab="Perimeter:Area Ratio",ylab="Probability of Lizard Presence")
curve(predict(model1,data.frame(PA_ratio=x),type="resp"),add=TRUE) # draws a curve based on prediction from logistic regression model

#We can infer from the graph that islands with lower perimeter to area ratios have a 
#greater chance of lizards being present.

#Here's some code for making a nicer plot with ggplot
predicted.data<-as.data.frame(predict(model1, type="response", se=TRUE))

library(ggplot2)
ggplot(mydata, aes(x=mydata$PA_ratio, y=mydata$Present)) +
  theme_bw() +
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() +
  geom_smooth(data = predicted.data, aes(y=fit)) +
  labs(x="Perimeter:Area Ratio", y="Presence of Lizards")




