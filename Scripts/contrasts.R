#How to do a priori contrasts, or planned comparisons

#We'll use a dataset called "drugtest"
#It shows the results of a drug test with four treatments to see if the drug affects
#immune system function.
#Patients were either given nothing (control), a placebo, a low dose of the drug, or a high 
#dose of the drug. Then the number of white blood cells (WBC) per unit of blood was measured.

#Before they even begin the analysis, researchers decide they want to test two specific hypotheses:
#(1) Does the drug have an effect? (Compare (control + placebo) vs (high + low dose)
#(2) Does the dosage of the drug matter? (Compare high to low dose)


#Clear the environment
rm(list=ls())

#Import the data. 
mydata <- read.csv("Data/drugtest.csv")
# treatment in one column and white blood cell count in the second column
View(mydata)

#It looks like Treatment imported as a character, which is fine is we were just doing
#an ANOVA, but for contrasts, we need to make sure it's a factor. So let's convert
#that column into a factor
mydata$Treatment<-as.factor(mydata$Treatment)

# contrasts only work on factors, they don't work on characters

#First, let's create a model and test our assumptions
model1<-aov(WBC~Treatment, data=mydata)
plot(model1)

# used aov() here but kind of the only time Casey uses aov(). didn't work when he used lm().
# syntax is the same

#Assumptions look ok

#Let's just peek at the results of that model
summary(model1)

#Ok, so no difference between treatments. But this doesn't exactly test the two hypotheses
#we're interested in. Contrasts can give us more powerful tests of the hypothesis we're interested in.

#Second, let's create two vectors of coefficients for our two contrasts
#Note that R lists the treatment levels alphabetically. So in order, they are:
#1-Control
#2-High Dose
#3-Low Dose 
#4-Placebo
#So they're NOT in the same order as in your spreadsheet
#If you want to know the order of the levels in R:
levels(mydata$Treatment)

#Our coefficients for comparing (Control and Placebo) vs. (High and Low Dose)
c1<-c(1,-1,-1,1)

#And our coefficients for comparing High Dose to Low Dose
c2<-c(0,1,-1,0)
 
#You MUST make sure that these are orthogonal. Each row must add to zero.
#And if you multiply all the numbers in a column, the products must sum to zero also


#And now let's combine these two vectors together into a matrix.
#cbind is a command that combines two vectors into one matrix
contrastmatrix<-cbind(c1,c2)

#And now we're going to attach this contrast matrix to the dataset
contrasts(mydata$Treatment)<- contrastmatrix
#some weird behind the scenes R magic happens becuase nothign shows up in the data here... but R knows you're doing a contrast

#Now run the two contrasts like this:
summary(model1, split=list(Treatment=list("Effect of Drug"=1, "Effect of Dosage"=2)))

# 1 means the first contrast you programmed and 2 means the second contrast you programmed
# effect of treatment was not significant
# but the effect of the drug was significant
# the effect of the dosage was also not significant

#The summary command includes the option: split. The split option provides a list of factors where 
#contrasts are stored. Within each factor, we also provide a list which includes the names of the contrasts 
#(i.e. each column) stored in the contrasts matrix columns (i.e. contrastmatrix).

#If we'd wanted to do Tukey post-hoc tests instead
model2<-aov(WBC~Treatment, data=mydata)
TukeyHSD(model2)
#or
library(agricolae)
HSD.test(model1, "Treatment", console=TRUE)

# if we only used tukey, we wouldn't see a difference
# all treatments have the letter a, meaning no significant difference between them

