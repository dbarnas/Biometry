#R Code for Problem Set 9

################################
###Problem 1: Fish Sex Ratios###
################################

#Clear the environment
rm(list=ls())

#Define the data
female<-371
male<-250

#Set up our table of observed and expected value:
observed <- matrix(c(female, male), nrow=1, ncol=2) #created a table of observed values
exp <- matrix(c((female+male)*0.5, (female+male)*0.5), nrow=1, ncol=2)

#To calculate G:
Gtest <- 2*sum(observed*log(observed/exp))
Gtest # 23.7

#To get p-value
1-pchisq(Gtest, df=1)

#Or an alternative way to do this:
library(DescTools)
GTest(observed)

#Or to do X2 test:
X2test<- sum((observed-exp)^2/exp)
X2test
1-pchisq(X2test, df=1)




############################
###Problem 2: Fruit Flies###
############################

#Clear the environment
rm(list=ls())

wild<-161
mutant<-33
obs<-matrix(c(wild, mutant), nrow=1, ncol=2)
exp<-matrix(c((wild+mutant)*.75, (wild+mutant)*0.25), nrow=1, ncol=2)

#To calculate G:
Gtest <- 2*sum(obs*log(obs/exp))
Gtest # 7.18
#To get p-value
1-pchisq(Gtest, df=1)

#Or an alternative:
library(DescTools)
GTest(obs, p=c(0.75,0.25))

#Or to do X2 test:
X2test<- sum((obs-exp)^2/exp)
X2test
1-pchisq(X2test, df=1)



##############################
###Problem 3: Hangover Cure###
##############################

#Clear the environment
rm(list=ls())


obs<-matrix(c(58, 61, 33, 21), nrow=2, ncol=2)

#To calculate G:
library(DescTools)
GTest(obs, correct="none")

##########################
###Question 4:Elections###
##########################

#Log linear analysis
#Clear the environment
rm(list=ls())

mydata <- read.csv("Data/Votes.csv")
View(mydata)

library(lme4)
model1<-glm(Frequency~Race:Vote + Gender:Vote + Race:Gender:Vote, family=poisson, data=mydata)

anova(model1, test="Chisq")


#You could also break this down and do a G-test on gender, but for each different race
library(tidyr)
library(dplyr)
Whiteonly <- mydata %>%
  filter(Race == "White")

white<-glm(Frequency~Gender:Vote, family=poisson, data=Whiteonly)

Blackonly <- mydata %>%
  filter(Race == "Black")

black<-glm(Frequency~Gender:Vote, family=poisson, data=Blackonly)

Latinoonly <- mydata %>%
  filter(Race == "Latino")

latinx<-glm(Frequency~Gender:Vote, family=poisson, data=Latinoonly)

anova(white, test="Chisq")
anova(black, test="Chisq")
anova(latinx, test="Chisq")



