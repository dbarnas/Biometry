#Code for doing regression in R

#Clear the environment
rm(list=ls())

#Import the data. 
#We'll use our old friend, the SnailData as an example
mydata <- read.csv("Data/SnailData.csv")
View(mydata)

#I find NA's make it hard to deal with some regression plots, so I'm just going to get rid
#of that NA right up front, but there are other ways of dealing with NAs later (na.omit, etc) later, if you prefer
mydata<-mydata[-26,]

#We're going to ask whether the length of the snail determines its weight.
#So let's fit a model that describes that relationship
#The command 'lm' fits a linear model
model1<-lm(Weight~Length, data=mydata, na.action="na.omit")

#lm = linear model
#Weight is the dependent variable (y)
#Length is the independent variable (x)
# want to know if weight is predicted by length

#Before we look at the results, let's test the assumptions of the model
#We can call the residuals of the model as:
resid(model1) #better to name these as something
model1res<-resid(model1)

#Now we can test the normality of the residuals
library(car)
qqp(model1res, "norm")

#We can also call the fitted y values as:
fitted(model1) #This is the predicted value of y, for each value of x

#To test for homogeneity of variance, we want to plot the fitted (predicted) values
#against the residuals
plot(model1res~fitted(model1))

#This looks pretty good. We want to see no pattern. If we see a cone pattern, that is problematic

#A shortcut to doing all of the above.
plot(model1) #gives plots that show normality, homogeneity of variance, and potential outliers

#Ok, if we're satisfied with our assumptions being met, then let's see how well our model fits the data
#To see the results of the model

summary(model1)

# report that F=808.6, df = 1, 37, p-value < 2.2e-16, r-squared = 0.9562

# adjusted r-squared: Casey thinks it adjusts for sample size, 
#so if you have a low sample size (<10 data points or something)
#maybe use the adjusted, but other wise just use the normal r-squared)

#Ideally we would do this as a Model II regression, especially if we're interested in knowing
#the true estimate of the slope. Model II is appropriate because we have error in our measures
#of both x and y.
library(lmodel2)
model2<-lmodel2(Weight~Length, range.y="relative", range.x="relative", data=mydata, nperm=99)
model2
#Note: "relative" means the variable has a true zero at some point. You can also use 'interval'
#to indicate that the variables can include negative values


#how to make plot
#There are lots of options to add on here (I'm using Base Plot code here)
#In the simplest form:
plot(Weight~Length, data=mydata, col="blue", ylab="Weight (mg)", xlab="Length (cm)")
abline(model1, col="blue") #adds fit from the model

#want to add confidence intervals to the regression line?
prd<-predict(model1, interval="confidence")
#the above gives a table with predicted values and upper and lower confidence intervals
lines(mydata$Length, prd[,2], lty=2) #adds lower CL
lines(mydata$Length, prd[,3], lty=2) #adds upper CL

#I didn't like these funky lines, which seems to be fixed by making
#a new x variable that is more finely grained. So try this
newx<-seq(min(mydata$Length), max(mydata$Length), 0.1)
newpredict<-predict(model1, newdata=data.frame(Length=newx), interval="confidence")
plot(Weight~Length, data=mydata, col="blue", ylab="Weight (mg)", xlab="Length (cm)")
abline(model1, col="blue")
lines(newx, newpredict[,2], lty=2)
lines(newx, newpredict[,3], lty=2)


#Or you could also do this with ggplot, which is much less clunky
library(ggplot2)
ggplot(mydata, aes(x=Length, y=Weight))+
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point(shape=1) + 
  guides(fill=FALSE) + 
  ylab("Weight (mg)") +
  xlab("Length (cm)") +
  geom_smooth(method="lm")
