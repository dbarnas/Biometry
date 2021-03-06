#How to make histograms, boxplots, and density plots in R
#We'll use the Snail Data from the Intro to R module

#Clear the environment
rm(list=ls())


#Load the data
mydata <- read.csv("Data/SnailData.csv")

#To make a histogram
hist(mydata$Length)

#To make a boxplot
boxplot(mydata$Length)

#To make a dotplot
stripchart(mydata$Length, vertical=TRUE, method="stack", offset=0.5, at=.15, pch=19)

#or to make a boxplot that also shows all the points
boxplot(mydata$Length)
stripchart(mydata$Length, vertical = TRUE, method="stack", offset=0.5, add = TRUE, pch = 20, col = 'blue')

