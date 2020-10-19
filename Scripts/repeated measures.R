#How to do "repeated measures ANOVA" with mixed models and graph results

#We'll use a dataset that has plants from two treatments....Control and Fertilized
#There were 12 plants in total. 6 in each treatment.
#Root length was measured every two weeks until week 10
#Note that it's particularly important that you include a column that identifies different plants from each other.

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/fertdata.csv")
View(mydata)

#Make sure that week is a factor
mydata$week<-as.factor(mydata$week)

#If you want a quick plot of your data, here's some code. But there are no error bars.
#See below for how to do this in ggplot
with(mydata, interaction.plot(week, fertilizer, root, frame.plot=FALSE,
          ylim = c(0, 12), lty = c(1, 12), lwd = 3,
          ylab = "mean root length", xlab = "weeks", trace.label = "fertilizer"))
abline(h=0)

#The easiest way to analyze this as a repeated measures design:
library(lme4)
library(lmerTest)
model1<-lmer(root ~ fertilizer + (1|plant) + (1|fertilizer:plant), data=mydata)
anova(model1)

model2<-lmer(root ~ fertilizer*week + (1|fertilizer/plant), data=mydata) 
# colon and slash do the same thing. show a nested factor B within A by writing like A/B or A:B
anova(model2)

# time is a categorical factor
# doesn't necessarily show a pattern throughout time. just shows if there's a difference over time
# shows if there's a difference over time, not a particular relationship over time
# shows that fertilizer has a different affect over time

# interpretation: there is a significant interaction between fertilizer and week, so would say fertilizer depends on week and because
# they depend on each other you can't really say anything about the independent effect of either
# start with the interaction and go from there for interpretations

#Note that we get a significant fertilizer*week interaction, so we have to stop our interpretation there.
#The interaction means that the effect of the fertilizer treatment depends on which week it was measured in.
#Probably this is driven by the fact the the fertilizer treatment has a bigger effect at week 6 than other weeks.


#To plot
library(emmeans)
graphdata<-as.data.frame(emmeans(model1, ~fertilizer:week))
graphdata


library(ggplot2)
ggplot(graphdata, aes(x=week, y=emmean, group=fertilizer, color=fertilizer)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank())+ 
  geom_line(aes(linetype=fertilizer)) +
  geom_point()+
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", width=0.1) +
  labs(x="Week", y="root length") 


