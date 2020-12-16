# Barnas Final Practical

library(tidyverse)
#########################
# Question 1
#########################

library(car)
library(MASS)

rm(list=ls())

mydata<-read_csv("Data/Final/anorexia.csv")
View(mydata)

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
  summary


# create model
model1<-lmer(Weight ~ Treatment*Time + (1|Individual), data=mydata)

# check assumptions
plot(model1) # homogeneity looks good
hist(residuals(model1)) # looks normal
qqp(residuals(model1), "norm") # looks normal



qqp(mydata$Weight, "norm") 

# transform
mydata.log<-mydata%>%
  mutate(logWeight=log(Weight))
qqp(mydata.log$logWeight, "norm") # best normality, still not perfect

mydata.s<-mydata%>%
  mutate(sWeight=sqrt(Weight))
qqp(mydata.s$sWeight, "norm") # eh

# Repeated Measures ANOVA (for time as a fixed factor)
library(lme4)
library(lmerTest)


model1<-lmer(Weight ~ Treatment*Time + (1|Individual), data=mydata)
qqp(residuals(model1), "norm")

model2<-lmer(logWeight ~ Treatment*Time + (1|Individual), data=mydata.log) 
qqp(residuals(model2), "norm")


plot(model) # variance looks good
Anova(model, type="III")

# post-hoc
library(emmeans) # post-hoc test emmeans()

graphdata<-as.data.frame(emmeans(model, ~Treatment:Time)) #ignoring the random factor
graphdata

ggplot(data=graphdata, aes(x=Treatment, y=emmean, fill=Time, group=Time)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge", aes(fill=Time)) + 
  labs(x="Treatment", y="ln(Weight)", fill="Time") + #labels the x and y axes
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.5), width=0.1) +
  ggsave("Output/Final/Final_1.png")








