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
