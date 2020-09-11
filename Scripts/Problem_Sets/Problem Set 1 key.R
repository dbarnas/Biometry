###This is the little bit of R code needed to complete Problem Set 1
###Created on 8/30/20


#Clear the environment
rm(list=ls())

#Import the data, which I have put in a csv file named "microcosm"
microcosm <- read.csv("Data/microcosm.csv")
View(microcosm)

#Note that the way I set up this data was with one column called "Location" 
#with entries of either Top or Bottom, and one column called "Protozoa" with the
#counts for each replicate in a new row

library(tidyr)
library(dplyr)
SummaryByGroup <- microcosm %>%
  group_by(Location) %>%
  summarize(meanProto=mean(Protozoa), sdProto=sd(Protozoa), varProto=var(Protozoa))
SummaryByGroup

#You can use various packages to get confidence intervals, but they all use the t-distribution,
#which we haven't talked about yet. For now, let's just do this by hand:
#We know that 95%CI = 1.96*sd/sqrt(n)

topCI<-1.96*SummaryByGroup[2,3]/sqrt(10) #I'm calling the SummaryByGroup object created above
#and then asking for the second row and third column from that dataframe
topCI
bottomCI<-1.96*SummaryByGroup[1,3]/sqrt(10) #calling the first row and third column from that dataframe
bottomCI

#Ok, let's make a graph
#First we need to make a new dataframe with the info we need to make the graph (means and se)
data_summary <- function(data, varname, groupname){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      se = sd(x[[col]]/sqrt(length(x[[col]])), na.rm=TRUE))
  }
  data_sum<-ddply(data, groupname, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

graphdata<-data_summary(microcosm, varname="Protozoa", groupname="Location")
graphdata

#What I've done above is written a short function that can be used to collate the means
#and se's for each Location type. Then I tell R to apply that function to my data.
#Almost certainly, most of you used the way I collated data in the Intro to R script, which is 
#TOTALLY fine. I just wanted to show you one other way to do this.

#Had I used the Intro to R method, I would have used this code:
library(tidyr)
library(dplyr)
graphdata2 <- microcosm %>%
  group_by(Location) %>%
  summarize(meanProtozoa=mean(Protozoa, na.rm=TRUE), se=sd(Protozoa, na.rm=TRUE)/sqrt(length(na.omit(Protozoa))))
graphdata2
#Note, this second method only seemed to work for me if I did NOT run the first method first
#This might be just my computer, but FYI

library(ggplot2)

p<-ggplot(graphdata2, aes(x=Location, y=meanProtozoa))
p<-p+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
           panel.background = element_blank(), axis.line = element_line(colour = "black"))
p<-p + geom_bar(stat="identity", color="dodgerblue2", fill="dodgerblue2", position="dodge", size=0.6)
p<-p + labs(x="Location", y="Number of Protozoa")
p<-p + theme(axis.text=element_text(size=18), axis.title=element_text(size=18))
p<-p + geom_errorbar(aes(ymax=meanProtozoa+se, ymin=meanProtozoa-se), position=position_dodge(0.9), width=0.1)

print(p)
#You could have also done the above in one step, if you added a + sign at the end of each row
#and just got rid of the p<- p + at the beginning of each row


