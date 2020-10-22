#Problem Set 5 R Code
#Created by Casey terHorst 10/12/20

########################################
###Question 1: Electromagnetic Fields###
########################################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/electromagnetic_effects.csv")
View(mydata)

#Donor should be a random factor, but treatment is a fixed factor
library(lme4)
library(lmerTest)

model1<-lmer(WBCcolonies~Treatment + (1|Donor) + (1|Treatment:Donor), data=mydata)

#Check assumptions
plot(model1) #homogeneity looks ok
library(car)
qqp(residuals(model1), "norm") #normality good too


#Ok, now let's get our ANOVA table
anova(model1)
Anova(model1, type="III")



###################################
###Question 2: Plant Competition###
###################################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/PS5/plantcompetition.csv")
View(mydata)

model1<-lm(flowers~Species*clipped*weeded, data=mydata)

#Check assumptions
plot(model1)
#Not Normal. Not Homogenous. Try log transformation?

mydata$lnflowers<-log(mydata$flowers+1)

model2<-lm(lnflowers~Species*clipped*weeded, data=mydata)
plot(model2)
library(car)
qqp(residuals(model2), "norm")  #normality not perfect, but good enough

#That's pretty decent, let's go with that
#Note that the design is pretty unbalanced, so you need to use Type III SS
Anova(model2, type="III")

#If we wanted to do some additional model selection:
#There's a highly non-significant 3-way interaction there. Should we get rid of it? Let's look at AIC with and without
#model 2 has all effects. Let's make model 3 without the interaction
model3<-lm(lnflowers~Species + clipped + weeded + Species:clipped + Species:weeded + clipped:weeded, data=mydata) #no three-way interaction
AIC(model2)
AIC(model3)
#Better fit without the interaction
anova(model2, model3)  #However Likelihood Ratio Test suggests they're about the same

#Model 2 is probably best, but if you wanted model 3 results
Anova(model3, type="III")

#Results are actually quite different because we got a little more power with model3 that resulted
#in many significant two-way interactions.

#Going back to model 2, let's look at the means, so we can which direction the effects are in
library(emmeans)
emmeans(model2, ~Species)
emmeans(model2, ~clipped)
emmeans(model2, ~weeded*Species)



#####################################
###Problem 3:Disease and parasites###
#####################################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/PS5/mammals.csv")
View(mydata)

#Block imported as an integer, so I've going to convert it to a factor
mydata$block<-as.factor(mydata$block)

#Going to fit a mixed model, with disease and parasite as fixed factors and block
#as a random factor...

library(lme4)
model1<-lmer(abundance~disease*parasite + (1|block) + (1|disease:block) + (1|parasite:block) + (1|disease:parasite:block), data=mydata)

#Check assumptions
plot(model1)
library(car) #homogeneity good
qqp(residuals(model1), "norm") #Normality looks good

anova(model1)


#Make a quick plot of the data, just to see what the pattern looks like
#And now make a graph
library(emmeans)
graphdata<-as.data.frame(emmeans(model1, ~disease*parasite))

library(ggplot2)
ggplot(graphdata, aes(x=disease, y=emmean, fill=factor(parasite), group=factor(parasite))) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", stat="identity", position="dodge", size=0.6) +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) +
  labs(x="disease", y="abundance", fill="parasite") 

#I just want to see what these means look like independent of one another
emmeans(model1, ~disease)
emmeans(model1, ~parasite)


##################################
###Problem 4: Coral acclimation###
##################################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/PS5/coral_acclimation.csv")
View(mydata)

#Be sure to turn day into a factor
mydata$day<-as.factor(mydata$day)

#Run the model, with Temp and Day as fixed effects, and Coral as a random factor
library(lme4)
model1<-lmer(FvFm ~ temperature*day + (1|coral), data=mydata)

#And check assumptions
plot(model1) #homogeneity is a little sketchy
library(car)
qqp(residuals(model1), "norm") #not normal

#Try log transformation
mydata$logFvFm<-log(mydata$FvFm)

model2<-lmer(logFvFm ~ temperature*day + (1|coral), data=mydata)

plot(model2) #better
library(car)
qqp(residuals(model2), "norm")  #ok
#Let's just use the log data


#Get results
anova(model2)

#To plot
library(emmeans)
graphdata<-as.data.frame(emmeans(model2, ~temperature:day))
graphdata

#GGplot plots the levels in alphabetical order. So instead I'm going to first 
#reorder my graph data to the order that I want in a new column called Temps.
graphdata$temperature<- factor(graphdata$temperature, levels = c("ambient", "warm", "hot"))

library(ggplot2)
ggplot(graphdata, aes(x=day, y=emmean, group=factor(temperature))) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank())+ 
  geom_line(aes(linetype=temperature, color=temperature)) +
  geom_point(aes(color=temperature))+
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(), width=0.1) +
  labs(x="Day", y="log Fv/Fm") 





#########################
###Problem 5: Seaweeds###
#########################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/PS5/stipe_strength.csv")
View(mydata)

#We'll have two predictor variables: Species, a discrete variable, which imported as a factor (good), and thickness, a 
#continuous variable, which imported as a number (good)

#Now we can just run our ANOVA using these two predictor variables.
model1<-lm(BreakForce ~ species * Thickness, data=mydata)

#Check assumptions
plot(model1)

#Normality looks ok, but variances not homogenous, let's transform Breakforce
mydata$lnBreak<-log(mydata$BreakForce)

model2<-lm(lnBreak ~ species * Thickness, data=mydata)
plot(model2)
#variances are better
library(car)
qqp(residuals(model2), "norm")

#Remember that you also want to make sure that the relationship with covariate is linear
plot(lnBreak~Thickness, data=mydata)

#Not linear, so let's tranform Thickness too
mydata$lnThick<-log(mydata$Thickness)

plot(lnBreak~lnThick, data=mydata)

#linearity is better
#Ok, now we can make our model
model3<-lm(lnBreak~ species * lnThick, data=mydata)

#Double-check assumptions
plot(model3)
qqp(residuals(model3,),"norm")
#good

#Notice that we have an unbalanced design here. So we need to make sure that we use Type III SS
library(car)
Anova(model3, type="III")


#To plot the data:
predThick<-predict(model3) #Gets the predicted values from the regression lines in the ANCOVA
graphdata<-cbind(mydata, predThick) #attaches those predictions to the dataset

library(ggplot2)
ggplot(data=graphdata, aes(lnThick, lnBreak, color=species)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() + geom_line(aes(y=predThick)) +
  labs(x="ln Stipe Thickness", y="ln Break Force", fill="species")


