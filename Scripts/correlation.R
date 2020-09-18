#Code for different ways to do correlations

#Clear the environment
rm(list=ls())

#Import the data. Going to use SnailData again as an example
mydata <- read.csv("Data/SnailData.csv")
View(mydata)

#Let's look at correlations between length and weight
#First let's just look at the relationship between the two variables
plot(Weight~Length, data=mydata)

#For Pearson's correlation
mytest1<-cor.test(mydata$Weight, mydata$Length, method="pearson", na.rm=TRUE)
mytest1
#The t-test tells you whether the correlation is significant.
#The last number in the output is the correlation coefficient (r)

#For Spearman's rho
mytest2<-cor.test(mydata$Weight, mydata$Length, method="spearman", na.rm=TRUE)
mytest2
#Notice that you'll get a warning. The p-value won't be 100% correct, but will be very close.
#Note that the test runs anyway

#For Kendall's tau
mytest3<-cor.test(mydata$Weight, mydata$Length, method="kendall", na.rm=TRUE)
mytest3
#Same warning message as above. This is not terrible.

#Check for normality of each variable
library(car)
qqp(mydata$Length, "norm")

qqp(mydata$Weight, "norm")
