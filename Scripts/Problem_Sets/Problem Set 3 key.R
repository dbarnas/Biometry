#Problem Set 3 Key
#Created by C. terHorst 9/23/20
#Edited on 9/23/20


###############################
###Question 1: Crying Babies###
###############################
#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/crying_babies.csv")
View(mydata)

#First make a scatterplot
plot(cryduration~IQ, data=mydata)

#Then do each type of correlation test
mytest1<-cor.test(mydata$cryduration, mydata$IQ, method="pearson")
mytest1

mytest2<-cor.test(mydata$cryduration, mydata$IQ, method="spearman")
mytest2

mytest3<-cor.test(mydata$cryduration, mydata$IQ, method="kendall")
mytest3

#Pearson's is the more powerful test, but it also requires normality. Both variables
#have to be normal
library(car)
qqp(mydata$cryduration, "norm")
qqp(mydata$IQ, "norm")

#These both look mostly normal, so we should use Pearson's. But there are a few points
#that fall outside the confidence limits, so Spearman's is not a terrible choice.

##############################
###Question 2: Bush v. Gore###
##############################

rm(list=ls())

#Import the data
mydata <- read.csv("Data/butterflyballot.csv")
View(mydata)

#We want to first create a new data set without that last data point (Palm Beach County)
NoPalmBeach<-mydata[-67,]
View(NoPalmBeach)

#First, let's look at the plot to see if the data look linear
plot(Bush~Buchanan, data=NoPalmBeach)

#Pretty linear. Are the data normal?
library(car)
qqp(NoPalmBeach$Bush, "norm")  #no!
qqp(NoPalmBeach$Buchanan, "norm") #no!

#That means we should either use a Spearman correlation (does not assume normality)
#or transform the data. I'm going to go with Spearman's here
mytest1<-cor.test(NoPalmBeach$Bush, NoPalmBeach$Buchanan, method="spearman")
mytest1

#Or we could log transform our data and if it's normal, run a Pearson's correlation
NoPalmBeach$logBush<-log(NoPalmBeach$Bush)
NoPalmBeach$logBuchanan<-log(NoPalmBeach$Buchanan)
qqp(NoPalmBeach$logBush, "norm")
qqp(NoPalmBeach$logBuchanan, "norm")
#much more normal!
mytest2<-cor.test(NoPalmBeach$logBush, NoPalmBeach$logBuchanan, method="pearson")
mytest2

#No matter what method we use, we get a highly significant p-value

plot(logBush~logBuchanan, data=NoPalmBeach)

#Now let's look at the data with Palm Beach County included
mydata$logBush<-log(mydata$Bush)
mydata$logBuchanan<-log(mydata$Buchanan)

plot(logBush~logBuchanan, data=mydata)

#The outlier is even more obvious is we plot it not on a log scale
plot(Bush~Buchanan, data=mydata)

#Let's do a formal outlier test
model1<-lm(Bush~Buchanan, data=mydata)
library(car)
outlierTest(model1)

#It looks like Palm County is a clear outlier. That doesn't mean we throw it out, but we 
#might ask why. It seems like MANY more people voted for Buchanan relative to the number
#who voted for Bush there.

####################################
###Question 4: Inverts in streams###
####################################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/PS3/streams.csv")
View(mydata)


plot(NumberSpp~Biomass, col="blue", data=mydata)
#Before we can fit a regression line, we need to describe the model 
#for this line

fit1<-lm(NumberSpp~Biomass, data=mydata)
abline(fit1, col="blue")

#Hmm, doesn't look linear

#Does this model meet the assumptions of linear regression?
#Well, first of all, this doesn't look like a linear relationship
#So let's try ln-transformation of biomass, as it is log-normally distributed
mydata$lnbiomass<-log(mydata$Biomass)
plot(NumberSpp~lnbiomass, col="blue", data=mydata)
fit2<-lm(NumberSpp~lnbiomass, data=mydata)
abline(fit2, col="blue")

#Ok, now let's use the residuals to check the rest of our assumptions
residuals2<-residuals(fit2)
library(car)
qqp(residuals2, "norm")

#You can see that they're pretty much within the bounds of what we'd expect for normality

#Ok, so what about homogeneity of variance? Let's plot the residuals against our fitted values
fitted2<-fitted(fit2)
plot(residuals2~fitted2)
abline(h=0)
#This looks good because the data appear evenly distributed both vertically and horizontally

#Here's a shortcut to getting all of the diagnostic plots you need
plot(fit2)

#With the leverage plot, you want values Cook's distance less than 1:
plot(fit2,4)

#Finally, to test whether this model is significant
summary(fit2)


############################################
###Question 5: Predict algal surface area###
############################################

#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "algae"
mydata <- read.csv("Data/algae.csv")
View(mydata)

fit1<-lm(Surface_area~Height, data=mydata)
plot(Surface_area~Height, col="blue", data=mydata)
abline(fit1, col="blue")


