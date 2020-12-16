# Barnas Final Practical

library(tidyverse)
#########################
# Question 2
#########################

rm(list=ls())

# "Data/Final/roadkill.csv"

# observed frequencies
rural<-c(42,70)
urban<-c(25,75)

observed <- matrix(c(rural, urban), nrow=2, ncol=2) #created a table of observed values

# expected frequencies
erural<-c(35.39622642,76.60377358)
eurban<-c(31.60377358,68.39622642)

exp <- matrix(c(erural, eurban), nrow=2, ncol=2)

#To calculate G:
Gvalue <- observed*log(observed/exp)
Gvalue <- 2*sum(observed*log(observed/exp))
Gvalue 

# df = (r-1)*(c-1)

#To get p-value
1-pchisq(Gvalue, df=1) #df = #categories-1


# alternative method
obs<-matrix(c(42, 70, 25, 75), nrow=2, ncol=2)

#To calculate G:
library(DescTools)
GTest(obs, correct="none")
