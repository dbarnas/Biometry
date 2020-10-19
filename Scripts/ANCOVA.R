#How to do ANCOVA (Analysis of Covariance)

#Use Snail Data example again

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/SnailData.csv")
View(mydata)

#Before we start, let's just get rid of the annoying NA
mydata<-mydata[-26,]

#We'll have two predictor variables for snail weight: TidalHeight, a discrete variable, which imported as a factor (good), 
#and length, a continuous variable, which imported as a number (good)
#Now we can just run our ANOVA using these two predictor variables.
model1<-lm(Weight ~ TidalHeight * Length, data=mydata)

#Check assumptions
plot(model1)

#Remember that you also want to make sure that the relationship with covariate is linear
plot(Weight~Length, data=mydata)

#good

#If the design is balanced, then can just ask for results from our model
anova(model1)

#If you have an unbalanced design, then you should use Type III SS
library(car)
Anova(model1, type="III")

#You can stop right there if you want, but if you wanted to go further and do model selection
#Interaction term is highly non-significant, so you might want to do model selection and decide whether or not to drop it
#Let's look at AIC with and without
model2<-lm(Weight ~ TidalHeight + Length, data=mydata)
AIC(model1)
AIC(model2)

#Model without the interaction is a tiny bit better, but they're basically the same.
#You would be justified in going with the simpler model though...so let's go without the interaction then.
anova(model2)


#But for plotting the data, I'm going to stick with our original model
#To plot the data:

predWeight<-predict(model2) #Gets the predicted values from the regression lines in the ANCOVA
graphdata<-cbind(mydata, predWeight) #attaches those predictions to the dataset

library(ggplot2)
ggplot(data=graphdata, aes(Length, Weight, color=TidalHeight)) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point() + geom_line(aes(y=predWeight)) +
  labs(x="Length", y="Weight", fill="TidalHeight")
