# Problem Set 1

# Question 4: create a graph showing means and se identical to a graph in excel
library(tidyverse)
mydata<-read_csv("Data/ProblemSet1.csv")
View(mydata)

mydata<-mydata%>%
  pivot_longer(cols=c('Top','Bottom'), names_to="Location",values_to="Density") %>%
  arrange(Location)

# statistics

myMean <- mydata %>%
  group_by(Location) %>%
  summarize(meanDensity=mean(Density, na.rm=TRUE), se=sd(Density, na.rm=TRUE)/sqrt(length(na.omit(Density))))

mySD<-mydata%>%
  group_by(Location) %>%
  summarise(SD=sd(Density))

myVar<-mydata%>%
  group_by(Location)%>%
  summarise(Variance=var(Density))
# alternate method for variance
myVar2<-mySD%>%
  group_by(Location)%>%
  mutate(Var=(SD^2))

# 95% confidence intervals
# 95% CI = mean +/- sd*1.96
myConfidence<-mydata%>%
  group_by(Location)%>%
  summarise(meanDensity=mean(Density,na.rm=T),StDev=sd(Density,na.rm=T))%>%
  mutate(posCI=meanDensity+StDev*1.96, negCI=meanDensity-StDev*1.96)

# graphing

ggplot(myMean, aes(x=Location, y=meanDensity)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        plot.title = element_text(hjust = 0.5))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_errorbar(aes(ymax=meanDensity+se, ymin=meanDensity-se), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  labs(x="Microcosm Sample Location", y="Protozoa Densities (# per uL)") + #labels the x and y axes
  scale_fill_manual(values=c("Bottom"="blue","Top"="blue")) + #fill colors for the bars
  ggsave("Output/PS1.png")
