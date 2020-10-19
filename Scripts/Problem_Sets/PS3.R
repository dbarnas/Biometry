# Problem Set 3

rm(list=ls())
library(tidyverse)
library(car)
library(lmodel2)
library(GGally)
library(mctest)
library(QuantPsyc)

###################
# Question 1
###################
data1<-read_csv('Data/crying_babies.csv')
ggplot(data1,aes(x=cryduration,y=IQ))+
  geom_point()+
  labs(x='Cry Duration (minutes)',y='IQ')+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ggsave('Output/PS3_1.png')

#Analyze the data with three different tests of correlation: 
#Pearson’s r, Spearman's rho, and Kendall's tau

qqp(data1$cryduration, "norm")
qqp(data1$IQ, "norm")

# Pearson's R: for linear relationships; calculated on ranks
#For Pearson's correlation
mytest1.a<-cor.test(data1$cryduration, data1$IQ, method="pearson", na.rm=TRUE)
mytest1.a

#The t-test tells you whether the correlation is significant.
#The last number in the output is the correlation coefficient (r)

# Spearman's rho: nonlinear relationships (non-parametric correlation coefficients); calculated on ranks
#For Spearman's rho
mytest1.b<-cor.test(data1$cryduration, data1$IQ, method="spearman", na.rm=TRUE)
mytest1.b
#Notice that you'll get a warning. The p-value won't be 100% correct, but will be very close.
#Note that the test runs anyway

# Kentall's tao: nonlinear relationships (non-parametric correlation coefficients); concordant and discordant pairs
#For Kendall's tau
mytest1.c<-cor.test(data1$cryduration, data1$IQ, method="kendall", na.rm=TRUE)
mytest1.c
#Same warning message as above. This is not terrible.


###################
# Question 2
###################
data2<-read_csv('Data/butterflyballot.csv')
plot(Bush~Buchanan, data=data2)

#outlier test
#Use Bonferroni test to identify
#This only works after you've already fit a model to your data
model2<-lm(Bush~Buchanan, data=data2)
outlierTest(model2)
#Tells you whether most extreme value has undue influence
#If P<0.05, then point is a potential outlier

# are vote totals between Bush and Buchanan correlated? 
# If you included Palm Beach County, does it appear to be outlier with respect to the other counties? 
# What do you infer about the effect of the butterfly ballot?

qqp(data2$Bush, "norm") # not normal
qqp(data2$Buchanan, "norm") # not normal

mytest2<-cor.test(data2$Bush, data2$Buchanan, method="spearman", na.rm=TRUE)
mytest2

# do a spearman's because that means it doens't need to be normal

# Appears point 67 (Palm Beach is an outlier p < 3.3e-13)
# remove point 67
data2b<-data2[-67,]
plot(Bush~Buchanan, data=data2)

# are vote totals between Bush and Buchanan correlated? 
# If you included Palm Beach County, does it appear to be outlier with respect to the other counties? 
# What do you infer about the effect of the butterfly ballot?

qqp(data2b$Bush, "norm") # not normal
qqp(data2b$Buchanan, "norm") # not normal

mytest2b<-cor.test(data2b$Bush, data2b$Buchanan, method="spearman", na.rm=TRUE)
mytest2b

data2.log<-data2%>%
  mutate(logBush=log(Bush), logBuchanan=log(Buchanan))
plot(logBush~logBuchanan, data=data2.log) # linear relationship. use Pearson's r
mytest2<-cor.test(data2.log$logBush, data2.log$logBuchanan, method="pearson", na.rm=TRUE)
mytest2

data2.log<-data2.log[-67,]

###################
# Question 3
###################

#calculate y-hat
# plug in the x you get with your slope and intercept
# then use that to get MS(model) and MS(error)
# can get f-value from there!

# ordinary least squares is the best fit line
# we get an f value and p value that allows us to reject the null, if x drives y or not
# r2 tells us how much it actually effects it

# F = 30.36

###################
# Question 4
###################

data4<-read_csv('Data/streams.csv')

# a)

#We're going to ask whether the length of the snail determines its weight.
#So let's fit a model that describes that relationship
#The command 'lm' fits a linear model
model4<-lm(NumberSpp~Biomass, data=data4, na.action="na.omit")
summary(model4)
#how to make plot
#There are lots of options to add on here (I'm using Base Plot code here)
#In the simplest form:
plot(NumberSpp~Biomass, data=data4, col="blue", xlab="Biomass (mg/m2)", ylab="Species Richness")
abline(model4, col="blue") #adds fit from the model

# b)

#Before we look at the results, let's test the assumptions of the model
#We can call the residuals of the model as:
resid(model4) #better to name these as something
model4res<-resid(model4)

#Now we can test the normality of the residuals
qqp(model4res, "norm") # not normal

#We can also call the fitted y values as:
fitted(model4) #This is the predicted value of y, for each value of x

#To test for homogeneity of variance, we want to plot the fitted (predicted) values
#against the residuals
plot(model4res~fitted(model4))

#A shortcut to doing all of the above.
plot(model4) #gives plots that show normality, homogeneity of variance, and potential outliers

#With the leverage plot, you want values Cook's distance less than 1:
plot(model4, 4)

## need to transform the data

#log NumberSpp # not useful
data4.splog<-data4%>%
  mutate(Spp.log = log(NumberSpp))
model1.splog<-lm(Spp.log~Biomass, data=data4.splog, na.action="na.omit")
model1res.splog<-resid(model1.splog)
qqp(model1res.splog, "norm") # still not great
plot(model1res.splog~fitted(model1.splog))
plot(model1.splog)

#log Biomass
data4.blog<-data4%>%
  mutate(Biomass.log = log(Biomass))
