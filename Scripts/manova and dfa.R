#Multivariate Analyses

#MANOVA
#Discriminant Function Analysis

#We used Andrea's spider data as an example for PCA, but let's start over and instead 
#of doing a PCA, which is really for data exploration, we'll do a MANOVA 
#to test the hypothesis that guilds have different traits

#We need to create a matrix with all of our variables. 
#But actually for this data, I'm just going to use the first 10 variables because it
#makes the data set a bit more feasible for this example. You could use all the data if you wanted though
spiders<-read.csv("Data/spiders.csv")

spiders1<-spiders[,2:11] #remove guild names and take first 10 variables
View(spiders1)

#MANOVA wants this data in a matrix rather than a data frame
spiders1<-as.matrix(spiders1)

#Now to do the MANOVA
model1<-manova(spiders1~Guild, data=spiders)
summary(model1, test="Wilks")


#Now to test assumptions
# Graphical Assessment of Multivariate Normality
center <- colMeans(spiders1) # centroid
n <- nrow(spiders1); p <- ncol(spiders1); cov <- cov(spiders1); 
d <- mahalanobis(spiders1,center,cov) # distances 
qqplot(qchisq(ppoints(n),df=p),d)
abline(a=0,b=1)
#We can use the above code to basically create a qqplot to look at normality just as we have before

#An alternative is to make qqplots for each variable individually
library (ggpubr)
ggqqplot(spiders, "a", facet.by="Guild")
ggqqplot(spiders, "b", facet.by="Guild")
#Then continue to do this for each variable

#lots of deviation from normality, so we probably should log transform.
#But for simplicity and to save time having to transform each variable, 
#I'm going to use the raw data here.

#Check for homogeneity of covariances
library(corrplot)
source("http://www.sthda.com/upload/rquery_cormat.r")
rquery.cormat(spiders1)
#You want to look at the first matrix that show r values. We should be concerned 
#about collinearity if any of the r values are greater than 0.9. Here they are. 
#It's possible that if we log transform, this will no longer be the case. Otherwise
#we need to get rid of one or more of the collinear variables


#To see which traits are most important, we can quickly do all of the univariate ANOVAs:
univariates<-aov(spiders1~Guild, data=spiders)
summary(univariates)


#Or to get coefficients:
library(MASS)
manovacoeff<-lda(Guild~spiders1, data=spiders)
manovacoeff



###
#Ok, let's do a Discriminant Function Analysis

library(MASS)

spiders.dfa <- lda(Guild~., data=spiders, CV=FALSE) 
#this is your DFA. #LDA= Linear Discriminant Analysis
#CV determines whether you're using the standard classification matrix
#If FALSE, then standard classification matrix. If TRUE, then uses jackknife matrix
#Note that we get a warning message that the variables are collinear. So we probably
#should be using a subset of the variables, but we're going to ignore that for now

spiders.dfa

#Assess the accuracy of the prediction and get %correct assignment for each Guild

predicted <- predict(spiders.dfa)
assignmatrix <- table(spiders$Guild, predicted$class) #R just automatically calls the groups 
#"class" in the output
diag(prop.table(assignmatrix, 1)) #shows % of correct assignments to each group

sum(diag(prop.table(assignmatrix))) #gives total correct assignment


