# Barnas Final Practical

library(tidyverse)
#########################
# Question 3
#########################

rm(list=ls())

mydata<-read_csv("Data/Final/habitats.csv")
View(mydata)

#remove categorical data not used for PCA (Site and Transect)
mydata1<-mydata[,-(1:2)] #so we'll just use numerical data when we run the PC

# Z-SCORES
mydata.scale<-scale(mydata1, scale=TRUE, center=TRUE)

# remove density
mydata.scale.6<-mydata.scale[,-1]

# Run the PCA
PCAmodel<-princomp(mydata.scale.6, cor=FALSE)
summary(PCAmodel) #shows amount of variance explained by each axis in Proportion of Variance

PCAmodel$loadings #shows the loadings of each species on each PC (make sure you scroll up to see the loadings)

PCAmodel$scores #gives output of the principal components for each density measurement on each PC

# plot and save PCA
library(ggbiplot)
biplot<-ggbiplot(PCAmodel, obs.scale=1, var.scale=1, groups=mydata$Site, ellipse=TRUE, varname.size=3, varname.adjust=1.2, circle=FALSE) +
  scale_color_discrete(name='') +
  geom_point(aes(colour=factor(mydata$Site)), size = 1) + #Color codes by Guild
  theme(legend.direction = 'vertical', legend.position='right', legend.text=element_text(size=8))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggsave("Output/Final/Final_3.png")
biplot

# perMANOVA
library(vegan)
Model<-adonis(mydata[,-(1:3)]~Site, mydata, permutations = 999, method="bray") 
#determine whether the seven sites differ in habitat variables
Model # the sites differ p = 0.001

# check assumption of even dispersion of data
disper<-vegdist(mydata[,-(1:3)])
betadisper(disper, mydata$Transect) # look fine

#An option for doing post-hoc pairwise comparisons in R
library(pairwiseAdonis)
pairwise.adonis(mydata[,-(1:3)], mydata$Site, perm=999)

#Get coefficients to see which traits are most important in explaining differences:
Model$coefficients

# salinity is a pretty low predictor most of the time.

############################################################################################################
############################################################################################################
############################################################################################################
#### Multiple Regression

rm(list=ls())

mydata<-read_csv("Data/Final/habitats.csv")
View(mydata)

# need to log transform KelpBassDensity for normality (already ran through script with original data, and not normal)
mydata<-mydata%>%
  mutate(Density=log(KelpBassDensity+1))


#First let's see what we would find if we just did 3 simple linear regressions
volume<-lm(Density~KelpVolume, data=mydata)
temp<-lm(Density~Temperature, data=mydata)
sal<-lm(Density~Salinity, data=mydata)
sand<-lm(Density~Sand, data=mydata)
seagrass<-lm(Density~Seagrass, data=mydata)
rock<-lm(Density~Rock, data=mydata)

plot(Density~KelpVolume, data=mydata)
abline(volume)
qqp(residuals(volume),"norm")

plot(KelpBassDensity~Temperature, data=mydata)
abline(temp)
qqp(residuals(temp),"norm")

plot(KelpBassDensity~Salinity, data=mydata)
abline(sal)
qqp(residuals(sal),"norm")

plot(KelpBassDensity~Sand, data=mydata)
abline(sand)
qqp(residuals(sand),"norm")

plot(KelpBassDensity~Seagrass, data=mydata)
abline(seagrass)
qqp(residuals(seagrass),"norm")

plot(KelpBassDensity~Rock, data=mydata)
abline(rock)
qqp(residuals(rock),"norm")

#Quick check that assumptions are met
plot(volume)
plot(temp)
plot(sal)
plot(sand)
plot(seagrass)
plot(rock)


#Stats for individual regressions
summary(volume)
summary(temp)
summary(sal)
summary(sand)
summary(seagrass)
summary(rock)

#First we want to know which model fits the data best. Here's the full model:
fullmodel<-lm(Density~KelpVolume + Temperature + Salinity + Sand + Seagrass + Rock, data=mydata)

#To check for collinearity in your data:
library(GGally) # ggally for multiple scatterplots
X<-mydata[,c(5:10)] #gives you all the rows for just independent data columns
ggpairs(X) # looks good

#Now let's make every other possible model:
r1<-lm(Density~Temperature + Salinity + Sand + Seagrass + Rock, data=mydata) # volume
r2<-lm(Density~KelpVolume + Salinity + Sand + Seagrass + Rock, data=mydata) # temp
r3<-lm(Density~KelpVolume + Temperature + Sand + Seagrass + Rock, data=mydata) # salinity
r4<-lm(Density~KelpVolume + Temperature + Salinity + Seagrass + Rock, data=mydata) # sand
r5<-lm(Density~KelpVolume + Temperature + Salinity + Sand + Rock, data=mydata) # seagrass
r6<-lm(Density~KelpVolume + Temperature + Salinity + Sand + Seagrass, data=mydata) # rock

