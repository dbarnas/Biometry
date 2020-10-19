# Biometry Class 9-17-2020

**Model Fitting and Regression**

**Midterm on Tuesday, 5pm - 8pm**
**Open note/book**
**material through today's lecture**

- half concept/theoretical q and a's
- half in R
  - manipulating a dataset and/or answering questions based on a dataset
  
**review from Lecture 6**
- make sure you can not only run the test in R, but also interpret and understand the result
- paired t-test: only do this over a two-sample t-test if you have some reason why the groups aren't independent

**Correlation vs regression**
- correlation doesn't assume cause and effect, just if the two variables co-vary
  - the variables might co-vary because of the same thing, but not because of each other
- regression
  - assuming the thing on the x axis is causing the thing on the y axis.
  - wording: "x predicts y" or x drives y

**Linear models**
- response variable (dependent variable) = model + error
- response (dependent) variable on the y axis
- one or more predictor (indpendent variable(s)) on the x axis
- error: component represents the part of the reponse variable not explained by our model

**Linear Regression**
- Purposes:
  - Description: Does x explain y?
    - is x related to y, does x change y?
  - Explanation: How much of y is explained by x?
    - how much of x explains y? like does x explain 50% of y?
  - Prediction: Predict y values from x values we may not have measured yet, and evaluate precision of those estimates
    - based on the slope of that relationship between x and y

**Simple Linear Regression Equation:**
- y = beta-naut + beta-one * x + epsilon (basically y=mx+b + error)
  - beta-naut = y-intercept
  - beta-one = coefficient of slope
  - epsilon = error
  - equivalent to y = mx + b
- step 1: calculate mean of x and mean of y
- step 2: calculate deviations from means of x and y
  - for every data point, we'll have how far away it is from the x mean and how far it is from the y mean
- step 3: calculate xy deviation cross-products
  - sigma((x - x-mean)(y - y-mean))
  - multiply ever deviation for x and y for each data point and add them all up
- step 4: calculate slope (beta-one)
  - slope = sum of cross products / sum of squares for x
  - sum of squares for x = sigma((x - x-mean)^2)
- step 5: solve for intercept (beta-naut)
  - y-mean = beta-naut + beta-one * x-mean (y=mx+b)
  - use average y and average x, and we already know our slope from above, so solve for the intercept (beta-naut)
  - rearrange equation to solve for intercept
- step 6: 
  - so how well does that equation estimate our population? solve for error (how much is unexplained by our model)
  - do hypothesis testing: does x actually drive y?
    - slope null hypothesis
  - you can always fit a line, but does that line have a real slope? is it different from zero? if the slope is distinguishable from 0, then x has some effect on y.

**How well does our equation from our sample represent the population?**
- sample equation: y-predicted = b-naut + b-one * x
- population: equation: y-predicted = beta-naut + beta-one * x + error

**Slope tells us how much x affects y**
- if the slope is indistinguishable from 0, then x has no effect on y

**Hypothesis testing with linear regression**
- two main hypotheses can be tested:
  - H-naut: beta-one = 0
  - H-naut: beta-naut = 0 (uncommon)
- slope null hypothesis
  - could do a one-sample t-test to see if our slope is different from 0
  - or could do an f-ratio statistic

**F-ratio statistic**
- = MS-model / MS-error
  - mean square of the model (a variance)
    - adding up all the sum of squares and dividing my the degrees of freedom
  - f-ratio is the mean square (or variance) that's explained by our model (our equation we just calculated) / how much error there is
  - if our model explains much more variation than there is error, than we assume our model can explain variation
- MS = SS/df = variation (MS == mean square)
  - need to know degrees of freedom