model4.blog<-lm(NumberSpp~Biomass.log, data=data4.blog, na.action="na.omit")
summary(model4.blog)
model4res.blog<-resid(model4.blog)
qqp(model4res.blog, "norm") # still not great
plot(model4res.blog~fitted(model4.blog))
plot(model4.blog)

# log all data
data4.log<-data4%>%
  mutate(Biomass.log = log(Biomass), Spp.log = log(NumberSpp))
model4.log<-lm(Spp.log~Biomass.log, data=data4.log, na.action="na.omit")
summary(model4.log)
resid(model4.log) #better to name these as something
model4res.log<-resid(model4.log)
qqp(model4res.log, "norm") # much more normal than raw data
plot(model4res.log~fitted(model4.log))
plot(model4.log)

# c)

#Use Bonferroni test to identify
#This only works after you've already fit a model to your data
outlierTest(model4.blog)
#Tells you whether most extreme value has undue influence
#If P<0.05, then point is a potential outlier

#Can also use Cook's D
influencePlot(model4.blog) #Points greater than 1 are potential outliers

# R^2 value when you multiply by 100 tells you the percent that x explains the y variable

###################
# Question 5
###################

# surface area ~ height

data5<-read_csv("Data/algae.csv")

# a)
plot(Surface_area~Height, data=data5, col="blue", xlab="Height (cm)", ylab="Surface Area (cm2)")

model5<-lm(Surface_area~Height, data=data5, na.action="na.omit")
abline(model5, col="blue") #adds fit from the model

#want to add confidence intervals to the regression line?
prd<-predict(model5, interval="confidence")
#the above gives a table with predicted values and upper and lower confidence intervals
lines(data5$Height, prd[,2], lty=2) #adds lower CL
lines(data5$Height, prd[,3], lty=2) #adds upper CL

# b)

resid(model5)
model5res<-resid(model5)
qqp(model5res, "norm")
plot(model5res~fitted(model5))

# log transform y first
data5.ylog<-data5%>%
  mutate(SA.log = log(Surface_area))
model5.ylog<-lm(SA.log~Height, data=data5.ylog, na.action="na.omit")
summary(model5.ylog)
model5res.ylog<-resid(model5.ylog)
qqp(model5res.ylog, "norm") # still not great
plot(model5res.ylog~fitted(model5.ylog))
plot(model5.ylog)

# log transform x next on top of y
data5.log<-data5%>%
  mutate(SA.log = log(Surface_area),H.log = log(Height))
model5.log<-lm(SA.log~H.log, data=data5.log, na.action="na.omit")
summary(model5.log)
model5res.log<-resid(model5.log)
qqp(model5res.log, "norm") # still not great
plot(model5res.log~fitted(model5.log))
plot(model5.log)

# c)
outlierTest(model5.log) # Bonferroni test 
# rather than use this, reprot the graph of Cook's D (form the plot(model5.log))
influencePlot(model5.log) # Cook's D
plot(model5.log,4) # Cook's D

# e)
model5.log<-lm(SA.log~H.log, data=data5.log, na.action="na.omit")
summary(model5.log)

# the % error is the residual error divided by the mean
# percent error of the linear regression model is the 
# residual error/mean Y * 100 
# gives percentage of difference b/w the prediction and the observed value = percent error

###################
# Question 6
###################

# multiple regression

data6<-read_csv("Data/krat.csv")

# dependent variable: density of kangaroo rafs in 50, one-hectare plots
# independent variables: 
### shrub cover (i.e. amount of shelter)
### annual seed production (i.e. amount of food)
### and snake density (i.e. predator threat)

model6.a<-lm(krat_density~shrubcover, data=data6, na.action="na.omit")
plot(model6.a) # check assumptions are met
summary(model6.a) # view statistics
m6a<-resid(model6.a)
qqp(m6a, "norm") # still not great
plot(m6a~fitted(model6.a))

model6.b<-lm(krat_density~seedproduction, data=data6, na.action="na.omit")
plot(model6.b)
summary(model6.b)
m6b<-resid(model6.b)
qqp(m6b, "norm") # still not great
plot(m6b~fitted(model6.b))

model6.c<-lm(krat_density~snakedensity, data=data6, na.action="na.omit")
plot(model6.c)
summary(model6.c)
m6c<-resid(model6.c)
qqp(m6c, "norm") # still not great
plot(m6c~fitted(model6.c))

#First we want to know which model fits the data best. Here's the full model:
fullmodel<-lm(krat_density~shrubcover + seedproduction + snakedensity, data=data6)

# check for collinearity
X<-data6[,c(2,3,4)] #gives you all the rows for just columns 4,6, and 7
ggpairs(X)
# shrub cover is highly positively correlated to seed production (R = 0.959)

#To get actual numbers on collinearity better test:
imcdiag(fullmodel) # Klein number is 1 for both shrub and seed production

#Now let's make every other possible model:
reduced1<-lm(krat_density~shrubcover + seedproduction, data=data6)
reduced2<-lm(krat_density~seedproduction + snakedensity, data=data6)
reduced3<-lm(krat_density~shrubcover + snakedensity, data=data6)

#Now let's get AIC for each model, looking for the lowest value.
AIC(fullmodel)
AIC(reduced1)
AIC(reduced2)
AIC(reduced3) # lowest AIC, closely followed by the full model. removes colinearity as well
AIC(model6.a)
AIC(model6.b)
AIC(model6.c)

summary(reduced3)
m.reduced<-resid(reduced3)
qqp(m.reduced, "norm") # still not great
plot(m.reduced~fitted(reduced3))


#To get the partial standardized regression coefficients for each factor
lm.beta(reduced3)
