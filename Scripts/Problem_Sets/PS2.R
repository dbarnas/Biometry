# Problem Set 2

library(tidyverse)

# for skewness and kurtosis
library(moments)

#To make a probability plot with confidence intervals
library(car)
library(MASS)

###############
# Question 1
###############

data1<-read_csv("Data/kelp_bass_gonad_mass.csv")

summary<-data1%>%
  summary(gonad_mass)

# mean
mean<-mean(data1$gonad_mass, na.rm=TRUE)
# 8.24

# median
median<-median(data1$gonad_mass, na.rm=TRUE)
# 6.42

# variance
variance<-var(data1$gonad_mass, na.rm=TRUE)
# 57.9

# standard deviation
sd_a<-sqrt(variance) # or
sd_b<-sd(data1$gonad_mass, na.rm=TRUE)
# 7.61

# cv
cv<- sd_a/mean*100
# 92.4%

# skewness

skewness<-skewness(data1$gonad_mass, na.rm=TRUE)
# 1.43

# kurtosis
kurtosis<-kurtosis(data1$gonad_mass, na.rm=TRUE)
# 5.16

###############
# Question 2
###############

data2<-data1%>%
  mutate(gonad_pluss5=gonad_mass+5.0)
summary(data2)

# variance
var(data2$gonad_pluss5, na.rm=TRUE)
# sd
sd(data2$gonad_pluss5, na.rm=TRUE)
# cv
sd(data2$gonad_pluss5, na.rm=TRUE)/mean(data2$gonad_pluss5, na.rm=TRUE)*100
# skewness
skewness(data2$gonad_pluss5, na.rm=TRUE)
# kurtosis
kurtosis(data2$gonad_pluss5, na.rm=TRUE)


###############
# Questions 3
###############

data3<-data1%>%
  mutate(gonad_pluss5_mult10=(gonad_mass+5.0)*10)
summary(data3)

# variance
var(data3$gonad_pluss5_mult10, na.rm=TRUE)
# sd
sd(data3$gonad_pluss5_mult10, na.rm=TRUE)
# cv
sd(data3$gonad_pluss5_mult10, na.rm=TRUE)/mean(data3$gonad_pluss5_mult10, na.rm=TRUE)*100
# skewness
skewness(data3$gonad_pluss5_mult10, na.rm=TRUE)
# kurtosis
kurtosis(data3$gonad_pluss5_mult10, na.rm=TRUE)


###############
# Question 4
###############
data1<-read_csv("Data/kelp_bass_gonad_mass.csv")

# Make a histogram of all raw observations (untransformed values) in the kelp bass gonad mass data set
hist(data1$gonad_mass) # note: 8 bins

ggplot(data=data1,aes(x=gonad_mass))+
  geom_histogram(bins=20, color="black")+
  labs(y="Frequency",x="Gonad Mass")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ggsave("Output/PS2_4.png")
# don't need to label the x axis, can just put frequency on the y axis
# don't need a title, instead give a figure legend


###############
# Question 5
###############

# Convert all raw observations in the kelp bass data set into Z-scores
zscoreMass<-scale(data1$gonad_mass, center=TRUE, scale=TRUE) 
# Center function centers the data on the mean (subtracts mean); Scale divides by s.d.
hist(zscoreMass) # note: 12 bins

# add zscores to dataframe
zdata<-data1%>%
  mutate(zscore=zscoreMass)
# plot data
ggplot(data=zdata, aes(x=zscore))+
  geom_histogram(bins=20, color="black")+
  labs(y="Frequency",x="")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ggsave("Output/PS2_5.png")


###############
# Question 6
###############
data1<-read_csv("Data/kelp_bass_gonad_mass.csv")

# Use the original kelp bass gonad data to create a Normal Probability Plot
#to get probability plot
qqnorm(data1$gonad_mass)
qqline(data1$gonad_mass)

#To make a probability plot with confidence intervals
#library(car)
#library(MASS)

# gives a 'buffer of concern' to show how far off the line our data can be to still be considered normal
# can do for multiple distributions. in this case "norm" = normal distribution
qqp(data1$gonad_mass, "norm") 


###############
# Question 7
###############

data7<-read_csv("Data/Agaricia.csv")
View(data7)

# is the data normally distributed?
# normality probability line option:
qqnorm(data7$weight)
qqline(data7$weight)
qqp(data7$weight, "norm") 

# histogram normality option:
hist(data7$weight)
#or
ggplot(data=data7,aes(x=weight))+
  geom_histogram(bins=6, color="black")+
  labs(y="Frequency",x="Gonad Mass")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ggsave("Output/PS2_7.png")

# does log transformation improve normality
logdata<-data7%>%
  mutate(logweight=log(weight))
# normality probability line option:
qqnorm(logdata$logweight)
qqline(logdata$logweight)
qqp(logdata$logweight, "norm") 
# histogram normality option:
hist(logdata$logweight)
#or
ggplot(data=logdata,aes(x=logweight))+
  geom_histogram(bins=6, color="black")+
  labs(y="Frequency",x="Gonad Mass")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  ggsave("Output/PS2_7b.png")