#Let's test assumptions
library(car)
plot(fit1)
resid<-residuals(fit1)
plot(resid~mydata$Height, ylab="Residuals of Surface Area")
abline(h=0)
#kinda looks like much more variance on the right side than the left
qqPlot(fit1) #and some normality problems


#Try ln-transformation of both variables
mydata$lnHeight<-log(mydata$Height)
mydata$lnSA<-log(mydata$Surface_area)

fit2<-lm(lnSA~lnHeight, data=mydata)
plot(fit2)
resid2<-residuals(fit2)
plot(resid2~lnHeight, ylab="Residuals from ln-transformation", data=mydata)
abline(h=0) #looks much better
qqp(resid2, "norm") #pretty normal

#to get r^2 for the model and statistics
summary(fit2)
plot(lnSA~lnHeight, data=mydata)
abline(fit2)

#Check for outliers:
outlierTest(fit2) #no outliers

#Check for high leverage points
plot(fit2,4)


#Or I can make a better plot with confidence limits in ggplot
library(ggplot2)
ggplot(mydata, aes(x=lnHeight, y=lnSA))+
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point(shape=1) + 
  guides(fill=FALSE) + 
  ylab("ln Surface Area") +
  xlab("ln Height") +
  geom_smooth(method="lm")

#Because we're particularly interested in the value of the slope here,
#and because there is error in the measure of x and y, we really should use a 
#model II regression.
library(lmodel2)
model1<-lmodel2(lnSA~lnHeight, range.y="relative", range.x="relative", data=mydata, nperm=99)
model1 #Use these parameters (from RMA) to get estimates of slope and intercept

plot(model1, xlab="ln Height", ylab="ln Surface Area")

###############################
###Question 6: Kangaroo Rats###
###############################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/PS3/krat.csv")
View(mydata)


#First let's see what we would find if we just did 3 simple linear regressions
covermodel<-lm(krat_density~shrubcover, data=mydata)
seedmodel<-lm(krat_density~seedproduction, data=mydata)
snakemodel<-lm(krat_density~snakedensity, data=mydata)

plot(krat_density~shrubcover, data=mydata)
abline(covermodel)

plot(krat_density~seedproduction, data=mydata)
abline(seedmodel)

plot(krat_density~snakedensity, data=mydata)
abline(snakemodel)

#Quick check that assumptions are met
plot(covermodel)
plot(seedmodel)
plot(snakemodel)
#Looks like all assumptions are met

#Stats for individual regressions
summary(covermodel)

summary(seedmodel)

summary(snakemodel)

#Now let's do a multiple regression

#First we want to know which model fits the data best. Here's the full model:
fullmodel<-lm(krat_density~shrubcover+seedproduction+snakedensity, data=mydata)

#To check for collinearity in your data:
library(GGally)
X<-mydata[,c(2,3,4)] #gives you just columns 2,3,4
ggpairs(X)

#To get actual numbers on collinearity better test:
library(mctest)
imcdiag(fullmodel)

#Get the AIC value for this model
AIC(fullmodel)

#Looks like we have a problem with co-linearity between shrubcover and seedproduction
#Let's keep that in mind as we proceed

#Now let's make every other possible model:
reduced1<-lm(krat_density~shrubcover+seedproduction, data=mydata) #We might be cautious with this model because these variables are co-linear
reduced2<-lm(krat_density~shrubcover+snakedensity, data=mydata)
reduced3<-lm(krat_density~seedproduction+snakedensity, data=mydata)

#We also have the simple models above to use. Let's get the AIC value for each model:
AIC(fullmodel)
AIC(reduced1)
AIC(reduced2)
AIC(reduced3)
AIC(covermodel)
AIC(seedmodel)
AIC(snakemodel)

#We could use the full model (but has collinearity problems), 
#and the model with only shrubcover and snake density is slightly better anyway.
#Because the difference in AIC is <2, you can use either model, but in general
#we want to choose simpler models (And reduced2 is slightly better fit too)

summary(reduced2)

#Here's a more traditional ANOVA table, if you like that output better
#It gives F tests instead of t...and gives df

anova(reduced2)

#We can quickly check for homogeneity of variances of the full model:
predicted<-fitted(reduced2)
resid<-residuals(reduced2)
plot(resid~predicted)
abline(h=0)
#Don't see any pattern in the variances there

#And check normality
library(car)
qqp(resid)
#Looks normal

#To get the partial standardized regression coefficients for each factor
library(QuantPsyc)
lm.beta(reduced2)
#Shrub cover is about four times as important as snake density, but both factors
#have significant effects on kangaroo rat abundance

#Just for fun, here's what the 3D-plot of this multiple regression would look like
library(rockchalk)
plotPlane(reduced2, plotx1="shrubcover", plotx2="snakedensity")

