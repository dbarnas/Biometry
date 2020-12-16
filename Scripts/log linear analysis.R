#How to analyze frequencies

#Chi-square and G-tests
#Let's say we looked at frequency of feeding in some animal
#We watched them for an hour and for each animal, we recorded whether they ate or not.

#Clear the environment
rm(list=ls())

#In total, we observed 600 mice
ate<-375
noeat<-225

#Is this different than what we'd expect by random chance?

#Set up our table of observed and expected value:
observed <- matrix(c(ate, noeat), nrow=1, ncol=2) #created a table of observed values
#You will need to define the matrix by the number of rows and columns
#In order, you list the items in column 1, then the items in column 2, etc.

exp <- matrix(c((ate+noeat)*0.5, (ate+noeat)*0.5), nrow=1, ncol=2)
#In creating the expected values above, you will need to change this code depending
#on how many groups you have. Here I have multiplied the total times 0.5 because the expectation
#is that individuals should be split among two groups. But if there were 4 groups, then you would
#need to multiply by 0.25, for example.
#Or in other cases, your expectation may be something other than an even split among groups (Mendelian ratios, for example)

#To calculate G:
Gvalue <- 2*sum(observed*log(observed/exp))
Gvalue 

#To get p-value
1-pchisq(Gvalue, df=1) #df = #categories-1

#Or an alternate way to do the same thing:
library(DescTools)
GTest(observed, p=c(0.5, 0.5))
#p is a list of expected probabilities in different groups.
#Here I expected 50% in each group.
#But if I expected say, 75% in one group and 25% in another (depends on your null expectation),
#then I would use p=c(0.75, 0.25). If you have more than two categories, then you will need 
#a longer string of probabilities here.


#Or to do X2 test:
X2test<- sum((observed-exp)^2/exp)
X2test
1-pchisq(X2test, df=1)



#How to do log linear analysis

#Clear the environment
rm(list=ls())

#Imagine an experiment in which we had control and experimental plants. We also 
#did our experiment in four different seasons. At the end of the experiment, we measured the frequency of 
#plants in each plot that had either set fruit or not set fruit.
#To set up the data, we need to make a dataframe, just like we always do.
#You could do this in Excel and we'd have one column for Season (with four different seasons), one column for Treatment (exp or control), 
#one column for FruitSet (yes or no), and column for Frequency, which is the number that corresponds to each combination.

mydata <- read.csv("Data/PS7/Companion.csv")
View(mydata)


library(lme4)
model1<-glm(Frequency~Season:Fruit + Treatment:Fruit + Season:Treatment:Fruit, family=poisson, data=mydata)
anova(model1, test="Chisq")

#In the output, we're interested in the effect of Season, which is the Season:Fruit interaction
#and the effect of Treatment, which is Treatment:Fruit
#and the interactions between Season and Treatment, which is Season:Treatment:Fruit


