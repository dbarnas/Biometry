# PS7

###################
# Question 1
###################

rm(list=ls())

#In total, we observed 621 fish
female<-371
male<-250

#Set up our table of observed and expected value:
observed <- matrix(c(female, male), nrow=1, ncol=2) #created a table of observed values

exp <- matrix(c((female+male)*0.5, (female+male)*0.5), nrow=1, ncol=2)
# using 0.5 because we expect a 1:1 ratio of females to males

#To do a X2 test:
X2test<- sum((observed-exp)^2/exp)
X2test

# get a p value
1-pchisq(X2test, df=1)

###################
# Question 2
###################

rm(list=ls())

wt<-161
mut<-33

#Set up our table of observed and expected value:
observed <- matrix(c(wt, mut), nrow=1, ncol=2) #created a table of observed values

exp <- matrix(c((wt+mut)*0.75, (wt+mut)*0.25), nrow=1, ncol=2)

Gvalue <- 2*sum(observed*log(observed/exp))
Gvalue 

#To get p-value
1-pchisq(Gvalue, df=1) #df = #categories-1

#Or an alternate way to do the same thing:
library(DescTools)
GTest(observed, p=c(0.75, 0.25))
#p is a list of expected probabilities in different groups.

#Or do a X2 test
X2test<- sum((observed-exp)^2/exp)
X2test
1-pchisq(X2test, df=1)



###################
# Question 3
###################

rm(list=ls())

noheadache<-c(58,33)
headache<-c(61,21)

#Set up our table of observed and expected value:
observed <- matrix(c(noheadache, headache), nrow=2, ncol=2) #created a table of observed values
# or observed <- matrix(c(58,61,33,21),nrow=2,ncol=2)
library(DescTools)
GTest(observed,correct="none")
# or GTest(observed,p=c(0.5, 0.5, 0.5, 0.5))


###################
# Question 4
###################

rm(list=ls())

mydata <- read.csv("Data/PS7/PS7_4.csv")
View(mydata)

library(lme4)
model1<-glm(Votes~Race:Candidate + Gender:Candidate + Race:Gender:Candidate, family=poisson, data=mydata) # looking at the interaction of each demographic on their candidate choice and both sets of demographics on their candidate choice
anova(model1, test="Chisq")

# Race 4, 4 
# Gender 3, 8
# Gender:Race 4, 0
 




