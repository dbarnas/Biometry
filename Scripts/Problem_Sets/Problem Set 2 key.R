###R code I used to complete Problem Set 2
###Created 9/10/2020

#####################
###Questions 1 - 6###
#####################

#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "microcosm"
mydata <- read.csv("Data/kelp bass gonad mass.csv")
View(mydata)

mean(mydata$gonad_mass)
median(mydata$gonad_mass)
var(mydata$gonad_mass)
sd(mydata$gonad_mass)
CV<-sd(mydata$gonad_mass)/mean(mydata$gonad_mass)
CV

#to get skewness and kurtosis, I use the moments package
library(moments)
skewness(mydata$gonad_mass)
kurtosis(mydata$gonad_mass)


#To add 5 to each value, let's make a new column named mass5 that adds 5 to each value to gonad_mass
mydata$mass5<-mydata$gonad_mass+5
mean(mydata$mass5)
median(mydata$mass5)
var(mydata$mass5)
sd(mydata$mass5)
CV<-sd(mydata$mass5)/mean(mydata$mass5)
CV

skewness(mydata$mass5)
kurtosis(mydata$mass5)

#To add 5 and then multiply by 10, let's use mass5 (already added 5) and multiply by 10
mydata$mass10<-mydata$mass5*10

mean(mydata$mass10)
median(mydata$mass10)
var(mydata$mass10)
sd(mydata$mass10)
CV<-sd(mydata$mass10)/mean(mydata$mass10)
CV

skewness(mydata$mass10)
kurtosis(mydata$mass10)

#to make histogram:
hist(mydata$gonad_mass)

#to convert to z scores
#Center centers the data on the mean (subtracts mean); Scale divides by s.d.
zscoremass<-scale(mydata$gonad_mass, center=TRUE, scale=TRUE) 

hist(zscoremass)
skewness(zscoremass)
kurtosis(zscoremass)

#to get probability plot
qqnorm(mydata$gonad_mass)
qqline(mydata$gonad_mass)

#or if you want to get confidence limits on that normal prediction line
library(car)
qqp(mydata$gonad_mass, "norm")


######################
###Question 7 and 8###
######################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/Agaricia.csv")
View(mydata)

#Are the data normally distributed?
#There are several ways we could look at this graphically

#create box plot for raw data
boxplot(mydata$weight, main="weight")
#if the line is roughly in the middle of the box and the whiskers are about equal, that's
#a good sign of normality. This is close. Is it close enough?

#Could look at a histogram
hist(mydata$weight)
#meh, kinda normal-ish? Hard to tell.

#Why don't we just use a probability plot
library(car)
qqp(mydata$weight, "norm")
#yeah, that looks pretty solid

#lets try to log-transform the data anyway to see what happens
mydata$logweight<-log(mydata$weight)

boxplot(mydata$logweight, main="logweight")
hist(mydata$logweight)
qqp(mydata$logweight, "norm")

#original data looks pretty good. Transformation might make it a tiny bit worse.

#Question 12
#Let's bootstrap our sample
bootmeans<-replicate(1000, { #this tells R I want it to do the same thing 1000 times; open brackets start a function  
  samples<-sample(mydata$weight,replace=TRUE); 
  mean(samples)  })
#Now you have 1000 different estimates of the mean, based on your 1000 random samples
#You can see them by typing
bootmeans
#We can just take the mean of our bootstrapped means to get
mean(bootmeans) #the more bootstrapped samples we use, the closer to the population mean we should get

#You could calculate the confidence interval just as we have before.
#With bootstraps, it's nice because exaclty one of your values represents the 95% confidence limit
#To get confidence interval:
sortedboots<-sort(bootmeans)
#Now our 1000 means are sorted in order. If we'd done 1000 bootstraps, then the 25th value would be the lower CL and the 975th sample would be the lower CL
lowCI<-sortedboots[25]
highCI<-sortedboots[975]
lowCI
highCI

hist(sortedboots) #Makes a histogram of our 1000 bootstraps
#To add vertical lines for the two confidence limits
abline(v=lowCI, col="blue")
abline(v=highCI, col="blue")
#The above command says, put a vertical line (v) at the value of the low CI and make the line blue
#Note that if you had calculated the 95% CI, this value would be mean - 95% CI. And the 
#upper value would be mean + 95% CI.


################
###Question 9###
################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/BarnacleRecruitment.csv")
View(mydata)

#Exploring the data. Are assumptions met?
#Normality
hist(mydata$recruitment)
library(car)
qqp(mydata$recruitment, "norm")
#doesn't look great at the lower end

#let's try a formal test
shapiro.test(mydata$recruitment)
#suggests that it is not normal

#ok, let's try a log transformation
mydata$logrecruit<-log(mydata$recruitment+1)
hist(mydata$logrecruit)
qqp(mydata$logrecruit, "norm")
shapiro.test(mydata$logrecruit)
#not much better

#what about a square-root transformation
mydata$sqrtrecruit<-sqrt(mydata$recruitment+0.5)
hist(mydata$sqrtrecruit)
qqp(mydata$sqrtrecruit, "norm")
shapiro.test(mydata$sqrtrecruit)
#better. Not great

