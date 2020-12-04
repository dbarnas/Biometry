#Midterm 2 Practical Key

################
###Question 1###
################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/redbull.csv")
View(mydata)

#Create the ANOVA model
model1<-lm(testscore~Treatment, data=mydata)

#Now check the assumptions
plot(model1) #homogeneity looks good
library(car)
qqp(residuals(model1), "norm") #normality looks good


#Get results from ANOVA
anova(model1)

#Post-hoc tests
library(emmeans)
emmeans(model1, pairwise~Treatment, adjust="tukey")

#Make a graph
graphdata<-as.data.frame(emmeans(model1, ~Treatment))

library(ggplot2)
ggplot(data=graphdata, aes(x=Treatment, y=emmean)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("Test Score") +
  xlab("Treatment") +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1)


################
###Question 2###
################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/mousefats.csv")
View(mydata)

#This should be a nested analysis because each mouse got only one of the treatments.
#But we have replicates measures of each mouse, so we want to incorporate the effect of mouse too

#First create a model to test the effects of fat
library(lme4)
library(lmerTest)
model1<-lmer(endurance~fat + (1|mouse) + (1|fat:mouse), data=mydata)
 

#Remember that we need to check the assumptions of our test
plot(model1) #Variances look heterogenous
library(car)
qqp(residuals(model1), "norm") #Normality not great

#Try log transform
mydata$logendurance<-log(mydata$endurance)

model2<-lmer(logendurance~fat + (1|mouse) + (1|fat:mouse), data=mydata)
plot(model2) #better
library(car)
qqp(residuals(model2), "norm") #better

#Now, we can get the stats for the effect of fats:

anova(model2) #to get F and P
Anova(model2, type="III") #To do LRT and get X^2 and P

#To see the emmeans of those fat treatments
library(emmeans)
emmeans(model2, ~fat)

#Finally, to get variance components, look at the summary of the original model
summary(model2)
#The variance components are listed under "Random effects" in the output
fatbymouse<-0.017821
mouse<-0
error<-0.003544
total<-mouse+error+fatbymouse

fatbymouse/total
mouse/total
error/total



################
###Question 3###
################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/gobyshelter.csv")
View(mydata)

#Make sure Shelter is a factor
mydata$Shelter<-as.factor(mydata$Shelter)

#First create the full model in order to do model selection
fullmodel<-lm(goby.recruits~Predators*Shelter*Block, data=mydata)

#Test assumptions
plot(fullmodel)
library(car)
qqp(residuals(fullmodel), "norm")
#All looks good

#If you want, stop there and interpret the results of the full model
anova(fullmodel)

#If you want to continue to do model selection
#One way to do model selection
library(MASS)
step<-stepAIC(fullmodel, direction="both")
step$anova

#Best model has just main effects and Predators:Shelter
model1<-lm(goby.recruits~Shelter+Predators+Block + Predators:Shelter, data=mydata)
anova(model1)
Anova(model1, type="III")
#To see direction of effects
library(emmeans)
emmeans(model1, ~Predators:Shelter)




###Question 4###
#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/octocorals.csv")
View(mydata)

#Fit ANCOVA model with Treatment as categorical variable and Colony Diameter as covariate (continuous variable)
model1<-lm(Photosynthesis~Treatment*ColonyDiameter, data=mydata)

#check assumptions
plot(model1) #Homogeneity looks good
library(car)
qqp(residuals(model1), "norm") #normal

#Make sure relationship between colony diameter and photosynthesis is linear
plot(Photosynthesis~ColonyDiameter, data=mydata)
#Yes, linear (in two different directions)

anova(model1)
#Interaction is very significant, so probably don't need to do model selection


#Plot the data
predPhoto<-predict(model1) #Gets the predicted values from the regression lines in the ANCOVA
graph.data<-cbind(mydata, predPhoto) #attaches those predictions to the dataset

library(ggplot2)
ggplot(data=graph.data, aes(ColonyDiameter, Photosynthesis, color=Treatment)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() + geom_line(aes(y=predPhoto)) +
  labs(x="Colony Diameter", y="Photosynthesis", fill="Octocoral Treatment")
