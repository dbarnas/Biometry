#Code for doing simple ANOVA in R
#Again we will use our old friend, the Snail Data

#Let's say we want to know the effect of tidal height (High or Low) on snail length
#We're going to ignore the other variables for now.

#Clear the environment
rm(list=ls())

#Import the data. 
mydata <- read.csv("Data/SnailData.csv")
View(mydata)

# in case R doesn't bring in the character vector as factors already, this will parse to factor
mydata$TidalHeight<-as.factor(mydata$TidalHeight) 

# want to know: is tidal height a predictor of the length of snails
# run the model in the same way we run a regression:
# dependent variable first, then the factor/independent variable on the right, with a tilde between

#We fit the ANOVA model in the same way we the regression model
#The syntax is always "dependent_variable ~ factor"

# could also use the aov() function, but is more restrictued than lm(), which can be used for a lot of different things, including an anova

model2<-lm(Length~TidalHeight, data=mydata)

#Now let's check our assumptions
plot(model2)

# first plot: are variances equal? look at the spread of points of both groups on the different sides of the plot
## anything more than 3x greater are probably unequal and may need to be transformed
## spread is about the same here
# second plot: normality
# third plot: same thing as the first plot, but the square root of the standardized residuals. tests the same thing. are variances equal
# fourth plot: leverage plot.  casey doesn't really use this for anova

# normality was fishy so do a qqp
library(car)
qqp(model2) # just a little off, but it's good enough

#I'm not 100% sure about the normal probability plot. Let's try it with confidence intervals
library(car)
resid1<-residuals(model2)
qqp(resid1, "norm")

#ok, that's not as bad as I thought. Let's go with it.

#To get the results of our model:
summary(model2)
# not super helpful. so instead ask for anova of model 2

#At the bottom, you get F, df, and P, which is what you need.
#For a one-way ANOVA, this is what you need. As we get into more complex ANOVAs, this won't
#be that helpful, as it tells you how well the whole model fits, but not the significance of
#each individual factor

#For future use, if you want to get the ANOVA table, then use:
anova(model2)

# gives degrees of freedom for residuals, sum of squares, mean square, f value and p value
# based on this. there is no difference between tidal heights.

#Note that this gives you the same information, but it's in the form of an ANOVA table

#Now, because we only had two levels of Tidal Height, we know the difference has to be between
#High and Low. But if we'd had a Mid level, then you wouldn't know which levels were different
#from each other. So although a Tukey test isn't necessary here, I want you to have the code for it

#However, if you used lm, then:
library(agricolae)
HSD.test(model2, "TidalHeight", console=TRUE)

# HSD: honestly significant difference
# give model, and give factors to compare to, and tell console = TRUE
# console spits out all the letters you'd need for a bar graph for visually representing significant difference between groups

#I like the code above because it assigns groups for you, which can be a real
#pain to figure out with more complicated ANOVAs or with lots of levels
#But here's another way to get Estimated Marginal Means for every level, while also
#doing a Tukey test
library(emmeans)
emmeans(model2, pairwise ~ "TidalHeight", adjust="Tukey")
#These are nice because I often use these EMM when making a plot, particularly
#for more complicated models
# emmeans tells us the means of each group (and there's also a way for it to show p values, but casey can't recall how to do that right now)

#To plot the data, you can try ggplot

library(tidyr)
library(dplyr)
graphdata <- mydata %>%
  group_by(TidalHeight) %>%
  summarize(mean=mean(Length, na.rm=TRUE), se=sd(Length, na.rm=TRUE)/sqrt(length(na.omit(Length))))
graphdata

library(ggplot2)
ggplot(data=graphdata, aes(x=TidalHeight, y=mean, fill=TidalHeight)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("Length") +
  xlab("Tidal Height") +
  scale_x_discrete(labels=c("Low" = "Low Tide", "High" = "High Tide")) +
  geom_errorbar(aes(ymax=mean+se, ymin=mean-se), stat="identity", position=position_dodge(width=0.9), width=0.1)

#If you wanted to use emmeans to generate the data for a plot, here's how you would do that
library(emmeans)
emms<-emmeans(model2, "TidalHeight")
emms
graphdata2<-as.data.frame(emms)
ggplot(data=graphdata2, aes(x=TidalHeight, y=emmean, fill=TidalHeight)) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("Length") +
  xlab("Tidal Height") +
  scale_x_discrete(labels=c("Low" = "Low Tide", "High" = "High Tide")) +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1)




