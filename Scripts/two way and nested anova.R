#How to do two-way ANOVA and Nested ANOVA

#Let's start with a two-way ANOVA using the SnailData 

#Clear the environment
rm(list=ls())

#Import the data. 
mydata <- read.csv("Data/SnailData.csv")
View(mydata)

#Let's say we wanted to ask about the effects of Location and Tidal Height on snail length

#Two Factor ANOVA (not nested)
model1<-lm(Length~Location + TidalHeight, data=mydata)

anova(model1)

#The code above gives you the main effects of Location and Tidal Height. In a real two-way ANOVA, we'd 
#also like the interaction. 
model2<-lm(Length~Location + TidalHeight + Location:TidalHeight, data=mydata)
#or a shortcut that includes both factors plus the interaction:
model3<-lm(Length~Location*TidalHeight, data=mydata)

#Don't forget to check your model assumptions!
plot(model2)
#Looks good

#And then to get the ANOVA table:
anova(model2)

#Notice that the interaction is very significant. That means that the effect of
#tidal height depends on location. That's super interesting, but if we just looked
#at the model we ran without the interaction, we would have assumed that there's
#nothing interesting about tidal height or location.
anova(model1)

#Let's make a graph of those data
#I'm going to gather my summary data using emmeans
library(emmeans)
graphdata<-as.data.frame(emmeans(model2, ~ Location*TidalHeight))
graphdata

library(ggplot2)
ggplot(graphdata, aes(x=Location, y=emmean, fill=factor(TidalHeight), group=factor(TidalHeight))) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  labs(x="Location", y="Snail Length", fill="TidalHeight") + #labels the x and y axes
  scale_fill_manual(values=c("Low"="tomato","High"="dodgerblue2")) #fill colors for the bars






####NESTED ANOVA#########
#Ok, let's switch to Nested ANOVA
#Using a data set called "schoolteacher" which describes the scores of students in classrooms
#of different teachers at different schools

#Nested ANOVA. Uses the nested term as the error (i.e denominator) to construct F ratio to test main Factor.

#We'll use 'lmer', in library lme4, which allows you to specify random effects 
#(Nested factors are always random effects)

#Clear the environment
rm(list=ls())

#Import the data. 
mydata <- read.csv("Data/schoolteacher.csv")
View(mydata)

library(lme4)
library(lmerTest) #lmer doesn't like to give p-values, so we need another package to do that
model4<-lmer(Score~School + (1|Teacher:School), data=mydata)

#Note that adding 1| in front of a factor makes it a random effect. 


#Remember that we need to check the assumptions of our test
plot(model4)
#Homogeneity of Variance look ok

#When we're using lmer, we have to do the probability plot ourselves
library(car)
qqp(residuals(model4), "norm")
#Normality looks good too

#Now, we get the stats for the effect of School:
anova(model4)


#Now, as we discussed, R doesn't want us to test the significance of random effects,
#but there's a roundabout way we could do it. We can construct a model with and without
#the random factor and ask which one fits the data better. If the random effect
#significantly improves the fit, then it is important. We call this a Likelihood Ratio
#Test and here's how you do it:
model4<-lmer(Score~School + (1|Teacher:School), data=mydata) #the model we already made...with the random effect
model5<-lm(Score~School, data=mydata) #a model without the random effect

anova(model4, model5)
#this is the Likelihood Ratio Test. It gives AIC values for both models
#and it gives us a p-value for whether one is a better fit. We COULD technically
#use that p-value as a hypothesis test for the random effect



#Finally, if we assumed that both variables were random effects, we could get 
#variance components for both random effects and the error (which is also a random effect)
model6<-lmer(Score~1+(1|School) + (1|Teacher:School), data=mydata)
summary(model6)
#The variance components are listed under "Random effects" in the output
#If we add up all the numbers in the Variance column, that is the total
#variance. If we divided the variance of each factor by the total variance, then
#we would have the percent of variance explained by each source: Teacher, School, or Residual

#We might have considered School as fixed, and Teacher as random, as above
summary(model4)
#Now we only get variance components for Teacher and Residual. But we can see
#that variance due to Teacher is about 13 times greater than the error that is unexplained (residual)


#Now, if we want to graph this data, we need to consider something important
#Let's say you want to graph the means and se's of the three schools. Remember that the "replicate"
#for School is "teacher", not every data point. So we can't just ask for the average of each school
#Instead, we need to get the averages for each teacher, and then take the average
#of teacher-averages within each school.

#A short-cut to doing this is to ask for the estimated marginal means from the model, which will
#give us exactly that info
library(emmeans)
graphdata<-as.data.frame(emmeans(model4, ~School))
graphdata

library(ggplot2)
ggplot(data=graphdata, aes(x=School, y=emmean, fill=School)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("Score") +
  xlab("School") +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1)

#Note that using the estimated marginal means here is super important for getting
#the right error bars. Because "Teacher' is the replicate, there are 2 replicates per school
#If we tried to get the means without accounting for teacher, we would have pseudoreplicated.
#The error bars would be smaller, but this would be wrong
#For example:
library(tidyr)
library(dplyr)
graphdata2 <- mydata %>%
  group_by(School) %>%
  summarize(mean=mean(Score), se=sd(Score)/sqrt(length(Score)))
graphdata2

ggplot(data=graphdata2, aes(x=School, y=mean, fill=School)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("Score") +
  xlab("School") +
  geom_errorbar(aes(ymax=mean+se, ymin=mean-se), stat="identity", position=position_dodge(width=0.9), width=0.1)