r7<-lm(Density~Salinity + Sand + Seagrass + Rock, data=mydata) # volume and temp
r8<-lm(Density~KelpVolume + Sand + Seagrass + Rock, data=mydata) # temp and salinity
r9<-lm(Density~KelpVolume + Temperature + Seagrass + Rock, data=mydata) # salinity and sand
r10<-lm(Density~KelpVolume + Temperature + Salinity + Rock, data=mydata) # sand and seagrass
r11<-lm(Density~KelpVolume + Temperature + Salinity + Sand, data=mydata) # seagrass and rock

r12<-lm(Density~Temperature + Sand + Seagrass + Rock, data=mydata) # volume and salinity
r13<-lm(Density~Temperature + Salinity + Seagrass + Rock, data=mydata) # volume and sand
r14<-lm(Density~Temperature + Salinity + Sand + Rock, data=mydata) # volume and seagrass
r15<-lm(Density~Temperature + Salinity + Sand + Seagrass, data=mydata) # volume and rock

r16<-lm(Density~KelpVolume + Salinity + Seagrass + Rock, data=mydata) # temp and sand
r17<-lm(Density~KelpVolume + Salinity + Sand + Rock, data=mydata) # temp and seagrass
r18<-lm(Density~KelpVolume + Salinity + Sand + Seagrass, data=mydata) # temp and rock

r19<-lm(Density~KelpVolume + Temperature + Sand + Rock, data=mydata) # salinity and seagrass
r20<-lm(Density~KelpVolume + Temperature + Sand + Seagrass, data=mydata) # salinity and rock

r21<-lm(Density~KelpVolume + Temperature + Salinity + Seagrass, data=mydata) # sand and rock


r22<-lm(Density~Sand + Seagrass + Rock, data=mydata) # volume temp salinity
r23<-lm(Density~Salinity + Seagrass + Rock, data=mydata) # volume temp sand
r24<-lm(Density~Salinity + Sand + Rock, data=mydata) # volume temp seagrass
r25<-lm(Density~Salinity + Sand + Seagrass, data=mydata) # volume temp rock

r26<-lm(Density~KelpVolume + Seagrass + Rock, data=mydata) # temp salinity sand
r27<-lm(Density~KelpVolume + Sand + Rock, data=mydata) # temp salinity seagrass
r28<-lm(Density~KelpVolume + Sand + Seagrass, data=mydata) # temp salinity rock

r29<-lm(Density~KelpVolume + Temperature + Rock, data=mydata) # salinity sand seagrass
r30<-lm(Density~KelpVolume + Temperature + Seagrass, data=mydata) # salinity sand rock

r31<-lm(Density~KelpVolume + Temperature + Salinity, data=mydata) # sand seagrass rock

r32<-lm(Density~Seagrass + Rock, data=mydata) # volume temp salinity sand
r33<-lm(Density~Sand + Rock, data=mydata) # volume temp salinity seagrass
r34<-lm(Density~Sand + Seagrass, data=mydata) # volume temp salinity rock

r35<-lm(Density~KelpVolume + Rock, data=mydata) # temp salinity sand seagrass
r36<-lm(Density~KelpVolume + Seagrass, data=mydata) # temp salinity sand rock

r37<-lm(Density~Temperature + Seagrass + Rock, data=mydata) # volume salinity sand
r38<-lm(Density~Temperature + Sand + Rock, data=mydata) # volume salinity seagrass
r39<-lm(Density~Temperature + Sand + Seagrass, data=mydata) # volume salinity rock
r40<-lm(Density~Temperature + Salinity + Rock, data=mydata) # volume sand seagrass
r41<-lm(Density~Temperature + Salinity + Seagrass, data=mydata) # volume sand rock


#Now let's get AIC for each model.
#Plus, we can use our original simple models above to use:
AIC(fullmodel) # 105.2
AIC(volume)
AIC(temp)
AIC(sal)
AIC(sand)
AIC(seagrass) # lowest 100.161
AIC(rock)

AIC(r1)
AIC(r2)
AIC(r3) #103.4 lowest of group
AIC(r4)
AIC(r5)
AIC(r6)

AIC(r7)
AIC(r8)
AIC(r9)
AIC(r10)
AIC(r11)
AIC(r12) # 102.34
AIC(r13)
AIC(r14)
AIC(r15)
AIC(r16)
AIC(r17)
AIC(r18)
AIC(r19)
AIC(r20)
AIC(r21)

AIC(r22)
AIC(r23)
AIC(r24)
AIC(r25)
AIC(r26)
AIC(r27)
AIC(r28)
AIC(r29)
AIC(r30)
AIC(r31)
AIC(r32)
AIC(r33)
AIC(r34) # 100.8 only sand and seagrass
AIC(r35)
AIC(r36)
AIC(r37)
AIC(r38)
AIC(r39)
AIC(r40)
AIC(r41)


#The reduced model excluding salinity is the lowest AIC value from a subset with more variables
#so let's go with that one

summary(r3)

#Here's a more traditional ANOVA table, if you like that output better
#It gives F tests instead of t...and gives df

anova(r3)

#We can quickly check for homogeneity of variances of the full model:
predicted<-fitted(r3)
resid<-residuals(r3)
plot(resid~predicted)
abline(h=0)

#And check normality
library(car)
qqp(resid, "norm")

#To get the partial standardized regression coefficients for each factor
library(QuantPsyc)
lm.beta(r3)





