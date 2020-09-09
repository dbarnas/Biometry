# Problem Set 2

library(tidyverse)

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
library(moments)
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

