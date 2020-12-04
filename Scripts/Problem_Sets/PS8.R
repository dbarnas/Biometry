# PS8

###################
# Question 1
###################

rm(list=ls())

library(tidyverse)

mydata<-read_csv("Data/PS8/BahamasFish.csv")
mydata

#Before we can use this data file, R wants ONLY species density data in order to do the PCA
#In other words, we need to get rid of the Site column in our data set (just to get PCA scores)
#So let's subset our data, but without the Site column
#to subset without site, which is the first column:

mydata1<-mydata[,-1] #so we'll just use this when we run the PC

#First, to get all of our densities on the same scale, we'll convert them to z-scores
#You don't have to do this, but it is fairly common
mydata.scale<-scale(mydata1, scale=TRUE, center=TRUE)

#Run the PCA
PCAmodel<-princomp(mydata.scale, cor=FALSE)
#in princomp, the default is to use the covariance matrix. If you want to use the correlation
#matrix, then must change this to cor=TRUE. Here we converted to z-scores first, so all 
#variables are on the same scale and we can use the covariance matrix

summary(PCAmodel) #shows amount of variance explained by each axis
#It tells us the amount of variance explained by each axis, and the cumulative proportion of variance explained
#Axis 1 will always explain the most variation, Axis 2 the second most, etc.

#We can plot that data easily in a scree plot
plot(PCAmodel, type="lines")

#Or even better:
library(factoextra)
fviz_eig(PCAmodel)

PCAmodel$loadings #shows the loadings of each species on each PC (make sure you scroll up to see the loadings)

PCAmodel$scores #gives output of the principal components for each density measurement on each PC

## Use Principal Components Analysis to evaluate whether variation in the densities 
#of the four different species can be summarized by new, derived variables (components). 

#If we want to use the PC scores for something else (maybe we want to use PC1 to run an ANOVA?)
#Then we can save a subset of that table

PC1<-PCAmodel$scores[,1] #asks for the first column of the table 
PC1
#And we could run a quick ANOVA to see if sites differ in PC1 scores:
model1<-lm(PC1~mydata$Site)
anova(model1)

#Another common thing to do with PCA is to make a biplot
biplot(PCAmodel, xlab="PC1", ylab="PC2")
# the black numbers are each of the measured densities
# the red lines are the vectors for each species


# How much of the variation in density is explained by the first two principal components?



