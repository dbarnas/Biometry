#How to do multiple regression in R
#Use the data set SnailData2. This is similar to what we've used before
#We're going to try to predict what determines snail weight.
#As before, we will use length, but there are two new predictor variables:
#Predator Density and Food Availability

#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "urchins"
mydata <- read.csv("Data/SnailData2.csv")
View(mydata)


#First let's see what we would find if we just did 3 simple linear regressions
lengthmodel<-lm(Weight~Length, data=mydata)
predatormodel<-lm(Weight~Predators, data=mydata)
foodmodel<-lm(Weight~AvailableFood, data=mydata)

plot(Weight~Length, data=mydata)
abline(lengthmodel)

plot(Weight~Predators, data=mydata)
abline(predatormodel)

plot(Weight~AvailableFood, data=mydata)
abline(foodmodel)

#Quick check that assumptions are met
plot(lengthmodel)
plot(predatormodel)
plot(foodmodel)
#Looks like all assumptions are met

#Stats for individual regressions
summary(lengthmodel)

summary(predatormodel)

summary(foodmodel)

#Now let's do a multiple regression

#First we want to know which model fits the data best. Here's the full model:
fullmodel<-lm(Weight~Length + Predators + AvailableFood, data=mydata)

#To check for collinearity in your data:
library(GGally) # ggally for multiple scatterplots
X<-mydata[,c(4,6,7)] #gives you all the rows for just columns 4,6, and 7
ggpairs(X)




#To get actual numbers on collinearity better test:
library(mctest)
imcdiag(fullmodel)

#Now let's make every other possible model:
reduced1<-lm(Weight~Length + Predators, data=mydata)
reduced2<-lm(Weight~Length + AvailableFood, data=mydata)
reduced3<-lm(Weight~Predators + AvailableFood, data=mydata)

#Now let's get AIC for each model.
#Plus, we can use our original simple models above to use:
AIC(fullmodel)
AIC(reduced1)
AIC(reduced2)
AIC(reduced3)
AIC(lengthmodel)
AIC(predatormodel)
AIC(foodmodel)

#The full model is the lowest AIC value, so let's go with that one

summary(fullmodel)

#Here's a more traditional ANOVA table, if you like that output better
#It gives F tests instead of t...and gives df

anova(fullmodel)

#We can quickly check for homogeneity of variances of the full model:
predicted<-fitted(fullmodel)
resid<-residuals(fullmodel)
plot(resid~predicted)
abline(h=0)

#And check normality
library(car)
qqp(resid, "norm")

#To get the partial standardized regression coefficients for each factor
library(QuantPsyc)
lm.beta(fullmodel)

#Just for fun, here's what the 3D-plot of Weight, Length, and Predators would look like
library(rockchalk)
plotPlane(fullmodel, plotx1="Length", plotx2="Predators")


#Also, let's look at what it would look like if we plotted the residuals of Length vs. affect of Predators 
resid<-residuals(lengthmodel)
plot(resid~mydata$Predators) #after you account for Length, predators don't explain much
plot(resid~mydata$AvailableFood) #after you account for Length, Food doesn't explain much


