# PS 5

rm(list=ls())
library(tidyverse)
library(car) # qqp() and Anova()
library(emmeans) # post-hoc test emmeans()
library(agricolae) # HSD.test()
library(lme4) # for testing random effects
library(lmerTest) #Need this to get anova results from lmer
library(MASS)


###############################################################
# Question 1
###############################################################

data1<-read_csv("Data/PS5/electromagnetic_effects.csv")
View(data1)
#We need to make sure that both Donor and Treatment are considered as factors
data1$Donor<-as.factor(data1$Donor)
data1$Treatment<-as.factor(data1$Treatment)

summary(data1) # balanced

# model Donor as a random effect and Treatment as a fixed effect with the interaction of Donor and Treatment
model1<-lmer(WBCcolonies~Treatment + (1|Donor) + (1|Treatment:Donor), data=data1)
plot(model1)
qqp(residuals(model1)) # both look good!

summary(model1) #We can use summary to get variance components
# total variance = 338.45
# Nested factor explains: 12.9%
# Donor explains: 70.5%
# Residual explains: 16.6%

anova(model1)
Anova(model1, type="III") # if using a mixed model we should often use a capital A anova.
# no significance of the treatment on white blood cell counts
# for a likelihood ratio test we put the chisquared value and the p-value

#If we really want to test the significance of a random effect, then we need to 
#use a likelihood ratio test by comparing models with and without the random effect
#One way to do this:
model1.b<-lm(WBCcolonies~Treatment, data=data1) #Model with only Treatment
anova(model1, model1.b) #LRT to determine effect of Donor as a random factor
# model with random factor is a better fit based on AIC values
# Donor explains a lot of the variance, so this makes sense


# Donor as random effect
# lrt are the chi-squared values
## doesn't give an indication of effect size, just 'whether' it's important, not 'how' important
## whether the identity of the woman affects white blood cell count


# from alyssa:
# EMFmodel2a<-lmer(WBCcolonies ~ Treatment + (1|Donor/Treatment), data=EMFcells)
# EMFmodel2b<-lmer(WBCcolonies ~ Treatment + (1|Donor), data=EMFcells)
# EMFmodel2c<-lm(WBCcolonies ~ Treatment, data=EMFcells)
# anova(EMFmodel2a, EMFmodel2b, test = "Chisq")
# anova(EMFmodel2b, EMFmodel2c, test = "Chisq")



###############################################################
# Question 2
###############################################################

data2<-read_csv("Data/PS5/plantcompetition.csv")
View(data2)
data2<-data2%>%select(-"X5")

data2$Species<-as.factor(data2$Species)
data2$clipped<-as.factor(data2$clipped) # simulated grazing
data2$weeded<-as.factor(data2$weeded) # simulated competition

summary(data2) # sample sizes are not equal = "unbalanced design" so will need to use car::Anova(model, type="III")

# Three-way ANOVA
# species, clipping, and weeding as fixed factors
model2<-lm(flowers~Species*clipped*weeded, data=data2)
plot(model2) # not homogeneous
qqp(residuals(model2)) # not super normal

log.data2<-data2%>%
  mutate(log.flowers=log(flowers + 1))
model2.a<-lm(log.flowers~Species*clipped*weeded, data=log.data2)
plot(model2.a) # much better
qqp(residuals(model2.a)) # much better

summary(model2.a)
Anova(model2.a, type="III")



# I just want to look at data trends
emmeans(model2.a, pairwise~Species*clipped*weeded, adjust="tukey")

graphdata2<-as.data.frame(emmeans(model2.a, ~ Species*clipped*weeded))
graphdata2
ggplot(graphdata2, aes(x=Species, y=emmean, fill=factor(clipped), group=factor(clipped))) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  labs(x="Species", y="ln(Flower counts)", fill="Clipped")  #labels the x and y axes


###############################################################
# Question 3
###############################################################

# Test whether disease or parasites affect mammal species abundance
# lmer(disease*parasite + (1|block) + (1|block:disease:parasite))

data3<-read_csv("Data/PS5/mammals.csv")
View(data3)

data3$disease<-as.factor(data3$disease)
data3$parasite<-as.factor(data3$parasite)
data3$block<-as.factor(data3$block)

summary(data3) # unbalanced

#model3<-lmer(abundance ~ disease*parasite + (1|block) + (1|block:disease) + (1|block:parasite), data=data3)
#model3<-lmer(abundance ~ disease*parasite + (1|block) + (1|block:disease) + (1|block:parasite) + (1|block:disease:parasite), data=data3)
model3<-lmer(abundance ~ disease*parasite + (1|block) + (1|block:disease:parasite), data=data3)
plot(model3)
qqp(residuals(model3)) # assumptions look good
anova(model3)

