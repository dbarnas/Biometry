#Biometry Class 9-1-2020

###How to communicate your science?  
####Graphical exploration of data; Best ways to graph your data; Data Transformation; Data Presentation

**Before lecture**
- Download data and scripts
- Read any relevant posted literature/chapters

**Housekeeping**
- Canvas discussion is available
- one is for R and one is for general stats
- and "water cooler" for just fun interesting things
- Problem Set 1 due Thursday (typically due before class)
  - Assignments > Upload (as a pdf)
- Hurlbert 1984: pseudo-replication
  - read before lecture on Thursday

**Statistical values in R**
- is there a function to find mode? maybe in the psych package

**Confidence Interval vs SE**
- SE tells you confidence in your samples mean to the population mean
  - is a confidence interval (68% CI)
- CI tells you about your sample, not the population.  How confident you are that your data are within a proposed range
  - 95% of the time, your data will fall within this explanation
  - where 95% of our data in the sample is, but doesn't tell us anything about the population
  - tells us about variation in our data
  - not typically used for answering any scientific questions, but more of understanding our sample's variance
  - far less commonly used than standard error

**Graphical exploration of data**
- Main Uses
  - exploration: checking data for unusual values
  - analysis: is it a normal distribution? Are assumptions met?
  - effect sizes: are the results biologically relevant?
  - communicate results
  
**Histograms**
- Density Plot
- x axis: bins of data
- y axis: how many data points fall within that bin
- have to be careful
  - bin size makes a huge difference and can affect your interpretation of results
  - R often tries to give you the best representative bin size
  - excel may ask you for number of bins (bin size) so you have to do the work yourself to see what fits your data best

**Boxplots aka box and whisker plots**
- Middle line in the box: Median
- Top line of the box: 75% of the data (75th percentile)
- Bottom line of the box: 25% of the data (25th percentile)
- Whiskers show the spread of the data (variance)
- Dots show outliers past the whiskers
- IQR: interquartile range: the data distribution between the 25th and 75th percentile/lower and upper quartiles
- want a fairly narrow box, whiskers not too far out, and no outliers beyond that
- a quick way to show variance of groups

**Dotplot**
- shows every data point 
- stacked dots are all the data points with the same value
- can look at the spread of the data and data clusters

See Density Plots.R

**Outliers**
- formal tests
  - Cook's D: tells you "what was the influence of that one data point?"
    - what does the slope look like with and without that data point?
    - Values > 0.1 are considered outliers
    - Cook's distance: plot shows which row contains the outlier
- what to do with outliers
  - delete mistakes (keep good notes to reference back)
  - delete a priori suspected outliers (if you remember something weird happened when you got that data that would influence the accuracy of the data)
  - if anonymous:
    - re-run analysis w/o outlier to see the influence
    - use statistical techniques that are robust to outliers (rank tests (= nonparametric tests) are more so)
    - in general **don't just get rid of the outlier because it's an outlier. have justification to keep or throw out.** Don't introduce bias. Your default position should be to keep it in your dataset 

See outlier analysis.R

**Common data assumptions**
- Normality: can explore graphically
  - if we're using normality to predict if our data occurrd by chance
  - need our data to be normally distributed then
- homogeneity of variance: can explore graphically
  - if variance in group a is the same/close to the variance in group b
- linearity: variables are linearly related; simplest check is scatterplot of 2 variables
  - plot the data to see if it could be linear, or if it's parabolic or exponential etc.
  - if nonlinear, need to use a different test that doesn't assume linearity
- independence: all observations within and between groups do not influence one another; each data point would be independent of the others, not influencing others

**Departures from normality**
- skewness (asymmetry - one tail drawn out further)
  - negative skew = left skewed (the tail goes out to the left - the data far to the left are pulling the mean more ot the left)
  - positive skew = right skewed (the tail goes out to the right - the data far to the right are pulling the mean more to the right)
  - average of cubed deviations from the mean divided by the cube of the standard deviation (similar to variance but cube your data)
  - skewness between -1 and 1 is considered normal
- kurtosis
  - biased toward or away from the middle
  - leptokurtic: more data in the middle than even you'd expect for normal (high curve)
  - platykurtic: more data in the tails than you'd expect for normal (low curve)
  - kurtosis < 3 is considered normal

See Normality.R

**Normal probability plots (also called Q-Q plots)**
- data vs expectation if data were normally distributed
- if your data all fall on the line, they are matching what you'd expect if your data were normal

**Homogeneity of variance (homoscedasticity = equal variances)**
- how unequal is too much?
- bigger problem if sample sizes are unequal

There are formal tests for normality and homoscedasticity
- but sometimes if your sample size is large, the tests are too powerful (won't detecting tiny deviations)
- and if your sample size is too small, the tests may be too weak and won't detect variations that would invalidate

**Non-Normal data**
- Transformations: 
  - we can make our data normal
  - can create homogeneity of variances
  - can reduce the influence of outliers
  - can improve linearity
  - may or may not be a good idea
  
Log
- good for right-skewed distributions
- may help to improve linearity
- used often with continuous variables

Square root
- take each data point and add 0.5, then take the square root of that number
- used for counts/discontinuous data

Arcsine (angular)
- take the square root of each value and then take the arcsine of that
- good for ratios/percentages

**note** cannot take the log or arcsine of 0. so may need to add a constant to that 0 (like add 1 or 0.1)

Transformation Pros and Cons
- Pros
  - make it easier to explain significance of data to an audience who may not know what the data even is
  - you can meet your assumptions better (making normal)
  - you're changing all the data in the same way; unbiased way of manipulating your data
  - changing the values but you're keeping the relationship between the values
- Cons
  - should be familiar with your raw data beforehand so you know how to appropriately handle your data
  - you end up taking away zeros, which can also be important data points in our data
  - need to recognize that and how we're changing the data. relationships are mostly staying the same, but the values are changing, so for showing any "raw" data, need to either do before transformation or back-transform
  - you also don't want to necessarily discount the natural distribution of your raw data because that's ecologically relevant as well

**Effect size**
- the difference in the peaks between two curves (two groups)
- easiest: meanA - meanB
- but we want a standardized measure of that difference
- Ways to calculate effect sizes
  - Cohen's d
    - difference of the means standardized by the variance of those groups
    - pretty common
  - Hedge's g
    - corrects for low sample size compared to Cohen's d
    - calculated Cohen's d first 
  - Log Response Ratio
    - used commonly in ecology
- important to know if our data is biologically relevant
  - small effect size: less relevant
  - ex. exam score: students drank water before a test and scored 78% while students who drank red bull before a test scored 78.3%. small effect size. not a real difference, both groups got a C+
- biggest reason to use is to communicate results

**summary graphs**
- to communicate infomation quickly
- should be simple and interpretable
- what information are you trying to actually convey
- if you have to say "i know you can't really see this but" then try a new approach/new graph
- visually represent the data
- show relationships and exact values are less important (if you're giving a talk for lay public)
- information cannot be presented twice (eg table and figure or text and figure)
- bar graphs vs boxplots
  - think of your audience
  - make sure you can actually compare your datasets
- think about your axes and scales
- avoid unneccessary clutter (eg gridlines)















