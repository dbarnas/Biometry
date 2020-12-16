# Barnas Final Practical

library(tidyverse)
#########################
# Question 4
#########################

rm(list=ls())

mydata<-read_csv("Data/Final/TreeFrog.csv")
View(mydata)
# snout-vent length (SVL)

# transformation
mydata<-mydata%>%
  mutate(logweight=log(weight))%>%
  mutate(sweight=sqrt(weight))

model<-lm(sweight~SVL, mydata)

#normality
qqp(residuals(model),"norm")
plot(model)
# good enough with square root transformation

summary(model)

# report that F=1920, df = 1, 98, p-value < 2.2e-16, r-squared = 0.9517
# R^2 value when you multiply by 100 tells you the percent that x explains the y variable


library(ggpubr)
plot<-ggplot(data=mydata,aes(x=SVL,y=sweight))+#,fill=file.ID))+ # basic plot
  geom_point()+ # adds data points to plot
  geom_smooth(method="lm")+ # linear regression
  labs(y='Square Root of Weight',x='Snout-vent Length')+ # axis labels
  theme_bw()+ # white background
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
  stat_regline_equation(mapping = aes(label=paste(..eq.label.., ..rr.label.., sep = "~~~~")), formula = y~x,
                        label.x.npc = "left", label.y.npc = "top", label.x = NULL,
                        label.y = NULL, output.type = "expression") +
  ggsave("Output/Final/Final_4.png")
plot




