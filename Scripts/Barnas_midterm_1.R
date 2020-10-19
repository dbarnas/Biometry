# Danielle Barnas
# Midterm Part B

########################
# Question 1
########################
library(tidyverse)

data1<-read_csv("Data/cancer.csv")
View(data1)

# use a paired t-test for before-after

# check raw data for normality and variance
data1.wide<-data1%>%
  pivot_wider(names_from = "Time", values_from="CellGrowth")
View(data1.wide)

# check normality and homogeneity of variance
hist(data1.wide$Before) # not normal, slightly left skewed
hist(data1.wide$After) # not normal, slightly right skewed

boxplot(data1.wide$Before)
boxplot(data1.wide$After)
# variance appears similar

# attempt log transformation to achieve greatest normality
data1.log<-data1%>%
  mutate(log=log(CellGrowth))%>%
  select(-c(CellGrowth))
data1.wide.log<-data1.log%>%
  pivot_wider(names_from = "Time", values_from="log")
View(data1.wide.log)

# check normality and homogeneity of variance
hist(data1.wide.log$Before) # appears more normal
hist(data1.wide.log$After) # appears more normal

boxplot(data1.wide.log$Before)
boxplot(data1.wide.log$After)
# variance appears similar

# attempt square root transformation to achieve greatest normality

data1.s<-data1%>%
  mutate(s=sqrt(CellGrowth))%>%
  select(-c(CellGrowth))
data1.wide.s<-data1.s%>%
  pivot_wider(names_from = "Time", values_from="s")
View(data1.wide.s)

# check normality and homogeneity of variance
hist(data1.wide.s$Before) # appears more normal than raw but not log
hist(data1.wide.s$After) # appears more normal than raw and log

boxplot(data1.wide.s$Before)
boxplot(data1.wide.s$After)
# variance appears similar

### will use log transformed data for paired t-test

mytest1<-t.test(data1.wide.log$Before, data1.wide.log$After, paired=TRUE)
mytest1


meanBefore<-mean(data1.wide.log$Before)
meanAfter<-mean(data1.wide.log$After)

EffectSize<- (meanBefore-meanAfter)/meanBefore
EffectSize

data1.log.sum<-data1.log%>%
  group_by(Time)%>%
  summarise(mean(log), se=sd(log)/sqrt(length(log)))
data1.log.sum


########################
# Question 2
########################

# part a

data2<-read_csv("Data/Temps.csv")
View(data2)

data2%>%
  summary() #yields mean and median
sd<-sd(data2$Temperature)
sd
sem<-sd((data2$Temperature)/sqrt(length(data2$Temperature)))
sem
CV<- sd/(mean(data2$Temperature))*100
CV

# part b
# bootstrapping

bootmeans<-replicate(1000, {
  samples<-sample(data2$Temperature,replace=TRUE); 
  mean(samples)  })

bootmeans
mean(bootmeans) 

#confidence intervals
sortedboots<-sort(bootmeans) # sort bootstrapped means in numeric order

lowCI<-sortedboots[25]
highCI<-sortedboots[975]
lowCI
highCI

# histogram of our bootrapped mean data with upper and lower confidence intervals
# shown as blue vertical lines
hist(sortedboots) 
abline(v=lowCI, col="blue")
abline(v=highCI, col="blue")

# part c
# one-sample t-test
hist(data2$Temperature) # appears normal

mytest2<-t.test(data2$Temperature, mu=98.6, na.rm=TRUE)
mytest2




########################
# Question 3
########################

data3<-read_csv("Data/Sargassum.csv")
View(data3)

# use a two-sample t-test to compare under kelp vs open

# check raw data for normality and variance
data3.kelp<-data3%>%
  filter(treatment=="underkelp")
data3.open<-data3%>%
  filter(treatment=="open")

# check normality and homogeneity of variance
hist(data3.kelp$biomass) # not normal, right skewed
hist(data3.open$biomass) # not normal, right skewed

boxplot(data3.kelp$biomass)
boxplot(data3.open$biomass)
# variance is dissimilar 

# attempt log transformation to achieve greatest normality
data3.log<-data3%>%
  mutate(log=log(biomass))%>%
  select(-c(biomass))
data3.kelp<-data3.log%>%
  filter(treatment=="underkelp")
data3.open<-data3.log%>%
  filter(treatment=="open")

# check normality and homogeneity of variance
hist(data3.kelp$log) # appears normal
hist(data3.open$log) # more normal

boxplot(data3.kelp$log)
boxplot(data3.open$log)
# variance appears more similar


# attempt square root transformation to achieve greatest normality
data3.s<-data3%>%
  mutate(s=sqrt(biomass))%>%
  select(-c(biomass))
data3.kelp<-data3.s%>%
  filter(treatment=="underkelp")
data3.open<-data3.s%>%
  filter(treatment=="open")

# check normality and homogeneity of variance
hist(data3.kelp$s) # appears less normal than log
hist(data3.open$s) # more normal than raw

boxplot(data3.kelp$s)
boxplot(data3.open$s)
# variance appears less similar

### will use log transformed data for paired t-test
mytest3<-t.test(log~treatment, data=data3.log, na.rm=TRUE)
mytest3

data3.log.sum<-data3.log%>%
  group_by(treatment)%>%
  summarise(meanlog=mean(log), se=sd(log)/sqrt(length(log)))
data3.log.sum


ggplot(data3.log.sum, aes(x=treatment, y=meanlog)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        plot.title = element_text(hjust = 0.5))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_errorbar(aes(ymax=meanlog+se, ymin=meanlog-se), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  labs(x="Canopy Type", y="Log Mean Sargassum Biomass (g/m2)") + #labels the x and y axes
  scale_fill_manual(values=c("Bottom"="blue","Top"="blue"))+ #fill colors for the bars
  ggsave("Midterm_1_3c.png")



