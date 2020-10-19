# Biometry Class 10-15-2020

## Repeated Measures ANOVA
## ANCOVA - Analysis of Covariance

**Repeated Measures ANOVA**
- helps you deal with what happens when you sample the same units more than once
  - sampled at time 1 and time 2 (like a t-test), but now we can measure multiple times (more than just 2)
- ex. measuring subjects repeatedly, but under different conditions each time (once without a treatment (control), once with treatment A, and once with treatment B).
- scenario 1
  - all treatments applied to all replicates in random order
  - all subjects got all treatments
  - subjects as block factor
  - treatment as fixed factor
- scenario 2
  - each treatment applied to a subset of replicates over time
  - treatment as fixed effect
  - time as fixed effect
  - subjects are randomly nested within treatment
    - each subject got one particular drug. not every subject got every treatment. not all subjects are represented in all levels of every treatment. therefore "nested factor" within treatment


**ANCOVA**
- combines ANOVA and regression
- always one continuous predictor variable
- always at least one discrete predictor variable
- used for two purposes
  - reduce unexplained variation to make tests more powerful
  - or compare slopes of two or more regression lines
- overall, is there a significant regression, ignoring groups
- or ask is the mean of group 1 different from group 2, ignoring the regression
- ex. three levels of water treatment
  - could do a one-way anova on seedling survival with three different watering levels 
- ex. now add a coveriate
  - growing the seeds out in a field, so it's possible that the proximity to a bush affects the seedling survival
  - could calculate the distance of bushes from seedlings and could use proximity to bushes as a covariate
  - covariate accounts for some of the variation
  - in every case, there is a relationship in proximity to bushes. if further from a bush, there is higher survival in all treatments
- behind the scenes:
  - use residuals from regression to test treatment
  - plot distance (x) against seedling survival (y)
  - then plot the distance (x) against the regression (y) and should see no pattern
  - now we can get the residuals from the second plot and get the affect of the watering treatment on seedling survival with reduced variation
- ANCOVA does everything in one step and answers three questions at once:
  - is the covariate important
  - is the treatment important
  - and is there an interaction between the two
- typically include the covariate as a fixed effect

**Assumptions**
- normality of residuals (typical parametric assumption)
- homogeneity of variances (typical parametric assumption)
- independence (typical parametric assumption)
- linearity (linear regression assumption)
- covariate range is similar across groups (ANCOVA assumption)
  - ensures that the covariate is statistically independent of group (treatment)
  - avoids extrapolation of regression line
  - groups could overlap a little, but not all the way

**Test for different slopes**
- Treatment * Covariate interaction
- interaction tests the homogeneity of slopes
  - null H: the slopes are homogenous (they are the same slopes)
  - slope tell us, depending on which group we're looking at, there's a different relationship between the x and y
- look at the interaction first

- ex. if you increase density, does the mortality of that population change?
- when predators are absent, there is no significant relationship between density and survival. slope is insignificantly different from zero.
- when predators are present, there's a relationship between density and survival
- the p value of the interaction tells us the slopes are different if p < 0.05
- predator main effect p value tell us, independent of density, is there an interaction of predators and survival
- density main effect p value tells us, independent of predator presence, is there an interaction of density and survival
- but neither main effect is helpful when the interaction p value is significant, meaning the slopes are different, meaning the interaction is significant

**General Linear Models**
- t-test: two levels of one predictor
- regression: continuous predictor
- ANOVA: categorical predictors
- Mixed Model ANOVA: fixed and random predictors
- Repeated Measures ANOVA: mixed model ANOVA with time component
- ANCOVA: mix of categorical and continuous predictors
- not every model has a name
  
**ANCOVA vs ANOVA**
- want to know both if the means of groups are different (ANOVA) as well as the trend of the data (regression)
- ANCOVA gives F and p values and then describe the trend

  