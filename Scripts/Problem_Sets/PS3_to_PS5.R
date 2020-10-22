library(tidyverse)
library(car)

###################################################
# PS#_3
rm(list=ls())

mydata<-read_csv("Data/PS3/crying_babies.csv")
View(mydata)

qqp(mydata$cryduration, "norm")
qqp(mydata$IQ, "norm")

mydata$logIQ<-log(mydata$IQ)
qqp(mydata$logIQ, "norm")

mycor<-cor.test(mydata$cryduration,mydata$logIQ,method="pearson")
mycor

###################################################
#PS3_4

rm(list=ls())

mydata<-read_csv("Data/PS3/streams.csv")
View(mydata)

model<-lm(NumberSpp~Biomass, mydata)

plot(NumberSpp~Biomass, mydata)
abline(model)

qqp(residuals(model), "norm")

mydata$logBio<-log(mydata$Biomass)
model<-lm(NumberSpp~logBio, mydata)
qqp(residuals(model), "norm")

plot(NumberSpp~logBio, mydata)
abline(model)

outlierTest(model)
influencePlot(model)
plot(model)
plot(model, 4)

summary(model)

###################################################
# PS3_5

rm(list=ls())

mydata<-read_csv("Data/PS3/algae.csv")
View(mydata)

plot(Surface_area~Height,mydata)
model<-lm(Surface_area~Height,mydata)
abline(model)

qqp(residuals(model))
mydata$logSA<-log(mydata$Surface_area)
mydata$logH<-log(mydata$Height)
model<-lm(logSA~logH,mydata)
qqp(residuals(model))

ggplot(mydata, aes(x=logH, y=logSA))+
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point(shape=1) + 
  guides(fill=FALSE) + 
  ylab("ln Surface Area") +
  xlab("ln Height") +
  geom_smooth(method="lm")

summary(model)

outlierTest(model)
influencePlot(model)
plot(model)
plot(model, 4)

###################################################
#PS3_6 Multiple Regression

rm(list=ls())

mydata<-read_csv("Data/PS3/krat.csv")
View(mydata)

# create individual regression models
mod1<-lm(krat_density~shrubcover,mydata)
mod2<-lm(krat_density~seedproduction,mydata)
mod3<-lm(krat_density~snakedensity,mydata)

# check linearity of data
plot(krat_density~shrubcover, data=mydata)
abline(mod1)

plot(krat_density~seedproduction, data=mydata)
abline(mod2)

plot(krat_density~snakedensity, data=mydata)
abline(mod3)

# check assumptions
plot(mod1)
plot(mod2)
plot(mod3)

# stats of individual regressions
summary(mod1)
summary(mod2)
summary(mod3)

# create multiple regression model
fullmodel<-lm(krat_density~snakedensity+seedproduction+shrubcover,mydata)

# check collinearity
library(GGally)
X<-mydata[,c(2,3,4)]
ggpairs(X)

library(mctest)
imcdiag(fullmodel)

# create all other possible models
reduced1<-lm(krat_density~shrubcover+seedproduction, data=mydata)
reduced2<-lm(krat_density~shrubcover+snakedensity, data=mydata)
reduced3<-lm(krat_density~seedproduction+snakedensity, data=mydata)

# Get AIC values for the best fit model
AIC(fullmodel)
AIC(mod1)
AIC(mod2)
AIC(mod3)
AIC(reduced1)
AIC(reduced2) # lowest, best fit
AIC(reduced3)

# stats for best fit model
summary(reduced2)

# check assumptions
plot(reduced2)
qqp(residuals(reduced2))

# Get the partial standardized regression coefficients for each factor
# how much variation is explained by each predictor variable
library(QuantPsyc)
lm.beta(reduced2)

######################################################################################################
######################################################################################################
######################################################################################################
# PS4_2 One-way ANOVA

rm(list=ls())

mydata<-read_csv("Data/PS4/rootshoot.csv")
View(mydata)

# as.factor
mydata$Nitrogen<-as.factor(mydata$Nitrogen)

# Create model
model<-aov(RootShoot~Nitrogen, mydata)

# Check assumptions
plot(model)

mydata$logRS<-log(mydata$RootShoot)
model<-aov(logRS~Nitrogen, mydata)
plot(model)
qqp(residuals(model),"norm")

# stats
anova(model)

