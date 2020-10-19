# Problem Set 4

rm(list=ls())
library(tidyverse)
library(car)
library(agricolae)
library(emmeans)
library(lme4)
library(lmerTest) #lmer doesn't like to give p-values, so we need another package to do that


###################
# Question 1
###################





# Statement: there is or is not a significant difference between the soil groups/samples (F=, df= , p=)






###################
# Question 2
###################

data3<-read_csv("Data/rootshoot.csv")
model3<-lm(RootShoot~Nitrogen, data=data3)
resid3<-residuals(model3)
plot(model3) # residuals vs fitted shows high variance between groups
qqp(resid3) # not normal

# log transform
data3log<-data3%>%
  mutate(log=log(RootShoot))
model3log<-lm(log~Nitrogen, data=data3log)
resid3log<-residuals(model3log)
plot(model3log) # residuals vs fitted shows high variance between groups
qqp(resid3log) # not normal

# square root transform
data3s<-data3log%>%
  mutate(sq=sqrt(RootShoot))
model3s<-lm(sq~Nitrogen, data=data3s)
resid3s<-residuals(model3s)
plot(model3s) # residuals vs fitted shows high variance between groups (worse than log)
qqp(resid3s) # not normal (worse than log)

# arcsine transform
data3a<-data3%>%
  mutate(arc=asin(sqrt(RootShoot+0.1))) # doesn't work because ratios need to be <= 1
# NAs produced for much data
# moving forward with log transformed data

# run anova on our model with log transformed data
# gives degrees of freedom for residuals, sum of squares, mean square, f value and p value
anova(model3log)
summary(model3log)

# Tukey Test to show variance between the levels of our factor
# can use because our model is a lm()
hsd<-HSD.test(model3log, "Nitrogen", console=TRUE)
hsd

#here's another way to get Estimated Marginal Means for every level, while also doing a Tukey test
emmeans(model3log, pairwise ~ "Nitrogen", adjust="Tukey")
#These are nice because we can often use these EMM when making a plot, particularly for more complicated models
# emmeans tells us the means of each group (and there's also a way for it to show p values, but casey can't recall how to do that right now)

# plot the data
graph3 <- data3log %>%
  group_by(Nitrogen) %>%
  summarize(mean=mean(log, na.rm=TRUE), se=sd(log, na.rm=TRUE)/sqrt(length(na.omit(log))))
graph3

