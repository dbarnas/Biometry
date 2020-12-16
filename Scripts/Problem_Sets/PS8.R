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

# Z-SCORES
#First, to get all of our densities on the same scale, we'll convert them to z-scores
#You don't have to do this, but it is fairly common
mydata.scale<-scale(mydata1, scale=TRUE, center=TRUE)

# PCA
#Run the PCA
PCAmodel<-princomp(mydata.scale, cor=FALSE)
#in princomp, the default is to use the covariance matrix. If you want to use the correlation
#matrix, then must change this to cor=TRUE. Here we converted to z-scores first, so all 
#variables are on the same scale and we can use the covariance matrix

summary(PCAmodel) #shows amount of variance explained by each axis
#It tells us the amount of variance explained by each axis, and the cumulative proportion of variance explained
#Axis 1 will always explain the most variation, Axis 2 the second most, etc.

# PLOT
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

###################
# Question 2
###################

#Another common thing to do with PCA is to make a biplot
biplot(PCAmodel, xlab="PC1", ylab="PC2")
# the black numbers are each of the measured densities
# the red lines are the vectors for each species

library(ggbiplot)
biplot<-ggbiplot(PCAmodel, obs.scale=1, var.scale=1, groups=mydata$Site, ellipse=TRUE, varname.size=3, varname.adjust=1.2, circle=FALSE) +
  scale_color_discrete(name='') +
  geom_point(aes(colour=factor(mydata$Site)), size = 1) + #Color codes by Guild
  theme(legend.direction = 'vertical', legend.position='right', legend.text=element_text(size=8))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ggsave("Output/PS8_1.png")
biplot

###################
# Question 3
###################

PC1<-PCAmodel$scores[,1] #asks for the first column of the table 
PC1
#And we could run a quick ANOVA to see if sites differ in PC1 scores:
model1<-lm(PC1~mydata$Site)
anova(model1)


###################
# Question 4
###################

rm(list=ls())

library(tidyverse)

mydata<-read_csv("Data/PS8/lizardcolor.csv")
View(mydata)

#Ok, let's do a Discriminant Function Analysis

library(MASS)

lizards.dfa <- lda(substrate~., data=mydata, CV=FALSE) 
#this is your DFA. #LDA= Linear Discriminant Analysis
#CV determines whether you're using the standard classification matrix
#If FALSE, then standard classification matrix. If TRUE, then uses jackknife matrix
#Note that we get a warning message that the variables are collinear. So we probably
#should be using a subset of the variables, but we're going to ignore that for now

lizards.dfa

#Assess the accuracy of the prediction and get %correct assignment for each Guild

predicted <- predict(lizards.dfa)
assignmatrix <- table(mydata$substrate, predicted$class) #R just automatically calls the groups 
#"class" in the output
diag(prop.table(assignmatrix, 1)) #shows % of correct assignments to each group

sum(diag(prop.table(assignmatrix))) #gives total correct assignment



###################
# Question 5
###################

rm(list=ls())

library(tidyverse)
library(vegan)

mydata<-read_csv("Data/PS8/Bumpus.csv")
View(mydata)


### Split the data by sex
male<-mydata%>%
  filter(Sex=="m")
female<-mydata%>%
  filter(Sex=="f")

### Use perMANOVA to determine whether the birds that survived the storm had different morphologies than birds that died


malePermanovaModel<-adonis(male[,-(1:4)]~Survival, male, permutations = 999, method="bray") # remove columns 1:4 not containing numerical data
malePermanovaModel

femalePermanovaModel<-adonis(female[,-(1:4)]~Survival, female, permutations = 999, method="bray")
femalePermanovaModel

# check assumption of even dispersion of data; male to female
disper<-vegdist(mydata[,-(1:4)])
betadisper(disper, mydata$Sex) # look fine
#Look at the Average distance to median...these numbers should be reasonably similar
#A rule of thumb is that one number should not be twice as high as any other

#An option for doing post-hoc pairwise comparisons in R
library(pairwiseAdonis)
#male
pairwise.adonis(male[,-(1:4)], male$Survival, perm=999)
#female
pairwise.adonis(female[,-(1:4)], female$Survival, perm=999)

#Get coefficients to see which traits are most important in explaining survival differences:
malePermanovaModel$coefficients
femalePermanovaModel$coefficients

### Include an nMDS plot for each sex.


