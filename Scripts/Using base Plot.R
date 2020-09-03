#Plotting with base plot
#This is not better or worse than ggplot. It's just different.
#Most people like one version over the other, but you can use whichever you like
#GGplot works by making a simple graph and then adding layers one by one on top of that 
#to modify the graph in some way

#Base plot works by telling R everything you want in the graph and then making it in one step.
#(Except you often add the error bars in another step)


#Clear the Environment
rm(list=ls())

#We're going to use a data set called GrowthRates2017
#This data set has growth rates of two species of algae (Turbinaria and Sargassum)
#Those species were exposed to two CO2 concentrations (elevated and ambient).

#Load the data
Gdata<-read.csv('data/GrowthRates2017.csv')
View(Gdata)

#Explore the data
hist(Gdata$growth.rate)

#Hmm, two data points lost weight (negative values). Let's remove those.
#Here's another way to do that
outlier<-which(Gdata$growth.rate<0)
outlier
Gdata<-Gdata[-outlier] #removes those two data points


#Now let's make a plot. We can set this up using tidyr
library(tidyr)
library(dplyr)
Gdata.summary<-Gdata %>%
  group_by(Species, pCO2) %>% #tells to group by these two factors
  summarise(GRate.mean=mean(growth.rate), GRate.se=sd(growth.rate)/sqrt(n())) #calculates mean and s.e.
Gdata.summary

#If we were using ggplot, we would make our graph with Gdata.summary
#But base plot wants the data in a slightly different format.
#There's certainly a way to do this directly, but I haven't thought that 
#through, so I'm doing it the long way

G.means<- tapply(Gdata.summary$GRate.mean, # we are reformatting the mean data
                 list(Gdata.summary$pCO2,Gdata.summary$Species),  # we are splitting by species and pco2
                 function(x) c(x = x)) # we are leaving the data alone (x = x)
G.means  
#see that the data is in a different format now. This is the format we'd normally
#use to make a graph in Excel

#Do the same thing for s.e.
G.se<- tapply(Gdata.summary$GRate.se, # we are reformatting the se data
              list(Gdata.summary$pCO2,Gdata.summary$Species),  # we are splitting by species and pco2
              function(x) c(x = x)) # we are leaving the data alone (x = x)
G.se


#A nice barplot
barplot(height = G.means, # create a plot of the means
                      beside = TRUE, # put the species next to each other
                      ylim = c(0,max(Gdata$growth.rate)), # make the y limits go from 0 to the max growth rate
                      ylab = "Growth Rate", # add a y label
                      xlab = "Species", #add an xlabel
                      border = "black", # make the borders of the bars black
                      col = c('lightblue','lightpink'), # change the bar colors
                      legend.text = TRUE) # add a legend

#Add the errorbars. Error bars are modified arrows, where we make the carrot of the arrow flat and we go from the mean  - SE to the mean + SE.

arrows(barCenters, # put the arrow in the center of the bars (x1)
       G.means - G.se, # go from mean - SE
       barCenters, #(x2)
       G.means + G.se, # go to mean + SE 
       lwd = 1.5, # increase the line width by 50%
       angle = 90, # make the angle of the arrow 90 degrees
       code = 3, # this is the type of arrow. There are a bunch 
       length = 0.05) # make the length of the hat 0.05
abline(h=0, lwd=2) # add a solid horizontal line at 0


#Now, one other thing. If you wanted to export this plot as a pdf file:
#Instead of always having to click on export for our graph, we can write some code that 
#tells R to export our graph as a pdf (or other formats, if you prefer)
pdf(file = 'Output/GrowthRate.pdf', width = 6, height = 6) # open the pdf device, name it GrowthRate.pdf and put it in the output folder. Then make the width and height both 6 inches
#The pdf will not export until you finish making the graph and tell it you're done at the bottom
  
#Now go up and re-run all of the code for making a graph

#Finally:
dev.off()
#Now look in your output folder and you should see the file there.


