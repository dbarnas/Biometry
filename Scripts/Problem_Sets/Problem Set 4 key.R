#Problem Set 4 R Code
#Created by Casey terHorst 9/20/20


##Question 1##
#Do this in Excel

############################
###Question 2: Root-shoot###
############################
#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/rootshoot.csv")
View(mydata)

#Now make a model that predicts the effect of treatment effect on plant biomass
model1<-lm(RootShoot~Nitrogen, data=mydata)

#Before we look at the results, let's check our assumptions
plot(model1)

#The variance is one group is MUCH greater than the variance in the other groups.
#Also the data are not normal. 
#So let's try a log-transformation

mydata$logRootShoot<-log(mydata$RootShoot)

#Now let's fit a model with the transformed data and check assumptions again
model2<-aov(logRootShoot~Nitrogen, data=mydata)
plot(model2)
#variances are much closer than they were before. Data are close to normal.

#Just going to double check variances with a box plot and normality with probability plot
resid<-residuals(model2)
boxplot(resid~mydata$Nitrogen)
library(car)
qqp(resid, "norm")
#normality looks ok, variances still kinda equal, but less than three times in largest
#group compared to smallest...so ok

#To get results of ANOVA
anova(model2)

#To do a post-hoc Tukey test
TukeyHSD(model2)

#Could also use HSD.test (gives you letters for different groups which is convenient)
library(agricolae)
HSD.test(model2, "Nitrogen", console=TRUE)

#And let's create a bar plot of this data
#I'm going to just get the estimated marginal means for the graph
library(emmeans)
graphdata<-as.data.frame(emmeans(model2, "Nitrogen"))
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
  geom_errorbar(aes(ymax=emmean +SE, ymin=emmean - SE), stat="identity", position=position_dodge(width=0.9), width=0.1)

#Now, usually I just export that graph and them put it into Powerpoint or Illustrator
#to add the letters to the bars. Here I'm going to try to do it in R with geom_text

#I'm going to append a new column to graph data with the Tukey results in order
graphdata$tukey<-list("a","b","c","d")
graphdata

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

################################
###Question 3: Desert rodents###
################################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/seedsrodents.csv")
View(mydata)

#Need to make Treatment a factor
mydata$Treatment<-as.factor(mydata$Treatment)

#First, let's create a model and test our assumptions
model1<-aov(seed.mass~Treatment, data=mydata)
plot(model1)

#Assumptions look ok


#Second, let's create two vectors of coefficients for our two contrasts
#We want to know what order R thinks out levels are in
levels(mydata$Treatment)
#Note that R has listed the treatment levels alphabetically: Control, Exclusion, Fence Control 

c1<-c(1,0,-1) #Control vs. Fence Control
c2<-c(0.5,-1,0.5) #(Control + Fence Control) vs. Exclusion


#And now let's combine these two vectors together into a matrix:
contrastmatrix<-cbind(c1,c2)

#And now we're going to attach this contrast matrix to the dataset
contrasts(mydata$Treatment)<- contrastmatrix

#Now run the two contrasts like this:
summary(model1, split=list(Treatment=list("Effect of Fence"=1, "Effect of Rodents"=2)))

#The summary command includes the option: split. The split option provides a list of factors where 
#contrasts are stored. Within each factor, we also provide a list which includes the names of the contrasts 
#(i.e. each column) stored in the contrasts matrix columns (i.e. contrastmatrix).

#Because the fence control was different from the control, we might have instead wished to compare
#the fence control to the treatment instead. Then I would have used this contrast:
c3<-c(0, -1, 1) #this is not orthogonal, so if I Bonferroni-adjust, it means I need p<0.025 to consider it significant

contrastmatrix<-cbind(c3)

#And now we're going to attach this contrast matrix to the dataset
contrasts(mydata$Treatment)<- contrastmatrix

#Now run the two contrasts like this:
summary(model1, split=list(Treatment=list("Better Test of Rodents"=1)))

###Question 4###
#If we'd wanted to do Tukey post-hoc tests instead
model2<-aov(seed.mass~Treatment, data=mydata)
TukeyHSD(model2)
#or
library(agricolae)
HSD.test(model1, "Treatment", console=TRUE)


##############################
###Question 5: Coral genets###
##############################
##Question 2##
#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/montastraea.csv")
View(mydata)

#To get variance components, we need to model both variables as independent random variables
library(lme4)
model1<-lmer(Calyxarea~1 + (1|Genotype) + (1|Ramet:Genotype), data=mydata)

#Check assumptions
plot(model1) #homogeneity looks good
library(car)
qqp(residuals(model1), "norm") #normality looks good

#Get variance components
summary(model1)

#And now plot the data
#If we want to get the marginal means for Genotype, we need to make it a fixed effect first
model2<-lmer(Calyxarea~(Genotype) + (1|Ramet:Genotype), data=mydata)
#keeping Ramet as a nested random effect will make sure the average of each ramet is used
#as a replicate

library(emmeans)
graphdata<-as.data.frame(emmeans(model2, ~Genotype))
graphdata


library(ggplot2)
ggplot(data=graphdata, aes(x=Genotype, y=emmean, fill=Genotype)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("Calyx Area") +
  xlab("Genotype") +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1)


##############################
###Question 6: Temp and CO2###
##############################

#Clear the environment
rm(list=ls())

#Import the data
mydata <- read.csv("Data/temp_CO2.csv")
View(mydata)

#Because the two factors are independent we'll use two-way ANOVA.
#Both factors should be considered as fixed factors

model1<-lm(growth~Temperature + CO2 + Temperature:CO2, data=mydata)
#A shortcut to writing the same thing:
model1<-lm(growth~Temperature*CO2, data=mydata)

#Check assumptions
plot(model1)
library(car)
qqp(residuals(model1), "norm")
#Looks good

#Get F-values and P-values from the model
anova(model1)

#And now make a graph
library(emmeans)
graphdata<-as.data.frame(emmeans(model1, ~Temperature*CO2))
graphdata

library(ggplot2)
ggplot(graphdata, aes(x=Temperature, y=emmean, fill=factor(CO2), group=factor(CO2))) +
  theme_bw()+
  theme(legend.title=element_text(colour="black", size=14), axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", stat="identity", position="dodge", size=0.6) +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) +
  labs(x="Temperature", y="Coral Growth (mm^2)", fill="CO2") +
  scale_fill_manual(values=c("ambient"="dodgerblue","high"="tomato"))




