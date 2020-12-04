# Problem Set 6

##################
# Question 1
##################
# Power Analysis

library(pwr)
# a)
pwr.t.test(d = 1/1.5, sig.level = 0.05, power = 0.8, type = "two.sample")
# b)
pwr.t.test(d = 3/1.5, sig.level = 0.05, power = 0.8, type = "two.sample")
# c)
pwr.t.test(d = 3/1.5, sig.level = 0.01, power = 0.8, type = "two.sample")
# d)
pwr.t.test(n = 10, sig.level = 0.05, power = 0.8, type = "two.sample")
# ES (d) = detectable difference / sd
0.909158 * 1.5
1.324947 * 1.5


##################
# Question 2
##################
# Generalized Linear Model GLM

rm(list = ls())

library(tidyverse)

mydata<-read_csv("Data/PS6/Medicago.csv")

#Step 1: Determine the best error distribution
library(car)
library(MASS)

#First, try a normal distribution
qqp(mydata$Fruits, "norm") 
# not normal

# try a lognormal distribution
qqp(mydata$Fruits, "lnorm") # still not great, but better

gamma<-fitdistr(mydata$Fruits, "gamma")
qqp(mydata$Fruits, "gamma", shape = gamma$estimate[[1]], rate=gamma$estimate[[2]])
# that looks good!

#Try negative binomial
nbinom <- fitdistr(mydata$Fruits, "Negative Binomial")
qqp(mydata$Fruits, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# maybe better than gamma?

#Try poisson
poisson <- fitdistr(mydata$Fruits, "Poisson")
qqp(mydata$Fruits, "pois", lambda=poisson$estimate)
# nope

# We'll go with gamma

library(lme4)
#Step2: fit a model with our chosen error distribution
# to fit a gamma distribution
model<-glmer(Fruits~Disturbance*Range + (1|Range:Genotype), family=Gamma(link="inverse"), data=mydata)

#Now to get results from the gamma model
Anova(model, type="III") #This does Likelihood Ratio Tests on each fixed factor
# get a chi-squared value and p-value testing the significance of each effect

#to test random effect, create model without the random effect
model2<-glm(Fruits~Disturbance*Range, family=Gamma(link="inverse"), data=mydata)
anova(model, model2) #result is significance of the random effect
# report chisquared, p, and df

#Result is that model is a significantly better fit, which means that Genotype was important
#in determining the number of Fruits

library(emmeans)
graphdata<-as.data.frame(emmeans(model,~Range*Disturbance))
graphdata

# if we wanted to plot
ggplot(data=mydata, aes(x=Range, y=Fruits, fill=Disturbance)) +
  theme_bw()+
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(aes(fill=Disturbance), width=0.5, stat="identity", position = "dodge") +
  labs(y="Fruits Produced")

ggplot(data=graphdata, aes(x=Range, y=emmean, fill=Disturbance)) +
  theme_bw()+
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(aes(fill=Disturbance), width=0.5, stat="identity", position = "dodge") +
  labs(y="Fruits Produced") +
  geom_errorbar(aes(ymax=emmean +SE, ymin=emmean - SE), stat="identity", position=position_dodge(width=0.5), width=0.1)


##################
# Question 3
##################
# Logistic Regression GLM

rm(list = ls())

library(tidyverse)
mydata<-read_csv("Data/PS6/surfperch_mating.csv")

mydata<-mydata%>%
  rename(malesize="male size")

hist(mydata$mated)
#Notice that the data is binomially distributed. There are only two possible outcomes
#(mated or did not mote). So we can fit a binomial error distribution to our data

library(lme4)
library(car)
model <- glm(mated ~ malesize, family = "binomial"(link="logit"), data=mydata)
Anova(model,type="III")

#We'd also like to get a pseudo R^2 value that tells us how much of the variance
#in mating probility is explained by the male size

library(pscl)
pR2(model) #gives pseudo R^2
#The last three columsn are all different types of pseudo-R^2s.
#I usually use McFadden's rho-square


#To plot the data
#Simple plot
plot(mydata$malesize,mydata$mated,xlab="Male Size",ylab="Probability of Mating")
curve(predict(model,data.frame(malesize=x),type="resp"),add=TRUE) # draws a curve based on prediction from logistic regression model

#Here's some code for making a nicer plot with ggplot
predicted.data<-as.data.frame(predict(model, type="response", se=TRUE))

library(ggplot2)
ggplot(mydata, aes(x=mydata$malesize, y=mydata$mated)) +
  theme_bw() +
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() +
  geom_smooth(data = predicted.data, aes(y=fit)) +
  labs(x="Male Size", y="Probability of Mating") + 
  ggsave("Output/PS6_2.png")




  