# Do Likelihood Ratio Test - interaction from full model was not significant
model3.b<-lm(abundance ~ disease*parasite, data=data3) 
anova(model3, model3.b, "chisq") # LRT shows that adding block as random factor is a better fit

emmeans(model3, pairwise~disease*parasite, adjust="tukey")
graphdata<-as.data.frame(emmeans(model3, ~disease*parasite))
graphdata

ggplot(data=graphdata, aes(x=disease, y=emmean, fill=factor(parasite), group=factor(parasite))) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge", aes(fill=parasite)) + 
  labs(x="Disease Activity", y="Abundance", fill="Parasite Stage") + #labels the x and y axes
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.5), width=0.1)
# not necessary
# only asked "whether" disease or parasites affect mammal abundance

###############################################################
# Question 4
###############################################################

data4<-read_csv("Data/PS5/coral_acclimation.csv")
View(data4)

# different corals throughout treatments, but measuring same corals overtime in their respective treatments

data4$temperature<-as.factor(data4$temperature)
data4$coral<-as.factor(data4$coral)
data4$day<-as.factor(data4$day)

# mixed model ANOVA without time
#model4.a<-lmer(FvFm ~ temperature + (1|coral) + (1|temperature:coral), data=data4)
#plot(model4.a)
#qqp(residuals(model4.a))
#anova(model4.a)

# repeated measures mixed model ANOVA
model4.b<-lmer(FvFm ~ temperature*day + (1|coral), data=data4) # don't nest coral to get the correct df
plot(model4.b)
qqp(residuals(model4.b)) #not quite normal

# attempted log and square root transformations, but data were no more normal, and possibly slightly less
data4.trans<-data4%>%mutate(FvFm.trans=log(FvFm+1))
model4.trans<-lmer(FvFm.trans ~ temperature*day + (1|temperature:coral), data=data4.trans) 
plot(model4.trans)
qqp(residuals(model4.trans))
# transformations make it worse

anova(model4.b)
summary(model4.b)

#emmeans(model4.b, pairwise ~ temperature:day, adjust="Tukey")
# because there are a lot of comparisons, the Tukey test may not be powerful enough to actually give us correct p values

#To plot
graphdata<-as.data.frame(emmeans(model4.b, ~temperature:day))
graphdata<-graphdata%>%rename(Temperature=temperature)
graphdata

ggplot(graphdata, aes(x=day, y=emmean, group=Temperature, color=Temperature)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank())+ 
  geom_line(aes(linetype=Temperature)) +
  geom_point()+
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", width=0.1) +
  labs(x="Day", y="Fv/Fm") 




###############################################################
# Question 5
###############################################################

data5<-read_csv("Data/PS5/stipe_strength.csv")
View(data5)
# Need an ANCOVA

data5$species<-as.factor(data5$species)
summary(data5) # unbalanced

# Species and Thickness are our two predictor variables as fixed factors
model5<-lm(BreakForce ~ species * Thickness, data=data5) # run ANOVA
plot(model5) # not homogeneous
qqp(residuals(model5)) # not normal

# transform
data5<-data5%>%
  mutate(BreakForce.log=log(BreakForce))
model5.log<-lm(BreakForce.log ~ species * Thickness, data=data5)
plot(model5.log) # not homogeneous
qqp(residuals(model5.log)) # not normal

data5<-data5%>%
  mutate(Thickness.log=log(Thickness))
model5.log<-lm(BreakForce.log ~ species * Thickness.log, data=data5)
plot(model5.log) # homogeneous - okay
qqp(residuals(model5.log)) # normal - okay

#Remember that you also want to make sure that the relationship with covariate is linear
plot(BreakForce.log~Thickness.log, data=data5)

# unbalanced data. Use Type III Anova
Anova(model5.log, type="III")

#You can stop right there if you want, but if you wanted to go further and do model selection
#Interaction term is highly non-significant, so you might want to do model selection and decide whether or not to drop it
#Let's look at AIC with and without
model5.log.b<-lm(BreakForce.log ~ Thickness.log + species, data=data5)
AIC(model5.log)
AIC(model5.log.b) # lower value = better model

# second model is just a hair better, though barely.
Anova(model5.log.b, type="III")

summary(model5.log.b)

#But for plotting the data, I'm going to stick with our original model
#To plot the data:

predBreakForce<-predict(model5.log) #Gets the predicted values from the regression lines in the ANCOVA
graphdata<-cbind(data5, predBreakForce) #attaches those predictions to the dataset

ggplot(data=graphdata, aes(Thickness.log, BreakForce.log, color=species)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() + 
  geom_line(aes(y=predBreakForce)) +
  labs(x="log(Thickness)", y="log(Break Force)", fill="Species")




