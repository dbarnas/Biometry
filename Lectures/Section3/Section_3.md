# Biometry Class 10-27-2020

**Housekeeping**
- PS6 due Tuesday (3 questions)
- Paper:
  - in my field
  - 3-5 minutes
  - "here's what they were looking at", "here's the stats they used", "here's what they did well or maybe did differently from what i would have done"
  - 11/12 and 11/24
- Mid-semester check in
  - anonymous form (check email)

**Linear Models**
- General Linear Models: assume normality
  - could use OLS (ordinary least squares) or MS (maximum likelihood)
- Generalized Linear Models: can use other dsitribtions (don't assume normality); must use MS
  - looking for the parameter value that gives us the maximum possible likelihood (log(likelihood) on the y axis)

**Assumptions of a general linear model**
- normality (residuals/error)
- homogeneity of variance
- linearity
- independence of replicates

**Assumptions of a generalized linear model**
- linearity
- independence of replicates

**Generalized Linear Models**
- data may be right or left skewed
- binomial
- guassian (normal)
- gamma (often fits well for biological data)
- poisson (often works well)
- incorporates two functions into the linear equation
- Link function:
  - describes the relationship of the observations to the predictions
- Error distribution: 
  - describew how the variance depends on the mean

**Keep the chart handy for links to try fitting to our data**

**Generalized linear model in R**
- lme4::glm()
- glm assumes all factors are fixed
- glmer used for models with random effets/factors
- model<-glm(y~x, family="Gamma"(link="inverse"))
  - specify what family and put in the link
  - could leave link blank like link="" and R will put in the default
- test different functions to figure out which looks the best for you
- could use the model with the lowest AIC value, but this isn't always the best test. tells you if your distribution is better than normal, but not necessarily telling you if your model is better than another kind of distirbution
- must use "Anova" to get p-values
- same basic set up as anova's but using glm and glmer, and specify the distribution
  - can look at the best distribution in your qqp plot

**Transforming vs GLM**
- usually transform first and use lm() becuase takes less computing power and often get fewer errors in R using lm than glm, but technically could use glm for any model you would also make with lm


# Biometry Class 10-29-2020

# Midterm 2 Part B overview

Question 2
- every individual got every treatment, so Trial (or time) is just our replicate measure, so we don't need to add Trial to our model. We didn't care about the time effect. time was just our replicates.

**Logistic Regression**
- type of GLM
- analogous to linear regression
- Y: Categorical (usually binary) response variable (a 'yes' or 'no' / 0 or 1 kind of response)
  - non normal, so stuck with doing a generalized linear model
- X: continuous predictor variables
- logistic regression coefficient
  - slope
  - log-odds ratio of Y for a difference of 1 unit in X
  - odds ratio = strength of association between two events
- constant
  - intercept
- can put in categorical or continuous predictor variables

**Logistic Regression in R**
- don't need lmerTest
- need car
- if we put family = "binomial" and left link blank, it would default to "logit"
- Likelihood Ratio Test
  - can't get an R-squared with logistical regression
  - pR2(model) will give us pseudo-r-squared value(s)
    - three on the right gives three possible pseudo-r-squareds
    - McFadden's is the most commonly used value
    - the explained variance (from 0 to 1, where 1 is perfect fit)
    - pseudo-r-squared values tend to be a bit lower than a normal r-squard, so shift expectations. pseudo-r-squared values of 0.3 or 0.4 can actually show good fits



# Biometry Class 11-5-2020

### Paper Presentation  
November 17, slot 6  
3-5 minute informal presentation. Talk through it, no powerpoint

1. What is the question the paper is trying to answer?
2. What is the design of the experiment?
3. What stats did they use to answer this question?
4. Do you think their stats were right?


### Problem Set 7 due next Tuesday, 4 questions, all covered in today's lecture

**Analysing Frequencies**
- Chi-square and G-tests
- dependent variable is categorical
- if two categories, a binomially distributed variable
- if > 2 categories, a multinomially distributed variable

**Types of Frequency Analyses**
- Goodness of Fit tests
- Tests of Independence (Contingency Tables)
  - goodness of fit and tests of independence are set up similarly but interpreted differently
- Log-Linear Models

**Single variable goodness of fit tests**
- Chi-square tests; G test
- design: 
  - one variable with >= 2 categories
  - dependent variable is the counts (frequencies) in each category
- expected frequencies in each category calculted from predicted proportions

**Chi-Square Test**
- Example: chi-square test for sex ratio of senorita fish
- H-0: equal sex ratio
- expected f (frequency) = total expected p (proportion) times total observed f (the actual number of fish you counted)
- double check that your total expected frequency equals your total observed frequency
- chi-squared (X2) is like an f statistic, in that you aren't squaring anything or taking the square root of anything
  - sum of ((observed minus expected)squared) divided by expected
- get the p value the same way we get the f and t. we compare our chi-squared value to the chi-squared distribution
- each level of degrees of freedom has a slightly different shape of chi-squared distribution curve, and similar to f and t, you compare your chi-squared value along the correct distribution, with p values on the y axis and chi-squared values on the x axis to see if your value shows significance or not

**note** that a likelihood ratio test is actually different from a true chi-squared test.  LRT's use the chi-squared distribution (by chance), but calculates the chi-squared value differently, so not actually chi-squared but called chi-squared sometimes. when we get a chi-squared value from an ANOVA, that's actually the LRT

**G test**
- G = 2 * sum of each observed times ln(observed/expected)
- fairly new, not as commonly used as chi-squared
- the example gave us the exact same p value
- sometimes G values fit the chi-squared distribution better than a chi-squared value.
  - slightly better, but almost always going to give us the exact same answer, or very close
  - so use either for your statistics unless p value is actually significant with one and insignificant with another, in which case use G

**Tests of Independence / Contingency Tables**
- one more dimension to a goodness of fit test
- design: 
  - >= 2 categories crossed with >= 2 other categories
- observed frequencies (counts) entered into each cell
- example:
  - tests whether you find dead trees depending on which habitat you look in
  - 3 categories of one factor crossed with 2 factors of another factor
- like an ANOVA, looking at the interaction of these factors, seeing if one factor depends on the other factor
- if the two variables (rows and columns) are **independent**, then the expected probability of them occurring together is just the product of their independent probabilities
  - P(AB) = P(A) * P(B)
- null hypothesis is that they are independent of each other
- p < 0.05 means they are not independent of each other

**on the problem set, we could just calculate these by hand instead of in R**
- there's a package and function where all we have to do is input our frequencies and say G test and it spits out oa p value if we want to go that way

**Why G tests are better than Chi-squared**
- multiple G tests can be summed together
- like in ANOVA, can partition a total G test into separate G tests
  - example:
    - measure sex ratios at multiple locations
    - can combine all our data from all sites and do G test on that
    - but can also do G tests for each site and compare across sites
- G test additivity
  - G total: do the data fit the model?
  - G h (heterogeneity): do different sites have different sex ratios 
    - H-0 heterogeneity: the ratio of wild-type to pale-eyed is the same across 
  - G p (pooled): 
  - we use the G-t to get to the G-h, but people don't usually report the G-t
  - rather than do a G test on the whole data set, do a G test on each subset of the data using one variable at a time, so then you could see how that G compares to the total G

**Log-Linear Models in R**
- always use family = "poisson" for frequencies
- important to set up your data (excel sheet) the right way for the code
- model
  - frequency as our dependent variable
  - only putting interactions in our model
    - season:fruit (effect of treatment) (whether they produced fruits or not varies across seasons)
    - treatment: fruit (effect of treatment) (whether they produced fruits or not varies across treatments)
    - season:treatment:fruit (effect of season-treatment interaction) (whether they produced fruits or not varies across season-treatment interaction)
- anova(model, test="Chisq") but you aren't actually doing a chi-squared test here. you're doing a G test, but you're telling R to compare to the chi-squared distribution

- simple G test:
  - GTest() function and specify the expected probabilities p=c(#, #, #)



# Biometry Class 11-10-2020

### Multivariate Analysis and Principal Component Analyses

**Multivariate Analyses**
- analyses that include > 1 dependent variables
- some questions can only be answered with multiple variables
- ex. what determines the structure of a forest community?
  - compare wet and dry forests
  - community consists of 10 herbaceous, 10 shrub, and 10 tree species; 20 arthropods, 10 bird, and 5 mammal species
- ex. how do three rodents coexist?
  - data: 10 environmental variables recorded for 30 individuals of each of the 3 species
  - use to find the niche of the species, but no one thing defines the niche, it's all the things simultaneously

**Uses of multivariate approaches**
- description: 
  - how are variables related to each other? are they colinear?
- hypothesis testing:
  - reduce variables to one derived variable
  - multivariate approaches

**Derived variables**
- summarize variation in the data set, based on combination of the variables
- simple
  - length/width = shape
- less simple
  -  consolidate variance from a data matrix into a new set of derived variables
- ex.
  z-ik = (c-1)(y-i1) + (c-2)(y-i2) + ... + (c-p)(y-ip)
  - z-ik is the value of the new derived variable
  - c-1 to c-p are weights or coefficients that indicate how much each original variable contributes the linear combination
  - y-i1 to y-ip are the values of the original variables
  - analogous to linear regression equation

Create multiple derived variables
- first derived variable explains most of the variance in the original variables
  - the most important
  - explains the most variance
- second explains most of the remaining variance after the first has been extracted
  - uncorrelated with the first
- third explains most of the remaining variance after the first and second are extracted, and is uncorrelated with either the first or second, etc.
- number of new derived variables is the same as the number of original variables
  - but usually the first few explain much variance
- graphing for publication
  - typically folks just graph the first two (because often explain the most variation and difficult to visualize 3D on 2D paper)
  - you can display them in three-dimensional space, as well as possible on 2D
  - also can show the 3rd with the 1st
  - not really a right and wrong

**Eigenvalues and eigenvectors**
- eigenvalues
  - how much of the original variance is explained by each of the new derived variables
- eigenvectors
  - the list of coefficients (or weights) for each new derived variable
  - like an r2 value: how much of the variance in the original data is explained by the new derived variables
  - values shows how much each original variable contributes to each new derived variable
  - called "loadings"
  - like the slope, telling us how strong the relationship is

**PCA: Principal Components Analysis**
- visualization technique
- no hypothesis testing
- just like in a linear regression, PCA finds the best association among variables
- minimizes distance to line in both x and y directions
- does the same thing, but through 5 dimensions of space or 10 dimensions of space and we're fitting a best fit line through those dimensions
- best fit line is what we call PC1 (principal component 1), then we pass a line perpendicular to that (PC2), and it best fits the data left to be explained
- biplots: when you only plot two of the axes (usually between PC1 and PC2)

**Steps in PCA**
1. from raw data, calculate covariance or correlation matrix
  - use covariance matrix if variables on same scale
  - use correlation matrix if variables on different scale
  - OR convert all variables to z-scores (then use covariance matrix)
    - probably the most common thing folks do now for PCA
    - take the data point, subtract the mean, then divide by the standard deviation
2. Determine principal components (putting in the best fit lines through #-Dimensional space)
3. Calculate eigenvectors
    - weightings of each original variable on each component, aka "loadings"
    - and eigenvalues (variation explained by each component)
4. Decide how many components to retain
    - "scree plot"
    - will always go down, but what matters is how much it goes down
    - shows relatively how much each component explains
- if you have two variables that explain 90% of your variation, you don't have to try to use all of your 10 or whatever variables to run your analysis, you can just use the main 2 or 3 variables to run your stats

**Reading a PCA**
- loading value corresponds to how well the new derived variable aligns with the original variable (PC1 or PC2)
- ex. variables with high loading values close to parallel with PCA1 axis, 
- grouped variables are positively correlated with each other, and variables that are on opposite sides of the PCA are negatively correlated
- variables that are orthogonal are independent and not at all correlated with orthogonal variables
- not testing hypothesis, just letting us visualize and reduce the data, then we can come up with hypotheses to test
- we don't have to use all 7 variables, we just have to use those two PC axes
- visualizing hypotheses
  - coding different colors and shapes and coding to add confidence intervals
  - ex. 




# Biometry Class 11-12-2020

### More on PCA

**Example Biplot**
- colors are different species of algae
- Traits measured are listed for each species
- horizontal (or near horizontal) loadings are most associated with PC1 and vertical (or near vertical) loadings are most associated with PC2
- Fv correlated really well with PC1 so PC1 is definitely fluorescence, and maybe a little bit quantum yield and a little bit Ln Cell Count
  - so the horizontal dispersion on the PCA is driven mainly by Fluorescence
- loadings that are close to each other are the most correlated to each other
- small loadings (tiny nubby arrows) may not correlate well to PC1 or PC2 but correlates strongly to PC3
- blue species have relaly high quantum yield and purple have really low quantum yield
  - arrows show positive correlation, but if you were to flip the arrow in the other direction, that shows you the negative correlation
- the direction of the loadings indicates correlation to the PC. So Fv is negatively correlated to PC1 (so as PC1 goes up, Fv goes down, but that doesn't matter for biological interpretation.)
- scaling:
  - whether you scale or not depends on how the graph should look
  - so if you want your graph to be a square, you may need to scale to fit it all, but it wouldn't be as obvious if groups are actually farther from each other than the graph shows.
- If two axes are both realtively important (PC1 doesn't explain way more variation than PC2), then you'll get a square plot anyway



# Biometry Class 11-19-2020

www.csun.edu/SEF
- course evaluations

### Multivariate Analyses

**uses of multivariate approaches**
-	Description: 
  - Combine variables in an optimal way
  - Visualize relationships
    - PCA
    - nMDS
-	hypothesis testing:
  - compare among groups
    - MANOVA (mostly replaced by PERMANOVA)
    - Discriminant Function Analysis 

**MANOVA and Discriminant Function Analysis**
-	>= 2 dependent variables; one or more predictors
-	Same mathematical approach for both
-	Different uses:
  - MANOVA uses all variables
    - Multivariate equivalent of ANOVA
    - Discriminant Function Analysis

**Multivariate data**
-	Centroid
  - Measure of location of multivariate data sets
  -	Represents the mean of all the variables
  -	In multivariate space, the centroid represents the univariate means of each of the variables

**MANOVA: multivariate analysis of variance**
-	Asks: is there a difference in response variables among groups?
-	Why?
  -	Could run many univariate ANOVAs, one for each response variable (ex. 10 ANOVAs for each variable
  -	Increases prob of type I error
-	MANOVA compares centroids among groups
  -	Just like ANOVA, get a ratio of variances
  -	How far is each data point from the centroid? Within groups
  -	Compare the mean of each group to each other. Among groups

**MANOVA tests**
-	Not so hard to get an F value, but hard to get p values
-	H0: no difference among centroids of groups
-	Different measures of a ratio of variances can be used
  -	Wilk’s lambda – measure of how much the total variance is due to the residual (i.e. smaller values indicate larger among group differences
    - Safest approach. Just default to Wilk’s lambda
    -	Report Wilk’s lambda, df, and p
  -	Hotelling-Lawley trace
    -	Uses the sum of squares of the cross products (measure of covariance) to look at covariance among groups over covariance within groups
  -	Pillai trace – ratio of eigenvalues
    -	For really small sample sizes (ex. < 10) and only two groups (ex. site a and site b)

**Relative importance of each variable**
-	Methods to assess relative contribution
  -	Univariate ANOVAs common, but meh. Not a good idea
  -	MANOVA fits a discriminant function and you can examine coefficients. The ones with the highest coefficients are the most important variables (greater weight)

**MANOVA example**
-	Trace metal concentrations in marine sediments 
-	Three sites
-	Variables: Concentrations of 4 metals
-	So we create our linear model and each variable has a coefficient in front of it (like a slope). 
  -	The variables with the highest coefficients are the dominant drivers of those variables at our sites
-	Univariate ANOVA’s give us p values but that doesn’t tell us importance
-	Coefficients (loadings) tell us importance
  -	Coefficients for discriminant function
  -	1 (Eigenvector 1)
  -	Sign doesn’t matter

**Assumptions of MANOVA**
-	Multivariate normality
  -	Normal in every dimension and throughout multidimensional space
-	Homogeneity of variance-covariance matrix
-	No collinearity between variables (r < 0.9)

**Descriminant Function**
- MANOVA linear model
- also used for Descriminant Function Analysis

**DFA: Discriminant Function Analysis**
-	How well does the discriminant function classify data to particular groups?
-	If you find that your DFA is good at classifying groups, then you could take new data, apply the DFA to it, and assign your data into your groups
-	Groups are pre-determined (by you)
-	Can also classify new observations into one of the groups
-	Produces a measure of the likelihood of success of our classification

**Classification and Prediction**
-	3 steps in using classification functions
  1.	Get the coefficients and constant of the classification equation for each group
  2.	Get a classification score for each observation for each group
    a.	Calculated by using the actual values for each variable to solve the classification for that group
  3.	Classify each observation into the group it matches most closely
    a.	This may or may not be the actual group from which the observation came
    b.	You have to know what group the observation goes into. You have to know the classifications already, and then you can see how good the DFA is at fitting the data

**Jackknife to evaluate success of classification**
-	Problem: we classify each observation with an equation that already used that observation (circular logic)
-	Jackknife:
  -	Take one data point out and do the analysis. Then take another data point out and do the analysis
  -	So you take your data point out and fit the DFA and then you take another data point out and fit the DFA again and get your coefficients and see which group your observation goes into.
-	Solution to avoid bias: use a jackknife procedure to derive classification functions
  -	Classification functions determined when the observation is omitted and only 


**R mode vs Q mode Analysis**
-	R mode is like a PCA
  - Association matrix of variables
  -	Create a matrix showing how one variable is related to another variable
  -	How well is one variable correlated with another variable
-	Q mode
  -	Instead of looking at variables, we’re looking at objects
  -	Dissimilarity matrix of objects
  -	The matrix depends on how many individuals we measured
  -	How similar is one fish to another fish (ex.). how similar is each object to the others?

MDS: multidimensional scaling**
-	Another way to summarize multivariate data
  -	Fewer assumptions to PCA
  -	Like PCA, does not formally test hypotheses
  -	MDS works directly on objects (sampling units) rather than variables
-	Why use MDS rather than PCA?
  -	MDS has fewer assumptions
  -	PCA relies on linear relationships among variables
  -	PCA doesn’t perform well with a lot of zeros (like with a benthic analysis for species composition using quadrats)
    -	MDS does just fine with the zero data for unrepresented species
  -	Dissimilarity among objects is often …

**MDS Steps**
1.	Raw data matrix
2.	Transform data, if desired
  a.	Transformations can have very strong effects on final MDS plot
  b.	Can affect interpretation of data
    i.	*No transformation* emphasizes large values
    ii.	*Square root* transformation de-emphasizes large values
    iii.	*Fourth root* de-emphasizes large values more than square root
    iv.	*Log transformation* de-emphasizes large values even more than fourth root
  c.	If you want to emphasize those large values, then you don’t have to do any transformation, but if you want to de-emphasize those large values, then do a transformation. And most of the time, folks do a fourth root transformation
    i.	Fourth root is most common and it’s more common to transform data than to not transform data
3.	Dissimilarity matrix
  a.	Bray-Curtis is the best dissimilarity measure for ecological data with lots of zeros
    i.	Default in R
    ii. no reason to not use Bray-Curtis
  b.	For other data, Euclidean distance and other measures are appropriate
4.	Decide number of axes (dimensions)
  a.	Usually between 2 and 4 dimensions
  b.	More dimensions means better match, but harder interpretation
  c.	Decision usually made based on stress values
  d.	Stress value < 2 is great. 2 is okay
5.	Arrange objects in ordination plot
  a.	Configure objects in space so that their distance from each other best represents their dissimilarity
    i.	Start with random configuration
    ii.	Then move points around to reduce stress
    iii.	Final configuration = lowest stress
  b.	Stress = difference between distance between points on the plot and actual dissimilarity
6.	Final plot
  a.	Further moving of objects on ordination plot cannot improve match between dissimilarities and distances 
  b.	Stress as low as possible
  c.	Helpful to color code your groups so you can make inferences about the similarity of groups

Two types of MDS: MDS and nMDS
-	MDS uses actual distances and dissimilarities
  -	Problem is that this is often non-linear
-	nMDS uses ranked distances and dssimilarities
  -	similar to spearman rank correlation
  -	common for biological data
  -	the most dissimilar things have to be the farthest things apart
  -	the second most dissimilar things have to be the second farthest things apart
  -	helps to see the spread of your data better
-	rarely see an MDS plot – almost always see an nMDS because it’s a non-parametric test so you get rid of all your assumptions

PERMANOVA (permutational ANOVA)
-	multivariate sums of squares partitioned within and among groups (based on distance from centroid)
-	difference from MANOVA is in how p values are generated
  -	MANOVA: calculate pseudo-F and then get p values
  -	In perMANOVA: shuffle items among groups (one permutation). Calculate F
  -	Do this many times (999?)
  -	P = # times permutedF > actualF) + 1 / (total number of permutations + 1)
-	Very powerful and flexible (can handle complex linear models)
- permutations: shuffle the data and check if the F value is better or worse

ANOSIM (Analysis of Similarity)
-	Same thing that permanova is doing, but instead of using actual dissimilarities, ANOSIM uses ranks of dissimilarities
-	ANOSIM actually a more direct test of what is shown in nMDS
  -	Recall that nMDS uses reanks too
-	While PERMANOVA is probably better to do with MDS
-	Maybe less powerful than PERMANOVA, but if we get a significant p, then we’re okay regardless



# Biometry Lecture 12-3-2020


**Types of Regression**
- non-linear regression
  - trait selection plotted against fitness (y) (fitness could be inseminations, or survival, or # eggs, etc)
  - ex. fly larvae in a gall. if too small, could be parasitized by a wasp.  if too big, could be found and eaten by birds. intermediate size where the gall/larvae survive well
- In R
  - LinearModel<- lm(fitness ~ hornLength)
  - PolynomialModel <- lm (ProportionSurvived ~ GallDiameter + GallDiameter^2)
- How to choose?
  - ideally you know going into your study that you may look for nonlinear relationship
    - you should know your analysis before looking at your data
  - often people will put in a squared element to test fo rnonlinear component
  
**Time Series Analysis**
- you will see a significance of time
- don't treat time as continuous, you treat it as categorical
  - if we treated time as continuous, then we'd do a regression, and people do that as well but answers a different question
  - continuous: is there a change over time?
  - if we treated as categorical, we do a Repeated Measures analysis
  - categorical: 
- ex. seasonality? decadal cycles? ENSO events?
  - if we didn't factor some of the seasonal variation out, we'd get a lot of noise in our data. if we factor it out, we can see the patterns better

**What to do with Time Series Data?**
- just fit a function (eg regression)
  - often adequate if there is a clear pattern
  - can detect long-term trend, but seasonality is just "error"
  - does not account for autocorrection (eg warm winter prob = warm summer)
- smoothing
  - take out the seasonality by averaging the data
  - moving average: repalce each sample by average of x surrounding samples
  - also various weighted moving averages

**Measuring Seasonality**
- autocorrelation: correlation of a signal with a delayed copy of itself
  - similarity among samples with a time lag
  - k = tiem lag among correlated samples (ie often one year)
    - the less error, the easier it is to identify k
- can also use autocorrelogram
- integrade time lags maybe because it can take a while to notice the change or pattern

**How to Analyze Time Series Data**
- ARIMA: Autoregressive moving average model
  - allows one to detect trends and seasonality relative to error
  - also allows forecasting predictions (unlike regression)
  - can describe an ARIMA model as (p, d, q)
    - so a (1, 1, 2) ARIMA model has:
      - p = 1 autoregression parameter (eg number of lags)
      - d = 1 non-seasonal differences needed for stationarity
      - q = 2 moving average window
    - usually use 0, 1, or 2 as values
    - usually need to use model selection to find the best model
    - then can hypothesis test using that model

**Zero-Inflated Data**
- Very common in biology
- ex. abundance data. most common result is zero in quadrats or locale counts
- some people throw out the zeros, but maybe not the best because it's still data
- three solutions
  1. Bayesian statistics
  1. R packages that include zero-inflated distributions
  1. Hurdle Model (essientially 2 different models)

**Zero-Inflated Distributions in R**
- glm or glmer allow for poisson or negative binomial
  - but often not zero-inflated enough. often fits data better, but not quite "good". our data tends to have more zeros than R can handle
- zeroinfl in the pscl package allows for zero-inflated poisson or NB
  - can fit pretty well
  - if we have a normal distribution but with a huge spike in zeros, a poisson distribution doesn't really fit our data either

**Hurdle Model**
- Logistic Model where outcomes are 0 and non-zero
  - what factors are driving presence?
  - ex. pond size in relation to presence of crocodiles in those ponds. presence/absence data. does pond size affect whether crocodiles are present?
- normal (or other) distribution with only >0 data
  - if present, what factors are driving abundance?
  - ex. pond size in relation to number of crocodiles. does pond size effect how many crocodiles are present?
- one factor may affect whether crocodiles are there, but a different factor(s) may affect how many crocodiles are there
- in R
  - normal regression
  - maybe do a G test, then do an ANOVA after
  - taking one subset of your data for one test and another subset for the other test

**Bayesian Statistics**
- need to start with a prior distribution that includes lots of 0's
- in R, JAGS package: Just Another Gibbs Sampler
- Statistical Inference
  - two approaches
    - Frequentist approaches (Everything we've covered in this class has been frequentist):
      - how well does my data fit the model?
      - based on determining the probability of obtaining the observed data
      -  value gives THE ANSWER to whatever your question is
      - two types:
        - Null hypothesis testing: is the data we collected more extreme than a null expectation; is the data different than random/chance alone
        - Maximum Likelihood: determining likelihood that the data would belong to a distribution with mean mew and standard deviation sigma
      - problems:
        - whether we decide if our result is interesting or not is based on an arbitrary p value.
        - the p value is not telling us the probability of whether the treatment is different from the control
        - the p value is telling us the probability of getting the data that we got if the treatment is different from the control. slightly different, though similar
    - Bayesian approach:
      - asks different questions that don't just rely on observed data
      - how well does the model fit the data?
      - asks:
        - how well do particular conditions explain the data that have been collected
        - how well does a model (informed by prior data) fit your newly observed data
      - takes your result and compares it to the wider body of knowledge

**Bayes' Theorem**
  - Given what we already know, what is the probability that the thing you just found is true?
  - What's the probability of both A and B being true, where A is your prior hypothesis
  - P(A|B) = P(A with B) / P(B) = P(B|A) * P(A) / P(B)
  - incorporate prior observation in Bayesian Stats

**Bayesian Inference**
- ex. Imagine you want to estaimte the survival rates of bears
- Data: 0.11, 0.45, 0.55, 0.89
- Average survival = 0.5
- you know from previous experience that large mammals have high survival rates
- based on a prior distribution, you expect bear survival to be about 0.8
- so you use the prior distribution and then you create a post distribution
- becoming more popular because we never do our experiment in a void. we always have some idea of what the data could look like from prior knowledge




# Final Biometry Class 12-8-2020

Coding Final
- Due Dec 15
- Can use all resources except each other

Dec 15 Written Final 
- Have 2 hours to complete, but shouldn't take 2 hours
- Casey and Cam will be online, but don't need to be on zoom unless we have a question
- Cumulative but weighted for most recent
- questions like "do you know theh difference between these ANOVA's"

PCA
- check assumptions: normality and homoescedasticity
- no collinearity by default
- can do a perMANOVA
- can do a multiple regression

Casey's office hours at 11 tomorrow
Will put the key for PS8 on canvas for reference this week

anova model
- colon for interaction
- slash for nesting
  - ex. B nested within A is "A/B"

Moving forward at the end
- make a cheat sheet for stats 
- make a road map for myself so I don't forget down the line
- in future, I can look at my cheat sheet and say "based on the kind of data I have or want to collect, here's the kind of test I can/should do"
- create a sort of dichotomous key

Beware of the limits of p values.
- p values don't tell you if something is right or wrong. they tell us the probability of whether something is right or wrong.





