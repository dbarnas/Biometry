# Biometry Class 9-24-2020

## Housekeeping
- Add to regression code: plot(model1,4)
- Midterm question clarity: what does p tell us vs r?
  - p value: tells us if they are correlated if < 0.05
  - r value: tells us how well they are correlated (clower to 1 means more correlated)

**Regression Lines**
- standard when graphing:
  - draw a line if significant relationship, but no line if there is no relationship

**Linear models review**
- response variable = model + error
- F tests compare: explained variation (model) / unexplained variation (residual or error)

**Multiple Regression**
- adding more factors into our model
- more than one continuous predictor variable in the model
- yi = B0 + B1x1 + B2x2 + B3x3 + ... + error1

**Simple regression**
- two possible simple regression models:
- 1) yi = B0 + B1x1 + error1
- 2) yi = B0 + B2x2 + error2

**Regression on the residuals**
- plot residuals of Temperature regression vs Moisture
  - residuals: distance of each point to its predicted point on the line
- take the residuals and plot those against moisture
  - look for a strong relationship without temperature
  - may not have seen a strong relationship with temperature because all the low moisture points were on one side of the regression line and all the high moisture points were on the other side of the regression line
  - so now the relationship between moisture and growth is apparent, but it was hidden by the effect of temperature

**Multiple Regression**
- fits "response surfaces" (planes, hypervolunes), not lines
- we can then take that plane and determine whats the slope on the Years axis and what's the slope on the Patch Area axis (see slide)
- could do it in four dimensions as well and effective plot a sphere to get slope on three axes, etc for multiple planes
- we see what each parameter's independent weight is on the model. so even if multiple variables seem to have an effect, multiple regression allows you to see how much each is really affecting the system independently

**Hypothesis Testing**
- take variation that is explained by our model (the plane)
- then find out how much variation is unexplained by our plane
- 1) test of whether overall regression equation is significant
  - Use F-test
- 2) effect of each predictor variable
  - H0: Bi = 0
    - t-tests or F tests (R gives t-tests)
    - separate t-test for each partial regression coefficient in model
      - compare B1 to B2 and see if that's equal to 0, then B2 to B3 and see if that's equal to 0, etc.
- Comparing regression coefficients
  - yi-hat = b1x1 + b2x2 + b3x3 + ...
- each bi might be expressed in different units
  - cannot directly compare
- can standardize by standard deviation of x and y
  - could probably use z-scores as well, and *should* be the same, for hypothesis testing. The only thing this wouldn't work for is if we care about the exact value of the slope, which usually we don't.  We just want to know if the slope is 0 or not.

**Assumptions**
- normality and homogeneity of variance for response variable
- independence of observations
- linearity
- no collinearity
  - not that they can't be somewhat related to each other, but they can't be VERY related to each other (will go over later how related is too realted)
  - collinear = predictors are correlated = unreliable....(see slide)

**Checks for Collinearity**
- Tolerance for each predictor: 
  - 1-r2 ... (see slide)
- VIF values (variance inflator factor)
  - 1/tolerance
  - look for large values (>10)
    - VIF of 20 is a high factor
    - VIF of 12-13, that's borderline
    - if large value, may need to drop a variable

**Scatterplot Matrix**
- look at relationship between predictor variables
- any showing linearity are problematic and you wnat to try getting rid of collinear variables if you can
- what you want are the variables that are the *best* predictors, ones that explain the most variance
- "am I actually adding value/is my model actually better by adding this factor?"

**Model Selection**
- Maximum Likelihood: a measure of how well your model fits the data
  - from negative infinity to infinity
  - lower values are better fits of the model (lower likelihood is better, and can be negative)
- AIC (Akaike's Information Criterion)
  - takes the natural log of L (our likelihood) times 2, subtracted from double the number of parameters
  - AIC = 2k - 2ln(L)
    - k = number of parameters
    - lower values are better fits of the model
    - can compare a model of 2 parameters to a model of 10 parameters and see if our model is stronger. AIC takes into account (penalizes  you for) more parameters in your model
  - AICc = corrected AIC
    - better for a small sample size
    - never hurts to use AICc
    - corrects AIC when n is not much bigger than k


**Plot a model**
Residuals vs Fittted
- for homogeneity of variance
- looking for the spread of data to have no pattern
- is there a cone-shaped pattern or not
QQ plots
- no confidence intervals
- check for normality
Fitted values to square root of standardized residuals
- also for homogeneity
- either plot is fine to assess 
Residuals vs Leverage
- Cook's distance
  - measure of outliers
  - can't even see the red dotted lines (for our class example) so nothing to be concerned about
  - if data points fall outside of the dotted line, then we should be concerned
  
**summary()**
- see recording
- f value and p value for hypothesis test 1 (how good is our model)
  - high f value and low p value show that our model is a good fit
- Estimate Std: slope values (can look and see if different than 0)
  - the t-value and p value tell us if the slopes are different from 0 (hypothesis test 2)
  - shows us which parameters were actually strong predictors (in the multiple regression script, length is the best predictor)
  - length basically explains everything in the model
  - length predicts weight very strongly, and predators and food don't
    - previous models showed us that predators affect length, but doesn't affect weight much, while length affects weight much more

**Scatter plots**
- using GGally library
- see recording
- want correction factor to be above 0.1

**multiple regression script**
- we have seven models
  - 3 single factor models
  - 1 full model
  - 3 reduced models (each reduced by one)
- get AIC for each and look for the lowest one
  - the full model is the best (but basically the same as reduced1 and reduced2)
  - rule of thumb is either take the lowest one or if the AIC is within 0.2, it's basically the same
- check normality with a qqplot but with residuals
- "variables" are usually the thigns you measure and are your predictors or dependent variables
- "factors" are the independent variables
- in practice, usually do the full model first, then make the reduced models if you think that's necessary and you can compare the reduced models to the full model








