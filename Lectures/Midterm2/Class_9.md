# Biometry Class 9-29-2020

Before Thursday: Exam Wrapper
- upload on Canvas
- Questions on Exam Wrapper slide

Last Time:
- Multiple predictor variables
- Standardized regression coefficients
- Colinearity

**Standardized regression coefficients**
- useful when our measurements are on different scales
- ex. if we measured length, pH, and altitude, they're on such different scales
  - the coefficients give us the slope between two of those variables
  - the slopes could be very different and not useful to compare, but the coefficient lets us standardize so we can compare

**GLM - General Linear Model**
- response variable = model + error
  - model incorporates the predictor variable(s)
  - error is what is not explained by the model
- F tests compare Explained Variation (model) / Unexplained variation (residual/error)
  - use the F statistic to get the probability that Explained = Unexplained variation
- Regression and ANOVA (one factor) are both GLM's
- Regression:
  - 1 continuous response variable
  - 1 continuous predictor variable
  - continuous x and continuous y
- ANOVA (one factor)
  - 1 continuous y response/dependent variable
  - 1 categorical x predictor variable ("factor")

**Purpose of ANOVA**
- partitions variation among different sources
- tests whether means differ
  - like a t-test but with more than 2 means

**Terminology**
- factor = predictor variable
- one-way: 
  - we have one factor
  - can still have multiple levels of that factor
    - ex. temperature is our one factor. could have "low", "medium" and "high" (multiple groups/levels of a single factor)
- p: the number of groups/levels of each factor (p = 3 for above ex.)
- n: number of replicates within each group/level
- yij: the ith observation in the jth level

**Types of factors (predictors)**
- **Fixed effect/factor:**
  - all levels or groups of interest are used in study (old school)
  - conclusions are restricted to those groups
  - we've included all the levels that we're interested in
  - ex. fixed factor = site, sampled 10 sites
    - asking if our 10 sites are different
  - anything you're interested in testing the effects of in a study (new school)
    - anything you're interested in getting a p-value for
- **Random effect/factor:**
  - "random" sample of all groups of interest are used in study (old school)
  - conclusions can be extrapolated to all possible groups (old school)
  - ex. random factor = site, sampled 10 sites
    - those 10 sites represent a random assortment of sites
    - so if we find a difference we can extrapolate to saying all sites are different
    - our factors represent a subsample of ALL levels, therefore our results can be applied to all levels
  - some kind of grouping variable you have to help you avoid pseudoreplication (new school)
  - don't test p-values for random effects/factors
- **for one-way ANOVA, only used fixed effects**
- becomes very important in multi-factor ANOVA
- ex. Region: northern CA vs southern CA
  - each region has 10 sites
  - each site has 10 transects
  - want to know if regions are different from eachother
  - can't take 10 transects from site 1 and 10 transects from site 2 and lump them together because then we're pseudoreplicating.
  - so use the mean of each site to compare the regions
  - so site is a random factor, and you put in the model to account for variation so we make sure we tested correctly to compare the regions
- error term in a model is ALWAYS a random factor

**Linear model for ANOVA**
- Linear model for 1 factor ANOVA:
  - yij = overall population mean (mew) + effect of the ith treatment or group (alphai = mean - meani) + random or unexplained (variation not explained by treatment effects) (epsilonij)

**ANOVA partitioning variation**
- explained variation is BETWEEN groups
  - difference between group means and grand means
- unexplained variation is WITHIN groups
  - difference between actual value and group mean
- how does the mean of one level differ from the total mean (yi-bar - y-bar)
- for the error, how far away is each data point from the actual mean from that group (yij - y-bar)
  - error tells us: how wide is that curve?
  - a lot of error yields wide curve
  - small error yields not wide curve
1. calculate the grand mean
2. calculate the mean of each group
3. subtract each group mean from the grand mean and square and multiply by n, then sum for all groups
  - between group variation
  - SS Between Groups (explained) = Sum(n*(ybar-group - ybar-grand)^2)
  - df = 1
4. ask how far each data point is away from its group mean (subtract point from group mean, then square, then sum for whole group and then sum for all groups)
  - error variation
  - SS Within Groups (Residual/error) = Sum(Sum(y-actual.value - ybar-group)^2)
  - df = p*(n-1)
- SS Total = SS b/n groups + SS w/n groups
  - df = p*n - 1
- degrees of freedom for the total should add up to your number of samples minus 1 (number of levels * number of samples in each level)
- f ratio is mean squared groups / mean squared residual
  - how much variation there is within groups and between groups
- why do we multiply our squares for Groups by n?
  - take the 3 numbers we summed and multiply by n so we have a more fair comparison between Groups and Residuals because Residuals is going to naturally be a larger number because you're summing up all of the groups and samples
  - basically to make sure it's a fair comparison
  - the n is basically **weighting** the Groups/Levles to compare to Residual

F-ratio
- MSmodel / MSerror
- So we get an f ratio and then we compare to the F distribution
- P(F) on the y, F on the x
- if F-observed > F critical, then p<0.05

**Assumptions of ANOVA**
- same as regression
- apply to the residuals of the model
  - normality
  - homogeneity of variances
  - independence

Other approaches
- can try transforming data if non-normal
- tests that allow unequal variances:
  - Welch's test (only works for two groups, not three or more)
  - Wilcox Z test (does not assume equal variances, not super common)
- rank-based "nonparametric" tests
  - Kruskal-Wallis test
    - limited to simple experimental designs, only for a one-way anova
    - pretty uncommon
    - Casey will judge you and think you don't know what you're doing because of better alternatives (like Generalized linear modeling)
- Generalized linear modeling
  - if non-normal dsitribution is known, eg. Poisson)
  - residuals don't have to be normal anymore
  - anova is basically a generalized linear model that assumes normality
  - a little harder to program and more computationally expensive (less efficient)
  - use maximum likelihood more
  - have to trick R into giving us a p-value
  - could use this over transforming your data and running an ANOVA, but either will work
- Permutation tests (PERMANOVA)
  - multivariate tests  
    - ex. not testing one species, testing 100's of species (often in microbial ecology)
    - can use with one variable. can use like a one-way anova
  
