#This is data from Mary Alice's Coffroth's lab that examine the growth rate (r) and
#carrying capacity (K) of different genotypes of coral symbionts, grown at 
#two different temperatures

#We'll consider Temp as a fixed factor and then try Genotype as both a random and fixed effect


#Clear environment
rm(list=ls())


mydata<-read.csv("Data/SymbioGrowth.csv")
View(mydata)


#We need to make sure that both Temp and Genotype are considered as factors
mydata$Temp<-as.factor(mydata$Temp)
mydata$Genotype<-as.factor(mydata$Genotype)


#First, let's try modeling the effects of Temperature and Genotype on r 
#as both fixed effects

model1<-lm(r~Temp*Genotype, data=mydata)
plot(model1) #Check assumptions
library(car)
qqp(residuals(model1), "norm")

#This all looks pretty good!

#Run ANOVA on that model
anova(model1)
#or we could have used capital A anova and found the same thing
library(car)
Anova(model1, type="III")  #this also requires library(car). This is useful is you ever want to
#use Type II or Type III sums of squares. Type II is the default for Anova and 
#type III is the default if you use anova with lmerTest

#If you wanted to do a post-hoc test
library(emmeans)
emmeans(model1, pairwise~Temp*Genotype, adjust="tukey")

#I wanted to use agricolae, but had to futz with this a little to make this happen
#Tukey tests
tx<-with(mydata, interaction(Temp, Genotype))
rmod<-lm(r~tx, data=mydata)
library(agricolae)
HSD.test(rmod, "tx", console=TRUE)


#Ok, now let's model Genotype as a random effect
#We have to use lmer now because lm can't handle random effects
#There are also other commands in other libraries that handle random effects
#such as lme or nlme, but the syntax is different, so I'm going to stick with lmer

library(lme4)
library(lmerTest) #Need this to get anova results from lmer

#If we JUST wanted to model Genotype as a random effect and ignore Temperature

model2<-lmer(r~1 + (1|Genotype), data=mydata)
summary(model2) #We can use summary to get variance components
# shows variance components
# if we want to know if our model is running correctly, look at the degrees of freedom
# if you have a mixed model and testing hte fixed effect. F ratio = MS-fixed effect / MS-interaction (so look at those two degrees of freeom, not the df of the residuals)

#Let's add in Temperature as a fixed effect
model3<-lmer(r~Temp + (1|Genotype) + (1|Temp:Genotype), data=mydata)
#You might be a singular fit warning here. Ignore that for now. You can still proceed.
summary(model3)
anova(model3)
# not as good a test. look at the degrees of freedom. F ratio is MS-fixed effect / MS-residuals


#Note that R will only test the significance of fixed effects
#If we really want to test the significance of a random effect, then we need to 
#use a likelihood ratio test by comparing models with and without the random effect
#One way to do this:
model4<-lm(r~Temp, data=mydata) #Model with only temperature
anova(model3, model4) #LRT to determine effect of Genotype


#graphs
#If we want to graph the effects of Temperature when Genotype is a random effect
#then it's particularly important that we don't use the raw data for the graph, but
#get the estimated marginal means, which will give us the correct SEs

library(emmeans)
graphdata<-as.data.frame(emmeans(model3, ~Temp))
graphdata

###BarPlot of growth rates
library(ggplot2)
ggplot(graphdata, aes(x=Temp, y=emmean)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  labs(x="Temperature", y="growth rate (r)") + #labels the x and y axes
  scale_fill_manual(values=c("26"="dodgerblue2","30"="red3")) #fill colors for the bars


###BoxPlot of growth rates
library(ggplot2)
ggplot(mydata, aes(x=Temp, y=r)) +
  geom_boxplot(position=position_dodge(1)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  labs(x="Temperature", y="growth rate (r)") +
  scale_fill_manual(values=c("26"="dodgerblue2","30"="red3"))

