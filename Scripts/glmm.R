#Generalized Linear Mixed Models in R

#Going to use the Plant Competition data from Problem Set 5, Question 2
#This looked at the effects of Clipping, Weeding, and Species Identity on the 
#number of flowers that plants produced.

#The dependent variable is the number of flowers, which is not normally-distributed.

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/PS5/plantcompetition.csv")
View(mydata)

library(tidyverse)
mydata<-mydata%>%
  select(-X)

#Before we proceed, it's important to know that many of the distributions do not handle 
#zeroes or negative numbers well. They only deal with positive numbers. So because
#there are 0's in this data set, I'm going to add 1 to everything
mydata$flowers1<-mydata$flowers+1
# also consider if you have negative values in data - some tests can't run on negative numbers
# at that point, you want to add the lowest negative number + 1 to all your data so all your data is positive and non-zero

#Step 1: Determine the best error distribution
library(car)
library(MASS)
#First, try a normal distribution
qqp(mydata$flowers, "norm") 
#Ok, definitely not normal


#So let's try a lognormal distribution
qqp(mydata$flowers1, "lnorm")
#That looks pretty good. Let's also try gamma

##Checking the qqplots for other distributions gets a little trickier, but here's
#code for them

gamma<-fitdistr(mydata$flowers1, "gamma")
qqp(mydata$flowers1, "gamma", shape = gamma$estimate[[1]], rate=gamma$estimate[[2]])
#not quite as good as log-normal

#Try negative binomial
nbinom <- fitdistr(mydata$flowers1, "Negative Binomial")
qqp(mydata$flowers1, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])

#Try poisson
poisson <- fitdistr(mydata$flowers1, "Poisson")
qqp(mydata$flowers1, "pois", lambda=poisson$estimate)
#nope

#Looks like lognormal is our best choice


#Step2: fit a model with our chosen error distribution
#To fit a normal distribution in a glm, it would look like this

library(lme4) #We need to use glm instead of lm
model1<-glm(flowers1~clipped*weeded*Species, family=gaussian(link="identity"), data=mydata)


#But we really wanted to fit a log-normal distribution. 
#To do that, we keep gaussian, but change the link to log
model2<-glm(flowers1~clipped*weeded*Species, family=gaussian(link="log"), data=mydata)


#If we wanted to fit Gamma instead:
model3<-glm(flowers1~clipped*weeded*Species, family=Gamma(link="inverse"), data=mydata)



#Now to get results from the lognormal model
Anova(model2, type="III") #This does Likelihood Ratio Tests on each fixed factor
# get a chi-squared value and p-value testing the significance of each effect



####Ok, now let's say we wanted to make Species a random effect instead of a fixed one
#So now we're fitting a mixed model, with two fixed factors (clipped and weeded) and one
#random factor (Species)

#To fit a mixed model, we have to use glmer instead of glm, which lets us specify random effects

model4<-glmer(flowers1~clipped + weeded + clipped:weeded + (1|Species) + (1|clipped:Species) + (1|weeded:Species) 
             + (1|clipped:weeded:Species), family=gaussian(link="log"), data=mydata)

Anova(model4, type="III")



#to test random effect, create model without the random effect
model5<-glm(flowers1~weeded * clipped, family=gaussian(link="log"), data=mydata)
anova(model4, model5) #result is significance of the random effect

#Result is that model4 is significantly better fit, which means that Species was important
#in determining the number of flowers

