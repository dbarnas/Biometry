#Code for t-tests and checking assumptions

#Clear the environment
rm(list=ls())

#Import the data. Going to use SnailData again as an example
mydata <- read.csv("Data/SnailData.csv")
View(mydata)

#Run a one sample t-test. Let's say that 2 years ago, the weights of snails were 10g.
#Now we want to know if the mean snail weight is different from 10.

mytest<-t.test(mydata$Weight, mu=10, na.rm=TRUE)
mytest

#Yes, the weight is different from zero.

#Two-sample Student's t-test; Let's say we want to compare our two locations to see if the weights are different
mytest2<-t.test(Weight~Location, var.equal=TRUE, data=mydata, na.rm=TRUE)
mytest2

#Welch's t-test: run a 2-Sample t-test test that assumed separate variances (perhaps more advisable)
#This is a slightly more conservative test
mytest3<-t.test(Weight~Location, data=mydata, na.rm=TRUE)
mytest3

#In this case, a paired t-test isn't appropriate, but IF we wanted to do one:
#In this case, I used Length, assuming that data were paired among Locations somehow
#(Hard to imagine a situation in which this was the case)

mytest4<-t.test(Length~Location, paired=TRUE, data=mydata, na.rm=TRUE)
mytest4


#Ok, let's go back to mytest2. We assumed that the data were normally distributed AND we assumed
#that the variances were equal. So let's test those assumptions.
#We could explore the data graphically, as we have before.
library(car)
qqp(mydata$Weight, "norm")

#If we wanted to do a formal test of normality, we'd use a Shapiro test
shapiro.test(mydata$Weight)
#If P>0.05, then the data is normal

#How do we test whether the variances between groups are equal?
#One way is to just look at the variances:
library(tidyr)
library(dplyr)
Variance_Snails<- mydata %>%
  group_by(Location) %>%
  summarize(variance=var(Weight, na.rm=TRUE))
Variance_Snails
#those are pretty close. But how do we know how different is TOO different?
#We can also do a boxplot, which also allows us to check for outliers
boxplot(Weight~Location, data=mydata)
#Still looks pretty good. 
#We can also do a formal test, if we wanted to, using a Bartlett Test
bartlett.test(Weight~Location, data=mydata)
#If P>0.05, then variances are equal
