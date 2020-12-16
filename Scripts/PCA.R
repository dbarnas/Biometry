#Multivariate Analyses
#PCA: Principal Components Analysis

rm(list=ls()) #Clears the environment

#Andrea measured a ton of morphological variables in many different species of spiders
#She has grouped those species together into Guilds: 
#Web Builders, Fishers, Foliage Runners, Jumpers, and Wanderers
#She wants to know whether traits differ between guilds
#She has measured 38 different traits, standardized them by total body mass
#In the data file, she has renamed these traits a, b, c, etc.
#I'd normally advise against this because you're going to want those trait names in R at some point
#However, for now, it makes less typing for us


#Import the Data
spiders<-read.csv("Data/spiders.csv")
View(spiders)

#Before we can use this data file, R wants ONLY trait data in order to do the PCA
#In other words, we need to get rid of the Guild column in our data set (just to get PCA scores)
#So let's subset our data, but without the Guild column
#to subset without guild, which if the first column:

spiders1<-spiders[,-1] #so we'll just use this when we run the PC

#Ok, now we'll use that trait data to run the PCA

#First, to get all of our traits on the same scale, we'll convert them to z-scores
#You don't have to do this, but it is fairly common
spiders.scale<-scale(spiders1, scale=TRUE, center=TRUE)

#Run the PCA
PCAmodel<-princomp(spiders.scale, cor=FALSE)
#in princomp, the default is to use the covariance matrix. If you want to use the correlation
#matrix, then must change this to cor=TRUE. Here we converted to z-scores first, so all 
#variables are on the same scale and we can use the covariance matrix


summary(PCAmodel) #shows amount of variance explained by each axis
#This is actually a big wide table, with all 38 Principle Components
#It tells us the amount of variance explained by each axis, and the cumulative proportion of variance explained
#Axis 1 will always explain the most variation, Axis 2 the second most, etc.

#We can plot that data easily in a scree plot
plot(PCAmodel, type="lines")

#Or even better:
library(factoextra)
fviz_eig(PCAmodel)

PCAmodel$loadings #shows the loadings of each trait on each PC (make sure you scroll up to see the loadings)

PCAmodel$scores #gives output of the principal components for each individual on each PC

#If we want to use the PC scores for something else (maybe we want to use PC1 to run an ANOVA?)
#Then we can save a subset of that table

PC1<-PCAmodel$scores[,1] #asks for the first column of the table 
PC1
#And we could run a quick ANOVA to see if guilds differ in PC1 scores:
model1<-lm(PC1~spiders$Guild)
anova(model1)


#Another common thing to do with PCA is to make a biplot
biplot(PCAmodel, xlab="PC1", ylab="PC2")
#The black numbers are each individual spider. The red lines are the vectors for each trait.

#There are tons of options for playing around with the biplot. I'll just do this to make
#this look a bit better so we can see differences among guilds

#I like using ggbiplot
#library(devtools)
#install_github("vqv/ggbiplot") #You only need to download this package once

#In this biplot code, I'm going to separate the spiders by guild (so I need to use my non-subsetted data file)
#So I use the original file to refer to guilds, but the PCA data for everything else.
#I'm going to put confidence intervals around the individuals in each guild.


library(ggbiplot)
biplot<-ggbiplot(PCAmodel, obs.scale=1, var.scale=1, groups=spiders$Guild, ellipse=TRUE, varname.size=3, varname.adjust=1.2, circle=FALSE) +
  scale_color_discrete(name='') +
  geom_point(aes(colour=factor(spiders$Guild)), size = 1) + #Color codes by Guild
  theme(legend.direction = 'vertical', legend.position='right', legend.text=element_text(size=4))
biplot
