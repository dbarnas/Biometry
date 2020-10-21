---
title: "Midterm 2"
output: html_document
---

## Biometry Midterm 2

**Contents:**
- [Fixed and Random Factors](#factors)
- [One-Way ANOVA](#onewayanova)
- [F Ratio Statistic](#fratio)
- [Correlation Tests](#correlation)
- [Outlier Test](#outliertest)
- [Regression](#regression)
- [Multiple Regression](#multipleregression)
- [Two-Way ANOVA](#twowayanova)
- [Running/Coding ANOVA](#runningANOVA)


Lecture Portion of Exam:
- Will cover multiple regression up through Lecture 15 (power analyses)

R portion of Exam:
- Regression up through ANCOVA and Mixed Models (what was on PS5)



**General Linear Model**
- Regression
  - 1 continuous response variable
  - 1 continuous predictor variable
- ANOVA
  - 1 continuous response variable
  - # categorical predictor variable(s) = factor(s)
  - tests whether measn differ (like t-test but with more than 2 means)

<a name=factors></a>
**Fixed Factor**
- the factor of interest in our study
- testing the means to get a p value
- all levels or groups of interest are used in the study
- conclusions are restricted to those particular groups (cannot extrapolate)

**Random Factor**
- random sampling of all groups of interest are used in the study
- conclusions can be extrapolated to all possible groups
- do not get a p value
- don't care about testing the mean
- used for explaining variation
- used for avoiding pseudoreplication

<a name=onewayanova></a>
**One-Way ANOVA: partitioning variation**
- SS Total = SS Between Groups + SS Within Groups
- Explained variation is between groups (difference between group means and grand means)
- unexplained variation is within groups (difference between actual value and group mean)

**One-Way ANOVA table**
- Groups
  - SS = n * sum of ((group mean - grand  mean)^2)
  - df = p-1
  - MS = SS-groups / df-groups
- Residual
  - SS = sum of each group's sum of ((data point - group mean)^2)
  - df = p(n-1)
  - MS = SS-resid / df-resid
- Total
  - df = pn-1

**ANOVA assumptions**
- applied to residuals from linear model
- normality
- homogeneity of variances
- independence

**Other approaches**
- Tests that allow unequal variances
  - Welch's test, Wilcox Z Test
  - limited to simple experimental designs
- Rank-based "nonparametric tests"
  - Kruskal Wallis
    - limited to simple experimental designs (one-way 'ANOVA' style)
- Generalized Linear Modeling
  - if non-normal distribution is known (e.g. Poisson)
- Permutation Tests
  - PERMANOVA

<a name=fratio></a>
**F Tests/F Statistic**
- F tests compare explained variation from our model / unexplained variation (residual/error)
- F statistic is used to get probability that our Explained = Unexplained
- Null hypothesis: slope = 0
  - p < 0.05 indicates slope is significantly different from 0 and there is a relationship between X and Y
- MS = SS / df = variance
- F = MS1 / MS2
- % variation explained by elements of model = element's variance / total variance * 100
- Residuals
  - difference between observed value and predicted value

<a name=correlation></a>
**Correlation Tests**
- Pearson's R: for linear relationships; calculated on ranks
  - requires normality
  
```{r}
mytest1<-cor.test(mydata$cryduration, mydata$IQ, method="pearson")
mytest1

library(car)
qqp(mydata$cryduration, "norm")
qqp(mydata$IQ, "norm")
```

- Spearman's rho: nonlinear relationships (non-parametric correlation coefficients); calculated on ranks
  - if data are not normal, could either do a Spearman's rho or could transform data for normality and do Pearson's
```{r}
mytest2<-cor.test(mydata$cryduration, mydata$IQ, method="spearman")
mytest2
```

- Kentall's tau: nonlinear relationships (non-parametric correlation coefficients); concordant and discordant pairs

```{r}
mytest3<-cor.test(mydata$cryduration, mydata$IQ, method="kendall")
mytest3
```

<a name=outliertest></a>
**Outlier Test**
- Bonferroni test
  - only works after you've already fit a model to your data
  - Tells you whether most extreme value has undue influence
  - If P<0.05, then point is a potential outlier
  
```{r}
library(car)
model1<-lm(Bush~Buchanan, data=mydata)
outlierTest(model1)
```

<a name=regression></a>
**Regression** (Lecture 7)
- one or more predictor (independent) variable(s), X
- one response (dependent) variable, Y
- Purposes:
  - Description: relationship between Y and X
  - Explaination: How much variatino in Y is explained by linear relationship with X
  - Prediction: predict new Y-values from new X-values & determine precision of those estimates
- Assumptions: 
  - normality and homogeneity of variance for response variable
  - independence of observations
  - linearity between X and Y
  - no collinearity (for a multiple regression)
- F ratio
  - Regression: variation in Y explained by regression
    - df = 1
    - MS = SS / 1
  - Residual: variation in Y not explained by regression
    - df = n-2
    - MS = SS / n-2
  - r2 coefficient of determination
    - measures explained variation; proportion of variation in Y explained by linear relationship with X
    - r2 = square of correlation coefficient, r
    - SS total = SS-reg + SS-resid
    - r2 = SS-reg / SS-total
- Before we can fit a regression line, we need to describe the model
  - is the data linear?
```{r}
plot(NumberSpp~Biomass, data=data4, col="blue", xlab="Biomass (mg/m2)", ylab="Species Richness")
abline(model4, col="blue") #adds fit from the model

# diagnostic plots
plot(model)

# check normality of residuals
library(car)
qqp(residuals(model))

# homogeneity of variance using box plot
boxplot(residuals(model)~mydata$Nitrogen)

#Check for outliers using Bonferonni Test:
outlierTest(model)

#Check for high leverage points
# With the leverage plot, you want values Cook's distance less than 1:
plot(model,4)
# or
influencePlot(model) #Points greater than 1 are potential outliers

# Finally, to test whether this model is significant
# F test: Get R2 value, F, df, and p for goodness of fit of the model
# Estimate = slope
# gives t value and p value for each predictor variable
summary(model)
```

<a name=multipleregression></a>
**Multiple Regression**

```{r}
#First we want to know which model fits the data best. Here's the full model:
fullmodel<-lm(krat_density~shrubcover+seedproduction+snakedensity, data=mydata)

#To check for collinearity in your data:
library(GGally)
X<-mydata[,c(2,3,4)] #gives you just columns 2,3,4
ggpairs(X)

#To get actual numbers on collinearity better test:
library(mctest)
imcdiag(fullmodel)
# Collinearity problem

#Get the AIC value for this model
AIC(fullmodel)

#Now let's make every other possible model:
reduced1<-lm(krat_density~shrubcover+seedproduction, data=mydata) #We might be cautious with this model because these variables are co-linear
reduced2<-lm(krat_density~shrubcover+snakedensity, data=mydata)
reduced3<-lm(krat_density~seedproduction+snakedensity, data=mydata)

#We also have the simple models (single regressions). Let's get the AIC value for each model:
AIC(fullmodel)
AIC(reduced1)
#etc.

#we want to choose simpler models (that doesn't have collinearity problems) (And reduced2 is slightly better fit too)
summary(reduced2)

# Traditional ANOVA table, if you like that output better
# Gives F tests instead of t and gives df
anova(reduced2)

#check for homogeneity of variances of the model
plot(reduced2)
#And check normality
library(car)
qqp(residuals(reduced2))

#To get the partial standardized regression coefficients for each factor
library(QuantPsyc)
lm.beta(reduced2)
# sign doesn't matter. just value from 0 to 1 for effect size/importance of predictor variable
```

**Checks for collinearity**

```{r}

```

**Model I and Model II Regression**
- Model I
  - measured without error. you chose specific values of X (i.e. fixed)
- Model II
  - There is error in the measure of x and y
  - both x and y are random variables, measured with error
  - in biology, often do Model II designs but use Model I regression
    - fine for hypothesis tests (p values) but not for accurate estimates of slope and intercept
  - can use Reduced Major Axis regression (Model II)
    - handles error in both x and y
    - lmodel2::RMA
```{r}
#model II regression.
library(lmodel2)
model1<-lmodel2(area~height, range.y="relative", range.x="relative", data=mydata, nperm=99)
model1 #Use these parameters (from RMA) to get estimates of slope and intercept
```

**Model Selection**
- AIC (Akaike's Information Criterion)
  - takes the natural log of L (our likelihood) times 2, subtracted from double the number of parameters
  - AIC = 2k - 2ln(L)
    - k = number of parameters
    - lower values are better fits of the model
    - can compare a model of 2 parameters to a model of 10 parameters and see if our model is stronger. AIC takes into account (penalizes  you for) more parameters in your model



```{r}

```

<a name=runningANOVA></a>
**Running an ANOVA**
1. Make sure predictors are factor type
```{r}
#Need to make Treatment a factor
mydata$Treatment<-as.factor(mydata$Treatment)
```
1. Check if data is balanced
```{r}
summary(mydata)
```
1. Create model
```{r}
model<-aov(seed.mass~Treatment, data=mydata)
# or
model<-lm(seed.mass~Treatment, data=mydata)
# or 
library(lme4)
library(lmerTest)
model<-lmer(seed.mass~Treatment + (1|random), data=mydata) # for random factors in two or more way anova's

# Nested ANOVA
model2<-lmer(Calyxarea~(Genotype) + (1|Ramet:Genotype), data=mydata)

# Two-Way Fixed Factor ANOVA
model1<-lm(growth~Temperature + CO2 + Temperature:CO2, data=mydata)
#A shortcut to writing the same thing:
model1<-lm(growth~Temperature*CO2, data=mydata)

# Repeated Measures ANOVA (for time as a fixed factor)
model<-lmer(FvFm ~ temperature*day + (1|temperature:coral), data=data4) 

# ANCOVA
# categorical and continuous predictor variables
model1<-lm(Weight ~ TidalHeight * Length, data=mydata)
#Remember that you also want to make sure that the relationship with covariate is linear
plot(Weight~Length, data=mydata)
#You can stop right there if you want, but if you wanted to go further and do model selection
#Interaction term is highly non-significant, so you might want to do model selection and decide whether or not to drop it
#Let's look at AIC with and without
model2<-lm(Weight ~ TidalHeight + Length, data=mydata)
AIC(model1)
AIC(model2)
```
1. Check assumptions of data and transform if necessary
```{r}
plot(model) # first option to look for spread less than 3x for any group
plot(residuals(model5)) # another option, look for no pattern
library(car)

qqp(residuals(model), "norm") #When we're using lmer, we have to do the probability plot ourselves
```
1. Likelihood Ratio Test
```{r}
model5<-lmer(Calyxarea~Genotype + (1|Ramet:Genotype), data=data5) #the full model with the random effect
model5b<-lm(Calyxarea~Genotype, data=data5) # model without the random effect

anova(model5, model5b)
# this is the Likelihood Ratio Test. It gives AIC values for both models
# look for lowest AIC
# and it gives us a p-value for whether one is a better fit. We COULD technically use that p-value as a hypothesis test for the random effect


# ANCOVA
# If you wanted to go further and do model selection
#Interaction term is highly non-significant, so you might want to do model selection and decide whether or not to drop it
#Let's look at AIC with and without
model2<-lm(Weight ~ TidalHeight + Length, data=mydata)
AIC(model1)
AIC(model2)
```
1. Check results of ANOVA
```{r}
#To get results of ANOVA
anova(model2)
```
1. Get variance components
  1. Run all factors as random factors
  1. summary table: random effects: % variation explained by each is Variance / Total Variance (must sum yourself, not included in table)
  1. Residual = variation within replicates
  1. Group = variation between groups
  1. Nested factor = variation within groups
```{r}
#To get variance components, we need to model both variables as independent random variables
library(lme4)
model1<-lmer(Calyxarea~1 + (1|Genotype) + (1|Ramet:Genotype), data=mydata)

#Check assumptions
plot(model1) #homogeneity looks good
library(car)
qqp(residuals(model1), "norm") #normality looks good

#Get variance components
summary(model1)
```
1. Contrasts aka Planned Comparisons (a priori)
  - Create two vectors of coefficients for the two contrasts
  - Check the level order R has
  - coefficients must be orthogonal
    - each row sums to 0
    - sum of the products of each column (element i of c1 * element i of c2) = 0 
    - grouped levels must have same sign
    - compared levels must have opposite sign
    - levels we aren't testing are 0
```{r}
# We want to know what order R thinks out levels are in (alphabetical order)
levels(mydata$Treatment)

c1<-c(1,0,-1) #Control vs. Fence Control
c2<-c(0.5,-1,0.5) #(Control + Fence Control) vs. Exclusion

#You MUST make sure that these are orthogonal. Each row must add to zero.
#And if you multiply all the numbers in a column, the products must sum to zero also
(1*1/2) + (0*-1) + (-1*1/2) # = 0

#And now let's combine these two vectors together into a matrix:
contrastmatrix<-cbind(c1,c2)

#And now we're going to attach this contrast matrix to the dataset
contrasts(mydata$Treatment)<- contrastmatrix

#Now run the two contrasts like this:
summary(model1, split=list(Treatment=list("Effect of Fence"=1, "Effect of Rodents"=2)))
```
1. Bonferonni Adjust if cannot make coefficients orthogonal
  1. Bonferroni adjusted pairwise tests (e.g. t-tests)
  1. Not as powerful as Tukey HSD
  1. Do multiple t-tests for each pair using a conservative correction
    1. divide the desired level of Type I error by the number of comparisons
    1. New Critical P-value = alpha (0.05) / c (number of comparisons)
```{r}
c3<-c(0, -1, 1) #this is not orthogonal, so if I Bonferroni-adjust, it means I need p<0.025 to consider it significant

# Bonferonnie adjustment: new critical p value = 0.05 / 2 (only comparing 2 levels) = 0.025

contrastmatrix<-cbind(c3)

#And now we're going to attach this contrast matrix to the dataset
contrasts(mydata$Treatment)<- contrastmatrix

#Now run the two contrasts like this:
summary(model1, split=list(Treatment=list("Better Test of Rodents"=1)))

```
1. post-hoc Tukey Test
```{r}
#To do a post-hoc Tukey test
TukeyHSD(model2) # requires aov() instead of lm() for model function

#Could also use HSD.test (gives you letters for different groups which is convenient)
library(agricolae)
HSD.test(model2, "Nitrogen", console=TRUE)
```
1. Get estimated means (emmeans)
```{r}
#And let's create a bar plot of this data

# One-Way ANOVA
#I'm going to just get the estimated marginal means for the graph
library(emmeans)
graphdata<-as.data.frame(emmeans(model2, "Nitrogen"))
# or 
# here's another way to get Estimated Marginal Means for every level, while also doing a Tukey test
emmeans(model3log, pairwise ~ "Nitrogen", adjust="Tukey")
#I'm going to append a new column to graph data with the Tukey results in order
graphdata$tukey<-list("a","b","c","d")

# Nested ANOVA
# If we want to get the marginal means for Genotype, we need to make it a fixed effect first
model2<-lmer(Calyxarea~(Genotype) + (1|Ramet:Genotype), data=mydata)
graphdata<-as.data.frame(emmeans(model2, ~Genotype))
#keeping Ramet as a nested random effect will make sure the average of each ramet is used as a replicate

# Two-Way ANOVA
graphdata<-as.data.frame(emmeans(model1, ~Temperature*CO2))

# Repeated Measures ANOVA
graphdata<-as.data.frame(emmeans(model1, ~Temperature:day)) #ignoring the random factor
```
1. Plot emmeans with Tukey letters
```{r}
library(ggplot2)

# One-Way ANOVA
ggplot(data=graphdata, aes(x=Nitrogen, y=emmean, fill=Nitrogen)) +
  theme_bw()+
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", fill="DodgerBlue", width=0.5, stat="identity") + 
  guides(fill=FALSE) + 
  ylab("log Root:Shoot Ratio") +
  xlab("Soil Nitrogen") +
  scale_x_discrete(labels=c("Low" = "Low", "Ambient" = "Ambient", "1.5N" = "1.5 N", "2N" = "2 N")) + # new label = old label
  geom_errorbar(aes(ymax=emmean +SE, ymin=emmean - SE), stat="identity", position=position_dodge(width=0.9), width=0.1)+
  geom_text(aes(label=tukey), position = position_dodge(width=0.9), vjust = c(2,3.5,-2,-3.5))+ # add significance letters and adjust location on each bar
  # geom_text(aes(label=c("a","b","c","d"), position = position_dodge(width=0.9), vjust = c(2,3.5,-2,-3.5))+
  geom_hline(yintercept=0)

# Two-Way ANOVA
ggplot(data=graphdata, aes(x=Temperature, y=emmean, fill=factor(CO2), group=factor(CO2))) + 
  theme_bw() + 
  theme(axis.text.x=element_text(face="bold", color="black", size=16), axis.text.y=element_text(face="bold", color="black", size=13), axis.title.x = element_text(color="black", size=18, face="bold"), axis.title.y = element_text(color="black", size=18, face="bold"),panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_bar(colour="black", width=0.5, stat="identity", position="dodge", aes(fill=CO2)) + 
  labs(x="Temperature (*C)", y="Growth of Basal Area (mm2)", fill="CO2") + #labels the x and y axes
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.5), width=0.1)

```


**One-Factor ANOVA**


**Nested ANOVA**
- to get variance components, you must have everything as random factors
- don't use AIC to tell you whether your factors are random or fixed
- Ramets were random effects and nested within genotypes
- Variance of residuals: % of our model not explained by our model. Due to variation within measurements for each Ramet
- often the first thing people do when working with a nested effect is check the variance components (depends on what question you're trying to answer)
- by putting ramets in as a nested effect in the model, we're telling the model and fucntions to take the mean of the ramet values so we don't pseudoreplicate (emmeans)

```{r}
library(tidyverse)
library(car) # qqp() and Anova()
library(emmeans) # post-hoc test emmeans()
library(agricolae) # HSD.test()
library(lme4) # for testing random effects
library(lmerTest) #Need this to get anova results from lmer
library(MASS)




```

<a name=twowayanova></a>
**Two-Factor ANOVA**

- Two factors (2 categorical predictor variables)
  - Factor A (with p groups or levels)
  - Factor B (with q groups or levels)
- Crossed design (= orthogonal)
  - every level of one factor is crossed with every level of the second factor
  - if not every level is crossed with every other level, then do a nested anova
- Greater efficiency
  - can answer two questions with one experiment

**Two-way ANOVA table**
- degrees of freedom are the same as a one-way anova for each independent factor
  - df factor A = p-1 (# levels - 1)
  - df factor B = q-1 (# levels - 1)
- df for the interaction term is (p-1)*(q-1)
- df residual/error is pq*(n-1)
- interaction null hypothesis: no interaction between predictor factors
  - p < 0.05 shows significant interaction
- Look at test of interaction first, THEN determine whether to interpret main effects
  - no interaction if roughly parallel lines
  - different slopes means interaction
    - non intersecting: can still interpret main effects
    - intersecting: do not interpret main effects

```{r}
library(tidyverse)
library(car) # qqp() and Anova()
library(emmeans) # post-hoc test emmeans()
library(agricolae) # HSD.test()
library(lme4) # for testing random effects
library(lmerTest) #Need this to get anova results from lmer
library(MASS)

#Two Factor ANOVA: main effects of Location and Tidal Height
model1<-lm(Length~Location + TidalHeight, data=mydata)
plot(model1) # check assumptions
anova(model1)

#Two Factor ANOVA: main effects of Location and Tidal Height with their interaction
model2<-lm(Length~Location + TidalHeight + Location:TidalHeight, data=mydata)
#or a shortcut that includes both factors plus the interaction:
model2<-lm(Length~Location*TidalHeight, data=mydata)
plot(model2) # check assumptions
anova(model2)

#gather my summary data using emmeans
summarydata<-as.data.frame(emmeans(model2, ~ Location*TidalHeight))
summarydata

#graph
ggplot(graphdata, aes(x=Location, y=emmean, fill=factor(TidalHeight), group=factor(TidalHeight))) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  geom_bar(stat="identity", position="dodge", size=0.6) +
  geom_errorbar(aes(ymax=emmean+SE, ymin=emmean-SE), stat="identity", position=position_dodge(width=0.9), width=0.1) +
  labs(x="Location", y="Snail Length", fill="TidalHeight") +
  scale_fill_manual(values=c("Low"="tomato","High"="dodgerblue2")) #fill colors for the bars # fill factor identities


```



**Plots and Graphs**

- Scatterplot
```{r}
plot(cryduration~IQ, data=mydata)
```


- Plot with Confidence intervals
```{r}
library(ggplot2)
ggplot(mydata, aes(x=lnHeight, y=lnSA))+
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  geom_point(shape=1) + 
  guides(fill=FALSE) + 
  ylab("ln Surface Area") +
  xlab("ln Height") +
  geom_smooth(method="lm")
```





```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.