###############
# Question 8
###############

# Estimate the mean ± 95% CI of the untransformed data sample by resampling the data with bootstrapping (just use 1000 resamplings)

data8<-read_csv("Data/Agaricia.csv")
View(data8)

#resample the mean of our sample population over and over,
#leaving one data point out each time
bootmeans<-replicate(1000, { #this tells R I want it to do the same thing 1000 times; open brackets start a function  
  samples<-sample(data8$weight,replace=TRUE); #this will take a subsample of our original data, with replacement every subsample
  mean(samples)  }) #take the mean of the subsample

#Now you have 1000 different estimates of the mean, based on your 1000 random samples
bootmeans

#We can just take the mean of our bootstrapped means to get
mean(bootmeans) #the more bootstrapped samples we use, the closer to the population mean we should get

#You could calculate the confidence interval just as we have before.
#With bootstraps, it's nice because if we sort our samples in order, then exactly one of your values represents the upper and lower 95% confidence limit
#To sort your bootstrapped means:
sortedboots<-sort(bootmeans)

#Now our 1000 means are sorted in order. If we'd done 1000 bootstraps, then the 25th value would be the lower CL and the 975th sample would be the upper CL
lowCI<-sortedboots[25]
highCI<-sortedboots[975]
lowCI
highCI

hist(sortedboots,
     main="",
     xlab="Bootstrapped Mean Weights of Agaricia agaricites (g)",
     ylab="Frequency Distribution of Estimates",
     ylim=c(0,200))
#To add vertical lines for the two confidence limits
abline(v=lowCI, col="blue")
abline(v=highCI, col="blue")


###############
# Question 9
###############

data9<-read_csv("Data/BarnacleRecruitment.csv")

#test homogeneity of variance
bartlett.test(recruitment~Site, data=data9) #If P>0.05, then variances are equal
#test normality
shapiro.test(data9$recruitment) #If P>0.05, then the data is normal

# separate into two dataframes based on Site
data9_bay<-data9%>%
  filter(Site=="bay")
data9_ocean<-data9%>%
  filter(Site=="openocean")

# assess bay normality and homoscedasticity with raw data
var(data9_bay$recruitment, na.rm=TRUE) # variance = 49.65
length(data9_bay$recruitment) # n = 30
skewness(data9_bay$recruitment) # 2.451
kurtosis(data9_bay$recruitment) # 9.586
qqp(data9_bay$recruitment, "norm") # non-normal
hist(data9_bay$recruitment)
# assess open ocean normality and homoscedasticity
var(data9_ocean$recruitment, na.rm=TRUE) # variance = 35.90
length(data9_ocean$recruitment) # n = 30
skewness(data9_ocean$recruitment) # -0.107
kurtosis(data9_ocean$recruitment) # 2.135
qqp(data9_ocean$recruitment, "norm") # appears normal
hist(data9_ocean$recruitment)

################ log-transformation
data9<-read_csv("Data/BarnacleRecruitment.csv")
data9.log<-data9%>%
  mutate(log=log(recruitment+0.5))

#test homogeneity of variance
bartlett.test(log~Site, data=data9.log)
#test normality
shapiro.test(data9.log$log)

data9_bay<-data9%>%
  filter(Site=="bay")
data9_ocean<-data9%>%
  filter(Site=="openocean")

hist(data9_bay$log) 
hist(data9_ocean$log) 

################ square-root transformation
data9.sqrt<-data9%>%
  mutate(sqrt=sqrt(recruitment+0.5))

#test normality and homogeneity of variance
bartlett.test(sqrt~Site, data=data9.sqrt)
#test normality
shapiro.test(data9.sqrt$sqrt)

data9_bay<-data9.sqrt%>%
  filter(Site=="bay")
data9_ocean<-data9.sqrt%>%
  filter(Site=="openocean")

hist(data9_bay$sqrt) 
hist(data9_ocean$sqrt) 


################ arcsine transformation
data9.arc<-data9%>%
  mutate(arcsin=asin(sqrt(recruitment+0.5)))

#test normality and homogeneity of variance
bartlett.test(arcsin~Site, data=data9.arc)
#test normality
shapiro.test(data9.arc$arcsin)

# NA's produced
data9_bay<-data9%>%
  filter(Site=="bay")
data9_ocean<-data9%>%
  filter(Site=="openocean")

hist(data9_bay$arcsin) 
hist(data9_ocean$arcsin) 

# homogeneity of variance: 2x different from each other, probably okay, 3x different from each other, probably a little high

# Make a bar graph of mean # of barnacle recruits in the two habitats.  Include error bars that show SEM. 
# mean recruitment and SE
data9_sum<-data9%>%
  dplyr::select(Site,recruitment)%>%
  group_by(Site)%>%
  summarise(mean=mean(recruitment,na.rm=TRUE), se=sd(recruitment,na.rm=TRUE)/sqrt(length(recruitment)))