#What about homogeneity of variances
library(tidyr)
library(dplyr)
SummaryByGroup <- mydata %>%
  group_by(Site) %>%
  summarize(variance=var(recruitment, na.rm=TRUE))
SummaryByGroup
boxplot(recruitment~Site, data=mydata)

#Not too different
#Let's check with Bartlett's test
bartlett.test(mydata$recruitment~mydata$Site)

#Assumptions are slightly violated, so we might be cautious is the results are borderline
#But let's just stick with the raw data
#First, make a graph
library(tidyr)
library(dplyr)
graphdata <- mydata %>%
  group_by(Site) %>%
  summarize(meanrecruit=mean(recruitment, na.rm=TRUE), se=sd(recruitment, na.rm=TRUE)/sqrt(length(na.omit(recruitment))))
graphdata

#And now to the graph
library(ggplot2)
ggplot(graphdata, aes(x=Site, y=meanrecruit)) +
   theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
           panel.background = element_blank(), axis.line = element_line(colour = "black")) +
    geom_bar(stat="identity", color="dodgerblue2", fill="dodgerblue2", position="dodge", size=0.6) +
    labs(x="Site", y="recruitment (#/4cm^2)") +
    geom_errorbar(aes(ymax=meanrecruit+se, ymin=meanrecruit-se), position=position_dodge(0.9), width=0.1)

#Do the t-test by hand

######################
###Question 10 - 12###
######################

#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "urchins"
mydata <- read.csv("Data/urchins.csv")
View(mydata)
#I named my sites 1 and 2, which R thinks are integers, so I need to change 
#that to a factor
mydata$Site<-as.factor(mydata$Site)

#First let's get the means and standard deviations for each group
library(tidyr)
library(dplyr)
SummaryByGroup <- mydata %>%
  group_by(Site) %>%
  summarize(mean=mean(Urchins, na.rm=TRUE), std_dev=sd(Urchins, na.rm=TRUE))
SummaryByGroup

#And now let's do a t-test.
#First, with pooled variances
mytest1<-t.test(Urchins~Site, var.equal=TRUE, data=mydata)
mytest1

#Second, with separate variances
mytest2<-t.test(Urchins~Site, var.equal=FALSE, data=mydata)
mytest2

#Hmm, different answers. Well, are the variances really equal?
SummaryByGroup <- mydata %>%
  group_by(Site) %>%
  summarize(variance=var(Urchins, na.rm=TRUE))
SummaryByGroup

#Could also look at a box plot to see the variances
boxplot(Urchins~Site, data=mydata)

#And now to make a graph. You could use that boxplot, if you label it appropriately. 
#Or you can make a bar plot
#First gather the means and se we need to make the plot
library(tidyr)
library(dplyr)
graphdata <- mydata %>%
  group_by(Site) %>%
  summarize(mean=mean(Urchins, na.rm=TRUE), se=sd(Urchins, na.rm=TRUE)/sqrt(length(na.omit(Urchins))))
graphdata

#And now to the graph
library(ggplot2)
ggplot(graphdata, aes(x=Site, y=mean)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  geom_bar(stat="identity", color="dodgerblue2", fill="dodgerblue2", position="dodge", size=0.6) +
  labs(x="Site", y="Urchins (#cm^2)") +
  geom_errorbar(aes(ymax=mean+se, ymin=mean-se), position=position_dodge(0.9), width=0.1)




###############################
###Question 13: butterflies####
###############################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/CoastBuckwheat.csv")
View(mydata)

#Are the data normally distributed?
library(car)
qqp(mydata$Density, "norm")
#This looks pretty good

#Let's do a one-sample t-test to see if the mean is significantly different from 4
mytest<-t.test(mydata$Density, mu=4, na.rm=TRUE)
mytest

#And let's make a graph
#I used a different approach here, just for variety, but you can also do this in ggplot
meandensity<-mean(mydata$Density)
library(Rmisc)
ciDensity<-CI(mydata$Density, ci=0.95)[1] #You could also get the CI in ways that we have before
confidence<-ciDensity-meandensity
barplot1<-barplot(meandensity, width=0.15, xlim=c(0,0.5), ylim=c(0,10), col="DodgerBlue", ylab="Plant Density (#/25m^2)")
arrows(barplot1, meandensity+confidence, barplot1, meandensity, angle=90, code=1)
arrows(barplot1, meandensity-confidence, barplot1, meandensity, angle=90, code=1)
abline(h=0, lwd=2)
abline(h=4, lty=2)

###############################
###QUESTION 14: Sports drink###
###############################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/RunTimes.csv")
View(mydata)

#To test normality, we want to know if the DIFFERENCES are normally distributed
mydata$Difference<-mydata$Water-mydata$Sportsdrink
library(car)
qqp(mydata$Difference, "norm")
#great!

#Now let's do a paired t-test
mytest<-t.test(mydata$Water, mydata$Sportsdrink, paired=TRUE)
mytest

meanWater<-mean(mydata$Water)
meanDrink<-mean(mydata$Sportsdrink)
EffectSize<- (meanWater-meanDrink)/meanWater
EffectSize

