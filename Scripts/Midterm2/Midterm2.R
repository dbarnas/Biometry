# Danielle Barnas Midterm 2 Part B
# October 22, 2020

####################################################
# Question 1

library(tidyverse)
library(car) # qqp() and Anova()
library(emmeans) # post-hoc test emmeans()
library(agricolae) # HSD.test()
library(lme4) # for testing random effects
library(lmerTest) #Need this to get anova results from lmer
library(MASS)

rm(list=ls())

mydata<-read_csv("Data/Midterm2/redbull.csv")
View(mydata)

# as.factor
mydata$Treatment<-as.factor(mydata$Treatment)

# create model one-way anova
model<-aov(testscore~Treatment, mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

# stats
anova(model)

# post-hoc Tukey test (requires aov())
TukeyHSD(model)

# HSD.test (gives you letters for different groups which is convenient)
HSD.test(model, "Treatment", console=TRUE)

# Graph data means
graphdata<-as.data.frame(emmeans(model, "Treatment"))
graphdata

# append a new column to graph data with the Tukey results in order
graphdata$tukey<-list("a","a","b")
graphdata

ggplot(data=graphdata, aes(x=Treatment, y=emmean, fill=Treatment)) +
  theme_bw()+
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("Mean Test Scores") +
  xlab("Pre-test Treatment") +
  #scale_x_discrete(labels=c("Low" = "Low", "Ambient" = "Ambient", "1.5N" = "1.5 N", "2N" = "2 N")) +
  geom_errorbar(aes(ymax=emmean +SE, ymin=emmean - SE), stat="identity", position=position_dodge(width=0.9), width=0.1)+
  geom_text(aes(label=tukey), position = position_dodge(width=0.9), vjust=-1)+
  geom_hline(yintercept=0)


####################################################
# Question 2

rm(list=ls())

mydata<-read_csv("Data/Midterm2/mousefats.csv")
View(mydata)

# as.factor
mydata$fat<-as.factor(mydata$fat)
mydata$mouse<-as.factor(mydata$mouse)
mydata$Trial<-as.factor(mydata$Trial)

# create model, repeated measures ANOVA
model<-lmer(endurance~fat*Trial + (1|mouse),mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

# stats
anova(model)

# interaction effect is insignificant
# test reduced model
reduced<-lm(endurance~fat*Trial, mydata)
AIC(model)
AIC(reduced)
#LRT
anova(model, reduced)
# full model is a better fit

emmeans(model, ~fat)

# variance components - random factors model
model1<-lmer(endurance~1 + (1|fat) + (1|Trial) + (1|fat:Trial) + (1|mouse), data=mydata)

# check assumptions
plot(model1)
qqp(residuals(model1),"norm")

# get variance components
summary(model1)

1.327+0+0+2.943+4.802 # total = 9.072
1.327/9.072*100 # mouse
2.943/9.072*100 # fat
4.802/9.072*100 # residual

####################################################
# Question 3

rm(list=ls())

mydata<-read_csv("Data/Midterm2/gobyshelter.csv")
View(mydata)

# fixed: Block, Shelter, Predators (no = cage, yes = uncaged)
# nested: Shelter:Gobitat #
# response: goby recruits (# of young bluebanded gobies accumulated)

mydata<-mydata%>%
  rename(gobitat='Gobitat #', recruits='goby recruits')

# as.factor
mydata$Block<-as.factor(mydata$Block)
mydata$Shelter<-as.factor(mydata$Shelter)
mydata$Predators<-as.factor(mydata$Predators)
mydata$gobitat<-as.factor(mydata$gobitat) # doesn't actually matter. won't include in model because each gobitat = each data point

# create model, three-way fixed ANOVA
model<-lm(recruits~Block*Shelter*Predators,mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

# check a log transformation just in case for homoscedasticity (also tried square root and didn't help)
mydata$logrecruits<-log(mydata$recruits)
model2<-lm(logrecruits~Block*Shelter*Predators,mydata)
plot(model2) # nope that's worse
qqp(residuals(model2),"norm")

# stats on full model
anova(model)
# no significance of any interactions

# check reduced models
reduced1<-lm(recruits~Block + Shelter + Predators + Block:Shelter + Block:Predators + Shelter:Predators,mydata) #remove three-way interaction
reduced2<-lm(recruits~Block + Shelter + Predators + Block:Shelter + Block:Predators,mydata) #remove three-way interaction and Shelter:Predators
reduced3<-lm(recruits~Block + Shelter + Predators + Block:Shelter + Shelter:Predators,mydata) #remove three-way interaction and Block:Predators
reduced4<-lm(recruits~Block + Shelter + Predators + Block:Predators + Shelter:Predators,mydata) #remove three-way interaction and Block:Shelter

reduced5<-lm(recruits~Block + Shelter + Predators + Block:Shelter ,mydata) #remove three-way interaction and Shelter:Predators+ Block:Predators
reduced6<-lm(recruits~Block + Shelter + Predators + Block:Predators,mydata) #remove three-way interaction and Shelter:Predators+ Block:Shelter
reduced7<-lm(recruits~Block + Shelter + Predators + Shelter:Predators,mydata) #remove three-way interaction and Block:Predators+ Block:Shelter
reduced8<-lm(recruits~Block + Shelter + Predators,mydata) #remove three-way interaction and Block:Predators+ Block:Shelter + Shelter:Predators


AIC(model)
AIC(reduced1)
AIC(reduced2)
AIC(reduced3)
AIC(reduced4)
AIC(reduced5)
AIC(reduced6)
AIC(reduced7) # lowest AIC lm(recruits~Block + Shelter + Predators + Shelter:Predators,mydata)
AIC(reduced8)

# LRT
anova(model, reduced7)
# not actually different

anova(reduced7)
# table included in answer
anova(model) # to give insignificant p values

# check assumptions of new model
plot(reduced7)
qqp(residuals(reduced7),"norm")

# estimated marginal means
emmeans(model, ~Block)
emmeans(model, ~Shelter)
emmeans(model, ~Predators)
emmeans(model, ~Shelter*Predators)

# to calculate effect of shelter: 
# 60 hole mean(31.2) - 20 hole mean(11.8) = 19.4 / 20 hole mean(11.8) 
# = 1.64 * 100 = 164% increase


####################################################
# Question 4

rm(list=ls())

mydata<-read_csv("Data/Midterm2/octocorals.csv")
View(mydata)

# fixed: Treatment, ColonyDiameter
# ignore: Plot. one plot per measurement

# as.factor
mydata$Treatment<-as.factor(mydata$Treatment)

# create model
model<-lm(Photosynthesis~Treatment*ColonyDiameter,mydata)

#Check assumptions
plot(Photosynthesis~ColonyDiameter, data=mydata) # not linear
plot(model)
qqp(residuals(model),"norm")

#transform
mydata$logP<-log(mydata$Photosynthesis)
plot(logP~ColonyDiameter, data=mydata) # not linear

mydata$logCD<-log(mydata$ColonyDiameter)
plot(logP~ColonyDiameter, data=mydata) # not linear
plot(logP~logCD, data=mydata) # not linear

mydata$sP<-sqrt(mydata$Photosynthesis)
plot(sP~ColonyDiameter, data=mydata) # not linear
plot(sP~logCD, data=mydata) # not linear
plot(Photosynthesis~logCD, data=mydata) # not linear

mydata$sCD<-sqrt(mydata$ColonyDiameter)
plot(Photosynthesis~logCD, data=mydata) # not linear
plot(sP~logCD, data=mydata) # not linear
plot(logP~sCD, data=mydata) # not linear
plot(sP~sCD, data=mydata) # not linear

# cannot achieve linearity



#Double-check assumptions
plot(model)
qqp(residuals(model),"norm")


anova(model)

#To plot the data:
predP<-predict(model) #Gets the predicted values from the regression lines in the ANCOVA
graphdata<-cbind(mydata, predP) #attaches those predictions to the dataset

ggplot(data=graphdata, aes(x=ColonyDiameter, y=Photosynthesis, color=Treatment)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() + geom_line(aes(y=predP)) +
  labs(x="Colony Diameter", y="Photosynthetic Rate (Fv/Fm)", fill="Treatment")