ggplot(data9_sum, aes(x=Site,y=mean,group=Site))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        plot.title = element_text(hjust = 0.5))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_errorbar(aes(ymax=mean+se, ymin=mean-se), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  labs(x="Sample Site", y="Barnacle Recruitment (new recruits 4cm-2)")+ #labels the x and y axes
  ggsave("Output/PS2_9.png")

############### t-test using the log transformed data
# calculating 'by hand' (sans functions)

# Show the formula you used to calculate t, 
# give the means and SD, show the pooled variance, 
# and give the t value. 
# Interpret the statistical meaning (is P < or < 0.05?) 

data9<-read_csv("Data/BarnacleRecruitment.csv")
data9<-data9%>%
  mutate(sqrt=sqrt(recruitment))

data9_bay<-data9%>%
  filter(Site=="bay")
data9_ocean<-data9%>%
  filter(Site=="openocean")

View(data9)

#two-sample t-test
y1<-mean(data9_bay$sqrt)
y2<-mean(data9_ocean$sqrt)

n1<-length(data9_bay$sqrt)
n2<-length(data9_ocean$sqrt)

var1<-(sum((data9_bay$sqrt-y1)^2))/(n1-1) # s^2 = variance = standard deviation squared
var2<-(sum((data9_ocean$sqrt-y2)^2))/(n2-1)

#SD
sqrt(var1)
sqrt(var2)

#calculate t
t<-(y1-y2)/(sqrt(((((n1-1)*var1)+((n2-1)*var2))/((n1+n2-2)))*((1/n1)+(1/n2))))
t

#compare
myt9<-t.test(data9$sqrt~data9$Site)
myt9

#pooled variance
var.all<-(((((n1-1)*var1)+((n2-1)*var2))/(n1+n2-2))) # using part of the denominator of our t-value calculation
var.all


###############
# Question 10
###############

data10<-read_csv("Data/ProblemSet2_10.csv")
data10.sum<-data10%>%
  group_by(Site)%>%
  summarise(mean=mean(Density),SD=sd(Density))
data10.sum

#test homogeneity of variance
bartlett.test(Density~Site, data=data10) #If P>0.05, then variances are equal
#test normality
shapiro.test(data10$Density) #If P>0.05, then the data is normal


###############
# Question 11
###############

myt11.pooled.var<-t.test(data10$Density~data10$Site, var.equal=TRUE) # student's t uses pooled variance
myt11.separate.var<-t.test(data10$Density~data10$Site) # welch's t uses separate variance

myt11.pooled.var
myt11.separate.var

var.11<-data10%>%
  group_by(Site)%>%
  summarise(var(Density))
var.11


###############
# Question 12
###############

# graph the data
# Show means and standard error of the mean (SEM)

data10<-read_csv("Data/ProblemSet2_10.csv")
data10.se<-data10%>%
  group_by(Site)%>%
  summarise(mean=mean(Density),SE=sd(Density)/sqrt(length(Density)))
data10.se

ggplot(data10.se, aes(x=Site, y=mean)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        plot.title = element_text(hjust = 0.5))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_errorbar(aes(ymax=mean+SE, ymin=mean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  labs(x="Sample Substrate Type", y="Urchin Densities (# per m-2)") + #labels the x and y axes
  scale_fill_manual(values=c("Bottom"="blue","Top"="blue"))+ #fill colors for the bars
  ggsave("Output/PS2_11.png")




###############
# Question 13
###############

data13<-read_csv("Data/CoastBuckwheat.csv")

#test normality
shapiro.test(data13$Density) #If P>0.05, then the data is normal

myt13<-t.test(data13$Density,mu=4)
myt13

data13.sum<-data13%>%
  summarise(label="",mean=mean(Density),se=sd(Density)/sqrt(length(Density)),highCI=mean+1.96*se, lowCI=mean-1.96*se)
data13.sum

mu<-4

ggplot(data13.sum, aes(x=label, y=mean))+
  geom_bar(stat="identity", position="dodge", size=0.6) + #determines the bar width
  geom_hline(yintercept=4, color="black")+
  geom_errorbar(aes(ymax=highCI, ymin=lowCI), stat="identity", position=position_dodge(width=0.9), width=0.1) + #adds error bars
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        plot.title = element_text(hjust = 0.5))+
  labs(x="Coast Buckwheat", y="Mean Density (# buckwheat per 25m-2)")+ #labels the x and y axes
  ggsave("Output/PS2_13.png")



######################
# p + geom_hline(yintercept=4, color="black") # for ggplot
# baseR: abline(h=4, lty=2)



###############
# Question 14
###############

data14<-read_csv("Data/RunTimes.csv")
View(data14)

myt14<-t.test(data14$Water, data14$Sportsdrink, paired=TRUE)
myt14

data14.long<-data14%>%
  pivot_longer(cols=c(Water,Sportsdrink), names_to="group", values_to="values")
data14.long

#test homogeneity of variance
bartlett.test(values~group, data=data14.long) #If P>0.05, then variances are equal
#test normality
shapiro.test(data14.long$values) #If P>0.05, then the data is normal

data14.long%>%
  group_by(group)%>%
  summarise(mean(values), se=sd(values)/sqrt(length(values)))