#create the ordination output using bray curtis dissimilarity matrix
Mord<-metaMDS(male[,-(1:4)],k=2, distance='bray') 
Ford<-metaMDS(female[,-(1:4)],k=2, distance='bray') 
#distance = is the type of dissimilarity matrix
#k is number of dimensions (you can try different ones to look at different stress)

# if it does not converge add more iterations (not necessary in this case)
#ord<-metaMDS(mydata[,-(1:4)],k=2, distance='bray', trymax = 30) #add more iterations

#let's look at the stress with k=2 dimensions. Is it < 0.3? 
Mord$stress
Ford$stress
# It is 0.2 which is "good/ok". Would it help to add a third dimension?
Mord2<-metaMDS(male[,-(1:4)],k=3, distance='bray', trymax=30) 
Mord2$stress
Ford2<-metaMDS(female[,-(1:4)],k=3, distance='bray', trymax=30) 
Ford2$stress

#That's a little better, so we might want that one. But for simplicity, I'm going to
#stick with two dimensions, which was ok

# Let's look at the stress plot
stressplot(Mord)
stressplot(Ford)
# looks like a good fit, want to minimize scatter

# basic plot
# dots represent Survival (True or False) and + represents our morphological traits
#male
ordiplot(Mord) 
ordiplot(Mord, type = 'text') # add text
#female
ordiplot(Ford)
ordiplot(Ford, type = 'text') # add text

# MALE
# let's make a better plot
#You will need to play with the x and y lim to get a graph that best shows differences
plot(1, type='n', xlim=c(-0.01,0.011), ylim=c(-0.01,0.01), xlab='nMDS1', 
     ylab='nMDS2', xaxt='n', yaxt='n')
points(Mord$points[male$Survival=='TRUE',1],Mord$points[male$Survival=='TRUE',2], 
       pch=19, col='red', cex=2)
points(Mord$points[male$Survival=='FALSE',1],Mord$points[male$Survival=='FALSE',2], 
       pch=19, col='purple', cex=2)


# let's add a circle around all points by groups
ordiellipse(Mord, groups=male$Survival, label=F, kind='ehull', border='white', col=c('purple','red'), lwd=2, draw ='polygon')
# if you want to make the circles Standard deviations
#ordiellipse(Mord, groups=male$Survival, kind='sd', border='white', col=c('purple','red'), lwd=2, draw ='polygon')

# can add or remove labels 
#other options # just draw a polygon
#ordihull(Mord, groups=male$Survival, col=c('purple','red'))
#add site labels
ordispider(Mord, groups=male$Survival, col=c('purple','red'), label = T)# make a spider plot
#add a legend with stress
legend('topleft', legend = paste('2D stress = ', round(Mord$stress,2)), bty='n')
#add a Site legend
legend('topright',legend=c('Deceased (FALSE)','Survived (TRUE)'),
       col=c('purple','red'), pch=19, bty='n')


# FEMALE
# let's make a better plot
#You will need to play with the x and y lim to get a graph that best shows differences
plot(1, type='n', xlim=c(-0.018,0.011), ylim=c(-0.009,0.011), xlab='nMDS1', 
     ylab='nMDS2', xaxt='n', yaxt='n')
points(Ford$points[female$Survival=='TRUE',1],Ford$points[female$Survival=='TRUE',2], 
       pch=19, col='red', cex=2)
points(Ford$points[female$Survival=='FALSE',1],Ford$points[female$Survival=='FALSE',2], 
       pch=19, col='purple', cex=2)

# let's add a circle around all points by groups
ordiellipse(Ford, groups=female$Survival, label=F, kind='ehull', border='white', col=c('purple','red'), lwd=2, draw ='polygon')
# if you want to make the circles Standard deviations
#ordiellipse(Ford, groups=female$Survival, kind='sd', border='white', col=c('purple','red'), lwd=2, draw ='polygon')

# can add or remove labels 
#other options # just draw a polygon
ordihull(Ford, groups=female$Survival, col=c('purple','red'))
#add site labels
ordispider(Ford, groups=female$Survival, col=c('purple','red'), label = T)# make a spider plot
#add a legend with stress
legend('topleft', legend = paste('2D stress = ', round(Ford$stress,2)), bty='n')
#add a Site legend
legend('topright',legend=c('Deceased (FALSE)','Survived (TRUE)'),
       col=c('purple','red'), pch=19, bty='n')





