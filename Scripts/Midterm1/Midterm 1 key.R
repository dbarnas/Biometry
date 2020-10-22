#Midterm 1 Key
#Created by C. terHorst 9/21/2020
#Edited on 9/21/2020

####################################
###Question 1: Cancer cell growth###
####################################

#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "cancer"
mydata <- read.csv("Data/cancer.csv")
View(mydata)

#First let's check our assumptions
#divide the data into the two groups separately
library(tidyr)
library(dplyr)

Pre <- mydata %>%
  filter(Time == "Before")

Post <- mydata %>%
  filter(Time == "After")

library(car)
qqp(Pre$CellGrowth, "norm")  #normal
qqp(Post$CellGrowth, "norm") #normal

#Pretty normal. What about variances?
boxplot(mydata$CellGrowth~mydata$Time)
var(Pre$CellGrowth)
var(Post$CellGrowth)
#Hmm, variances look pretty similar

#We want to make sure we used a paired t-test because the before and after
#data points are not independent

growthtest<-t.test(CellGrowth~Time, paired=TRUE, data=mydata)
growthtest



########################################
###Question 2: Human body temperature###
########################################

#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "Temps"
mydata <- read.csv("Data/Temps.csv")
View(mydata)

mean<-mean(mydata$Temperature)
median<-median(mydata$Temperature)
variance<-var(mydata$Temperature)
stdev<-sd(mydata$Temperature)
sem<-sd(mydata$Temperature)/sqrt(length(mydata$Temperature))
cv<-stdev/mean

mean
median
variance
stdev
sem
cv

bootmeans<-replicate(1000, { 
  samples<-sample(mydata$Temperature,replace=TRUE); 
  mean(samples)  })
sortedboots<-sort(bootmeans)
lowCI<-sortedboots[25]
highCI<-sortedboots[975]
hist(sortedboots, main="Histogram of Bootstraps") 
abline(v=lowCI, col="blue")
abline(v=highCI, col="blue")

#Before we do any tests, we can to figure out if the data is normally distributed
hist(mydata$Temperature) #maybe slightly right-skewed? But not much
library(car)
qqp(mydata$Temperature, "norm")
#looks pretty normal based on that plot

#Let's double check with a Shapiro's test
shapiro.test(mydata$Temperature) #ok, let's call it normal

mytest<-t.test(mydata$Temperature, mu=98.6)
mytest


###############################
###QUESTION : Sargassum data###
###############################

#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "urchins"
mydata <- read.csv("Data/Sargassum.csv")
View(mydata)


#Let's check our assumptions first
#divide the data into the two groups separately
library(tidyr)
library(dplyr)

shade <- mydata %>%
  filter(treatment == "underkelp")

noshade <- mydata %>%
  filter(treatment == "open")

library(car)
qqp(shade$biomass, "norm")  #not normal
qqp(noshade$biomass, "norm") #not normal

boxplot(mydata$biomass~mydata$treatment)

#not normal. Variances are very different

mydata$logbiomass<-log(mydata$biomass)

#Copy all that same code from above
shade <- mydata %>%
  filter(treatment == "underkelp")

noshade <- mydata %>%
  filter(treatment == "open")

library(car)
qqp(shade$logbiomass, "norm")  #normal
qqp(noshade$logbiomass, "norm") #normal

boxplot(mydata$logbiomass~mydata$treatment)
#Great! Normal and pretty equal variances

#I did a Welch's t-test, but because the variances are about equal
#you could also do a Student's t-test and be fine. Note the main difference
#is the df adjustment under Welch's, which means it's a little less powerful.

test1<-t.test(logbiomass~treatment, var.equal=FALSE, data=mydata)
test1
#If you wanted to use Student's
test2<-t.test(logbiomass~treatment, var.equal=TRUE, data=mydata)
test2

#Make a graph
library(tidyr)
library(dplyr)
graphdata <- mydata %>%
  group_by(treatment) %>%
  summarize(mean=mean(logbiomass, na.rm=TRUE), se=sd(logbiomass, na.rm=TRUE)/sqrt(length(na.omit(logbiomass))))
graphdata


#And now to the graph
library(ggplot2)
ggplot(graphdata, aes(x=treatment, y=mean)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
           panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
  geom_bar(stat="identity", color="dodgerblue2", fill="dodgerblue2", position="dodge", size=0.6) + 
  labs(x="Treatment", y="Log Biomass") + 
  geom_errorbar(aes(ymax=mean+se, ymin=mean-se), position=position_dodge(0.9), width=0.1)