ggplot(data=graph3, aes(x=Nitrogen, y=mean, fill=Nitrogen)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("log(root:shoot biomass ratio)") +
  xlab("Nitrogen Treatment") +
  geom_hline(yintercept = 0) +
  geom_text(label=hsd$groups$groups, vjust = c(2,3.5,-2,-3.5)) + # add significance letters and adjust location on each bar
#  scale_x_discrete(labels=c("Low" = "Low Tide", "High" = "High Tide")) +
  geom_errorbar(aes(ymax=mean+se, ymin=mean-se), stat="identity", position=position_dodge(width=0.9), width=0.1)

###################
# Question 3
###################

# Question: Do Granivorous desert rodents influence plant densities by consuming seeds of plants?
# Use planned comparisons (a priori contrasts) to test two hypotheses: 
# (1) there is no experimental artifact of using exclosures; and 
# (2) rodents reduce the abundance of seeds (as estimated by mass of seeds).  

data2<-read_csv("Data/seedsrodents.csv")
# coerce Treatment into factor type
data2$Treatment<-as.factor(data2$Treatment)

#First, let's create a model and test our assumptions
model2<-aov(seed.mass~Treatment, data=data2)
plot(model2) # assumptions are met
summary(model2)
# there is a significant difference based on treatment, but we don't know at which treatment level(s)

#If you want to know the order of the levels in R:
levels(data2$Treatment)
# Control, Exclusion, Fence control

#Our coefficients for comparing Control to Cage (rodents can still come in go in both control and fenced control, so what's the effect of the fence?)
c1<-c(1,0,-1)
#Our coefficients for comparing rodent presence to rodent exclusion
c2<-c(1/2,-1,1/2)

#You MUST make sure that these are orthogonal. Each row must add to zero.
#And if you multiply all the numbers in a column, the products must sum to zero also
(1*1/2) + (0*-1) + (-1*1/2) # = 0

#And now let's combine these two vectors together into a matrix.
contrastmatrix<-cbind(c1,c2)
#And now we're going to attach this contrast matrix to the dataset
contrasts(data2$Treatment)<- contrastmatrix

#Now run the two contrasts like this:
summary(model2, split=list(Treatment=list("Effect of Exclosure"=1, "Effect of Rodents"=2)))



###################
# Question 4
###################
# same as 3 but doing a Tukey HSD post-hoc test

data4<-read_csv("Data/seedsrodents.csv")
data4$Treatment<-as.factor(data2$Treatment)
model4<-aov(seed.mass~Treatment, data=data4)
summary(model4)

TukeyHSD(model4)
emmeans(model4, pairwise ~ "Treatment", adjust="Tukey")


###################
# Question 5
###################

# null hypotheses were that calyx area does not differ either (1) within or (2) among colonies of M. franksi

data5<-read_csv("Data/montastraea.csv")
View(data5)

# n = 10 calyx area measurements for
# k = 3 ramets for
# p = 3 genets

# Quantify where most of phenotypic variation in calyx area lies in populations of M. franksi using variance components
# Two way nested anova
model5<-lmer(Calyxarea~Genotype + (1|Ramet:Genotype), data=data5) # Ramet is a random factor nested in Genotype

#Remember that we need to check the assumptions of our test
plot(model5) # first option to look for spread less than 3x for any group
plot(residuals(model5)) # another option, look for no pattern
#Homogeneity of Variance look ok

#When we're using lmer, we have to do the probability plot ourselves
qqp(residuals(model5), "norm") # data look normal

anova(model5)

#Now, as we discussed, R doesn't want us to test the significance of random effects,
#but there's a roundabout way we could do it. We can construct a model with and without
#the random factor and ask which one fits the data better. If the random effect
#significantly improves the fit, then it is important. We call this a Likelihood Ratio
#Test and here's how you do it:
model5<-lmer(Calyxarea~Genotype + (1|Ramet:Genotype), data=data5) #the model we already made...with the random effect
model5b<-lm(Calyxarea~Genotype, data=data5) #a model without the random effect

anova(model5, model5b)
#this is the Likelihood Ratio Test. It gives AIC values for both models
#and it gives us a p-value for whether one is a better fit. We COULD technically
#use that p-value as a hypothesis test for the random effect

#model5 with the random factor is the better model to fit our data

#Finally, if we assumed that both variables were random effects, we could get 
#variance components for both random effects and the error (which is also a random effect)
model5.rand<-lmer(Calyxarea~1+(1|Genotype) + (1|Ramet:Genotype), data=data5)
summary(model5.rand)
#The variance components are listed under "Random effects" in the output
#If we add up all the numbers in the Variance column, that is the total
#variance. If we divided the variance of each factor by the total variance, then
#we would have the percent of variance explained by each source: Ramet, Genotype, or Residual

# explained variation is between groups
# unexplained variation is within groups

emmeans(model5, pairwise ~ "Genotype", adjust="Tukey")

## plot difference just among genotypes

graph5 <- data5 %>%
  group_by(Genotype) %>%
  summarize(mean=mean(Calyxarea, na.rm=TRUE), se=sd(Calyxarea, na.rm=TRUE)/sqrt(length(na.omit(Calyxarea))))
graph5

plot_colorsb<-c("#005867","#FFB335","#2E383D")
ggplot(data=graph5, aes(x=Genotype, y=mean, fill=Genotype)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge", aes(fill=Genotype)) + 
  guides(fill=FALSE) + 
  ylab("Calyx Area") +
  xlab("M. franksi Genotypes") +
  scale_fill_manual(values=plot_colorsb, aesthetics = "fill") +
  # geom_hline(yintercept = 0) +
  geom_text(label=c("b","a","b"), vjust = -2) + # add significance letters and adjust location on each bar - letters taken from emmeans results
  #  scale_x_discrete(labels=c("Low" = "Low Tide", "High" = "High Tide")) +
  geom_errorbar(aes(ymax=mean+se, ymin=mean-se), stat="identity", position=position_dodge(width=0.5), width=0.1)

# check hypothesis that variation does not differ within genotypes/colonies
data5.1<-data5%>%filter(Genotype=="G1")
model5.1<-lm(Calyxarea~Ramet, data=data5.1) #a model without the random effect
anova(model5.1) # significant differences between ramets
HSD.test(model5.1, "Ramet", console=TRUE)

data5.2<-data5%>%filter(Genotype=="G2")
model5.2<-lm(Calyxarea~Ramet, data=data5.2) #a model without the random effect
anova(model5.2)

data5.3<-data5%>%filter(Genotype=="G3")
model5.3<-lm(Calyxarea~Ramet, data=data5.3) #a model without the random effect
anova(model5.3)

# just checking out summary stats for replicate measurements for each ramet
graph5.ramet <- data5 %>%
  group_by(Genotype,Ramet) %>%
  summarize(mean=mean(Calyxarea, na.rm=TRUE), se=sd(Calyxarea, na.rm=TRUE)/sqrt(length(na.omit(Calyxarea))))
graph5.ramet



###################
# Question 6
###################
# test the effects of temperature and CO2 (pCO2) on growth rates of recently settled corals
# to evaluate the possible effects of these two stressors on a species of coral

data6<-read_csv("Data/temp_CO2.csv")
View(data6)

#Two Factor ANOVA with interaction
model6<-lm(growth~CO2*Temperature, data=data6)

#Now let's check our assumptions
plot(model6)
resid6<-residuals(model6)
plot(resid6)
qqp(resid6)
# assumptions look OK

anova(model6)

graphdata<-as.data.frame(emmeans(model6, ~ CO2*Temperature))
graphdata


ggplot(data=graphdata, aes(x=Temperature, y=emmean, fill=factor(CO2), group=factor(CO2))) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge", aes(fill=CO2)) + 
  labs(x="Temperature (*C)", y="Growth of Basal Area (mm2)", fill="CO2") + #labels the x and y axes
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.5), width=0.1)

# Note that using the estimated marginal means (emmeans) here is super important for getting the right error bars.  
# Because Ramet is the replicate, there are 3 replicates per Genotype and if we tried to get the means without accounting for Ramet,
# we would have pseudoreplicated.
# The error bars would be smaller, but this would be wrong.