# post-hoc Tukey test (requires aov())
TukeyHSD(model)

# HSD.test (gives you letters for different groups which is convenient)
library(agricolae)
HSD.test(model, "Nitrogen", console=TRUE)

# Graph data means
library(emmeans)
graphdata<-as.data.frame(emmeans(model, "Nitrogen"))
graphdata

# append a new column to graph data with the Tukey results in order
graphdata$tukey<-list("a","b","c","d")
graphdata

library(ggplot2)
ggplot(data=graphdata, aes(x=Nitrogen, y=emmean, fill=Nitrogen)) +
  theme_bw()+
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("log Root:Shoot Ratio") +
  xlab("Soil Nitrogen") +
  scale_x_discrete(labels=c("Low" = "Low", "Ambient" = "Ambient", "1.5N" = "1.5 N", "2N" = "2 N")) +
  geom_errorbar(aes(ymax=emmean +SE, ymin=emmean - SE), stat="identity", position=position_dodge(width=0.9), width=0.1)+
  geom_text(aes(label=tukey), position = position_dodge(width=0.9), vjust=-2.7)+
  geom_hline(yintercept=0)


###################################################
# PS4_3 One-way ANOVA with contrasts

rm(list=ls())

mydata<-read_csv("Data/PS4/seedsrodents.csv")
View(mydata)

# as.factor
mydata$Treatment<-as.factor(mydata$Treatment)

# check balance
summary(mydata)

# Create model
model<-aov(seed.mass~Treatment, mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

# model stats
anova(model)

# check level order
levels(mydata$Treatment) # Control, Exclusion, Fence control

# create orthogonal coefficients
c1<-c(1, 0 , -1) # no exclosure vs exclosure
c2<-c(1/2, -1, 1/2) # rodent presence vs no rodent presence

# combine vectors into a matrix
contrastmatrix<-cbind(c1,c2)

# attach the contrast matrix to the dataset
contrasts(mydata$Treatment)<-contrastmatrix

# run the two contrasts (model has to be aov())
summary(model, split=list(Treatment=list("Effect of Fence"=1, "Effect of Rodents"=2))) # 1 and 2 correspond to c1 and c2

# or, doing a bonferonni adjustment
c3<-c(0, 1, -1) # rodent presence vs no rodent presence for fenced treatments (because fence treatment has a significant impact)
contrastmatrix<-cbind(c1,c3)
contrasts(mydata$Treatment)<-contrastmatrix
summary(model, split=list(Treatment=list("Effect of Fence"=1, "Effect of Rodents"=2))) # 1 and 2 correspond to c1 and c2
# where critical p value (alpha) = 0.5/2 = 0.025

# alterantively, do a post-hoc Tukey HSD test
anova(model)

TukeyHSD(model)
# or
library(agricolae)
HSD.test(model, "Treatment", console=TRUE)

###################################################
# PS4_5 Nested ANOVA and Variance Components

rm(list=ls())

mydata<-read_csv("Data/PS4/montastraea.csv")
View(mydata)

# as.factor
mydata$Genotype<-as.factor(mydata$Genotype)
mydata$Ramet<-as.factor(mydata$Ramet)

# create model
library(lme4)
library(lmerTest)
#To get variance components, we need to model both variables as independent random variables
model<-lmer(Calyxarea~1 + (1|Genotype) + (1|Ramet:Genotype), data=mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

# get variance components
summary(model)
# Ramet:Genotype: variation within Genotype, variation among ramets
# Genotype: variation among Genotypes
# Residual: variation within ramets, variation among replicates

# plot the data using the nested model
model<-lmer(Calyxarea~Genotype + (1|Genotype:Ramet), mydata)

# get the marginal means for Genotype
graphdata<-as.data.frame(emmeans(model, ~Genotype))
graphdata

ggplot(data=graphdata, aes(x=Genotype, y=emmean, fill=Genotype)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge") + 
  labs(x="Genotype", y="Calyx Area") + #labels the x and y axes
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.5), width=0.1)


###################################################
# PS4_6 Two-way ANOVA

rm(list=ls())

mydata<-read_csv("Data/PS4/temp_CO2.csv")
View(mydata)

# as.factor
mydata$Temperature<-as.factor(mydata$Temperature)
mydata$CO2<-as.factor(mydata$CO2)

# check balance
summary(mydata)

# create model
model<-lm(growth~Temperature+CO2+Temperature:CO2,mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

# stats
anova(model)

# AIC
AIC(model)
reduced<-lm(growth~Temperature+CO2,mydata)
AIC(reduced)

# plot
graphdata<-as.data.frame(emmeans(model, ~Temperature*CO2))
graphdata

ggplot(data=graphdata, aes(x=Temperature, y=emmean, fill=factor(CO2),group=factor(CO2))) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge") + 
  labs(x="Temperature", y="Coral Growth (mm^2)", fill="CO2") + #labels the x and y axes
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.5), width=0.1)


