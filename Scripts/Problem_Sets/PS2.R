# Problem Set 2

library(tidyverse)
library(moments) # for skewness and kurtosis
# Question 1
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


# Question 2
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



# Questions 3
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



# Question 4
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



# Question 5
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



# Question 6
# Use the original kelp bass gonad data to create a Normal Probability Plot
#to get probability plot
qqnorm(data1$gonad_mass)
qqline(data1$gonad_mass)

#To make a probability plot with confidence intervals
library(car)
library(MASS)

# gives a 'buffer of concern' to show how far off the line our data can be to still be considered normal
# can do for multiple distributions. in this case "norm" = normal distribution
qqp(data1$gonad_mass, "norm") 



# Wuestion 7
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
