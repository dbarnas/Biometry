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
# no significance of the treatment on white blood cell counts

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

summary(log.data2)

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

summary(data3) # balanced

data3$disease<-as.factor(data3$disease)
data3$parasite<-as.factor(data3$parasite)
data3$block<-as.factor(data3$block)

#model3<-lmer(abundance ~ disease*parasite + (1|block) + (1|block:disease) + (1|block:parasite), data=data3)
#model3<-lmer(abundance ~ disease*parasite + (1|block) + (1|block:disease) + (1|block:parasite) + (1|block:disease:parasite), data=data3)
model3<-lmer(abundance ~ disease*parasite + (1|block) + (1|block:disease:parasite), data=data3)
plot(model3)
qqp(residuals(model3)) # assumptions look good
anova(model3)

model3.b<-lm(abundance ~ disease*parasite, data=data3) 
anova(model3, model3.b, "chisq") # LRT shows that adding block as random factor is a better fit

emmeans(model3, pairwise~disease*parasite, adjust="tukey")
# not necessary
# only asked "whether" disease or parasites affect mammal abundance

###############################################################
# Question 4
###############################################################











###############################################################
# Question 5
###############################################################

data5<-read_csv("Data/PS5/stipe_strength.csv")
View(data5)

data5$species<-as.factor(data5$species)

# Species and Thickness are our two predictor variables as fixed factors
model5<-lm(BreakForce ~ species * Thickness, data=data5) # run ANOVA
plot(model5) # not homogeneous
qqp(residuals(model5))

data5.log<-data5%>%
  mutate(log.BreakForce=log(BreakForce))
model5.log<-lm(log.BreakForce ~ species * Thickness, data=data5.log)
plot(model5.log) # not homogeneous
qqp(residuals(model5.log))

summary(data5.log)
# unbalanced data. Use Type III Anova

Anova(model5.log, type="III")








