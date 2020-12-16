# Barnas Final Practical

library(tidyverse)
#########################
# Question 1
#########################

rm(list=ls())

mydata<-read_csv("Data/Final/anorexia.csv")
View(mydata)

library(car)
library(MASS)

T1<-mydata%>%
  filter(Time=="Time1")
qqp(T1$Weight)
T1<-T1%>%
  summarise(mean=mean(Weight),
            mediam=median(Weight),
            sd=sd(Weight),
            se=sd(Weight)/(sqrt(length(Weight))),
            cv=sd(Weight)/mean(Weight)*100)
T1
T2<-mydata%>%
  filter(Time=="Time2")
qqp(T2$Weight)
T2<-T2%>%
  summarise(mean=mean(Weight),
            mediam=median(Weight),
            sd=sd(Weight),
            se=sd(Weight)/(sqrt(length(Weight))),
            cv=sd(Weight)/mean(Weight)*100)
T2

# parse to factor type
mydata$Individual<-as.factor(mydata$Individual)
mydata$Treatment<-as.factor(mydata$Treatment)
mydata$Time<-as.factor(mydata$Time)

mydata%>%
  group_by(Treatment)%>%
  summary # unequal treatment sample sizes

# Repeated Measures ANOVA (for time as a fixed factor)
library(lme4)
library(lmerTest)

model<-lmer(Weight ~ Treatment*Time + (1|Individual), data=mydata)

# check assumptions
plot(model) # homogeneity looks good
hist(residuals(model)) # looks normal
qqp(residuals(model), "norm") # looks normal

Anova(model, type="III") # unequal sample size - gives chisquared value and p
anova(model) # gives f df and p (same p as above)

# post-hoc
library(emmeans) # post-hoc test emmeans()

graphdata<-as.data.frame(emmeans(model, ~Treatment:Time)) #ignoring the random factor
graphdata

ggplot(data=graphdata, aes(x=Treatment, y=emmean, fill=Time, group=Time)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge", aes(fill=Time)) + 
  labs(x="Treatment", y="Weight (lbs)", fill="Time") + #labels the x and y axes
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.5), width=0.1) +
  ggsave("Output/Final/Final_1.png")