- The F distribution
  - is the f-value we got big enough that we can call our variation significantly different (big enough = there is less than a 5% probability of chance (less than 5% chance that we're wrong), p < 0.05)
  - F = MS1 / MS2 (MS-model / MS-error)
    - need to know the degrees of freedom of the model and of the error (2 degrees of freedom)
  - with high degrees of freedom for both, we get something looking like a normal distribution (for higher sample size)

**Using Ordinary Least Squres (OLS)** (time stamp: 30min into lecture 7)
- used to get the variance in our model to get the best fit line for our model
- if we took every data point (every y value) and subtracted the mean, and squred it, we'd get the sum of squares.
- y-hat is our expected y. for any given x, what do we expect the y to be? that's y-hat
  - however much y-hat differs from the mean, that's how much our model explains
  - and then however much the data point differs from y-hat is unexplained by our model (error) (unexplained variation) (residual)
- Analysis of Variance slide table
  - degrees of freedom
    - for a regression: df = 1 always
    - residuals: df = n-2
  - sum of squares of our model: sigma((y-hat - y-bar)^2)
  - unexplained variation or residual or error: sigma((y-i - y-hat)^2)
    - residual: how much is left over after our model explains stuff
  - take the sum of squares for our model and for our error and divide each by their respective degrees of freedom to get our Mean Squares for each
    - degrees of freedom:
      - DF for regression = 1
      - DF for residual = n - 2 (because we had to calculate the slope and the intercept, so two things are not free to vary)
- F-ratio of about 3 or higher, that's usually significant
  - so if MS-model / MS-error is much greater than 1, then we can say our model explains the variation more than just by chance. that x explains y to some degree and that our slope is not 0 (either positive or negative)
  - so how big is big enough?
  - if our sample size if pretty large, then the f-ratio probably only needs to be like 2.7 or 3, but if our sample size is very low, then the ratio probably needs to be much higher
- given the f-ratio with both the numerator and denominator degrees of freedom, what's the probability of getting that f-ratio by chance? 
- take the f-ratio, compare to the f-distribution
  - what's the probability that we'd get the f-ratio just by chance?  if the f-ratio is on the outskirts of that distribution, our p-value is pretty low (unlikely just by chance), but if the f-ratio is somewhere in the middle of that distribution, the probability that our null hypothesis is very low (that x does not explain y)
- **result: probability that x affects y**

**r-squared: coefficient of determination**
- measures explained variation
  - sum of squares of our regression divided by the total sum of squares
  - what percentage of the variance in our data is explained by our regression
  - simply the square of correlation coefficient, r
  - proportion of variation in Y explained by linear relationship with X
  - ranges from 0 to 1
    - if 0, x doesn't explain y at all
    - if 1, x perfectly explains y
- want to report the F and p value (answers yes or no if there's a relationship), and the r-squared value to tell the strength of that correlation/relationship

**Assumptions of Linear Regression**
- Parametric assumptions:
  - normality (y is normally distributed for each value of x)
    - for each value of x, we find every value of y and see if those y values are normally distributed
    - difficult. we often have only one y for each x
  - homogeneity of variance
    - for every value of x, is the spread in the y data the same?
  - independence of samples
  - linearity between y and x
- difficult to test normality of every data point and variance of every data point, so we get residuals

**Residuals**
- essential
- check normality of residuals, instead of original data!
- difference between observed value and predicted value (y - y-hat)
- studentized residuals = residual / SE of residuals
- check for homogeneity of variances
  - when we plot predicted  y against residuals: what we want to see is no pattern (even variance of y along x)
  - if you see a pattern, you can usually just transform one of the variables
    - but if you do, remember to label your axes appropriately when you graph later (ex. log(y))
- no 'standard' but Casey usually starts with y. checks residuals and if not normal, then transforms y first and checks residuals, and if that doesn't work then transforms x and checks residuals again
  
**Leverage**
- extreme observations
- measures how much each x could influence predicted y
- you have a legitimate data point that is off from your other points and affecting your regression line
  - if you want to see how much a leverage point is affecting your line, do Cook's D
    - Values > 1 are suspect
    - Be wary of leverage values of 2 or so

**Model I and Model II Regression**
- Model I
  - you chose specific values of x (i.e. fixed); measured without error
  - you manipulated/controlled the x-axis
  - for every value of x, you might have a bunch of y values
- Model II
  - measured a bunch of x variables and measured a bunch of y variables
  - every value of x probbaly has one value of y
  - measured with error
  - in R: use lmodel2 package to use RMA to estimate slope for model II
- is the model I vs model II slope differences an issue for multiple regression as well, or is this less of a worry for those slopes?

**Warning for Regressions**
- do not extrapolate past your regression