######################################################################################################
######################################################################################################
######################################################################################################
#PS5_1 Mixed Model ANOVA

rm(list=ls())

mydata<-read_csv("Data/PS5/electromagnetic_effects.csv")
View(mydata)

# as.factor
mydata$Donor<-as.factor(mydata$Donor)
mydata$Treatment<-as.factor(mydata$Treatment)

# check balance
summary(mydata)

# create model - donor as random and include interactive effect of random on fixed
model<-lmer(WBCcolonies~Treatment+(1|Donor)+(1|Treatment:Donor),mydata)

# check assumptins
plot(model)
qqp(residuals(model),"norm")

# stats
anova(model)

###################################################
# PS5_2 Three-way ANOVA

rm(list=ls())

mydata<-read_csv("Data/PS5/plantcompetition.csv")
View(mydata)

mydata<-mydata[-5]

# as.factor
mydata$Species<-as.factor(mydata$Species)
mydata$clipped<-as.factor(mydata$clipped)
mydata$weeded<-as.factor(mydata$weeded)

# check balance
summary(mydata) # need to run type III Anova()

# create model
model<-lm(flowers~Species*clipped*weeded, mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

mydata$logflower<-log(mydata$flowers+1)
model<-lm(logflower~Species*clipped*weeded, mydata)
plot(model)
qqp(residuals(model),"norm")

# stats on full model
Anova(model,type="III")

# reduce model without three way interaction term
reduced1<-lm(logflower~Species+clipped+weeded+Species:clipped+Species:weeded+clipped:weeded,mydata)

# check AIC
AIC(model)
AIC(reduced1) #slightly better

# compare with Likelihood ratio test
anova(model,reduced1) # effectively the same

# if you wanted, stats on reduced model
Anova(reduced1,type="III")

# estimated marginal means
library(emmeans)
emmeans(model, ~Species)
emmeans(model, ~clipped) 
emmeans(model, ~weeded*Species)

# to calculate effect of clipping: 
# clipping mean(2.05) - no clipping mean(2.71) = -0.66 / no clipping mean(2.71) 
# = -0.244 * 100 = 24% reduction due to clipping

###################################################
# PS5_3 Mixed model block design

rm(list=ls())

mydata<-read_csv("Data/PS5/mammals.csv")
View(mydata)

# as.factor
mydata$disease<-as.factor(mydata$disease)
mydata$parasite<-as.factor(mydata$parasite)
mydata$block<-as.factor(mydata$block)

# check balance
summary(mydata)

# create model
model<-lmer(abundance~disease*parasite+(1|block)+(1|disease:block)+(1|parasite:block)+(1|disease:parasite:block),mydata)

# check assumptions
plot(model)
qqp(residuals(model),"norm")

# stats
anova(model)

# estimated marginal means
emmeans(model, ~disease)
emmeans(model, ~parasite)

# plot for trends
library(emmeans)
graphdata<-as.data.frame(emmeans(model, ~disease*parasite))

library(ggplot2)
ggplot(graphdata, aes(x=disease, y=emmean, fill=factor(parasite), group=factor(parasite))) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", stat="identity", position="dodge", size=0.6) +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) +
  labs(x="disease", y="abundance", fill="parasite") 


###################################################
#PS5_4 Repeated Measures ANOVA with nested design

rm(list=ls())

mydata<-read_csv("Data/PS5/coral_acclimation.csv")
View(mydata)

# as.factor
mydata$temperature<-as.factor(mydata$temperature)
mydata$coral<-as.factor(mydata$coral)
mydata$day<-as.factor(mydata$day)

# check balance
summary(mydata)

# create model
model<-lmer(FvFm~temperature*day+(1|temperature:coral),mydata)

# check assumptions





###################################################






###################################################






###################################################