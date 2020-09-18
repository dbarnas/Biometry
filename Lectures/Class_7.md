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
  - wording: x predicts y

**Linear models**
- response variable (dependent variable) = model + error
  - on the y axis
  - one or more predictor (indpendent variable(s))
  - error: component represents the part of hte reponse variable not explained by our model
- predictor variable
  - on the x axis

**Linear Regression**
- Purposes:
  - Description: Does x explain y?
  - Explanation: How much of y is explained by x?
  - Prediction: Predict y values from x values we may not have measured yet, and evaluate precision of those estimates

**Simple Linear Regression Equation:**
- y = beta-naut + beta-one * x + epsilon
  - beta-naut = y-intercept
  - beta-one = coefficient of slope
  - epsilon = error
  - equivalent to y = mx + b
- step 1: calculate mean of x and mean of y
- step 2: calculate deviations from means of x and y
  - for every data point, we'll have how far away it is from the x mean and how far it is from the y mean
- step 3: calculate xy deviation cross-products
  - sigma((x - x-mean)(y - y-mean))
- step 4: calculate slope (beta-one)
  - slope = sum of cross products / sum of squares for x
  - sum of squares for x = sigma((x - x-mean)^2)
- step 5: solve for intercept (beta-naut)
  - y-mean = beta-naut + beta-one * x-mean
  - rearrange equation to solve for intercept

**How well does our equation from our sample represent the population?**
- sample equation: y-predicted = b-naut + b-one * x
- population: equation: y-predicted = beta-naut + beta-one * x + error

**Slope tells us how much x affects y**
- if the slope is indistinguishable from 0, then x has no effect on y

**Hypothesis testing with linear regression**
- two main hypotheses can be tested:
  - H-naut: beta-one = 0
  - H-naut: beta-naut = 0 (uncommon)

**F-ratio statistic**
- = MS-model / MS-error
- MS = SS/df = variation (MS == mean square)
  - need to know degrees of freedom
- The F distribution
  - F = MS1 / MS2
    - need to know the degrees of freedom of the model and of the error (2 degrees of freedom)

**Using Ordinary Least Squres (OLS)**
- used to get the variance in our model to get the best fit line for our model
- if we took every data point (every y value) and subtracted the mean, and squred it, we'd get the sum of squares.
- y-hat is our expected y. for any given x, what do we expect the y to be? that's y-hat
  - however much y-hat differs from the mean, that's how much our model explains
  - and then however much the data point differs from y-hat is unexplained by our model (error) (unexplained variation) (residual)
- Analysis of Variance slide table
  - degrees of freedom
    - for a regression: df = 1 always
    - residuals: df = n-2
- F-ratio of about 3 or higher, that's usually significant
- given the f-ratio with both the numerator and denominator degrees of freedom, what's the probability of getting that f-ratio by chance? 
- r-squared: coefficient of determination
  - measures explained variation
  - simply the square of correlation coefficient, r
  - proportion of variatin in Y explained by linear relationship with X
  - if 0, x doesn't explain y at all
  - if 1, x perfectly explains y
- want to report the F and p value, and the r-squared value to tell the strength of that correlation

**Assumptions of Linear Regression**
- Parametric assumptions:
  - normality (y is normally distributed for each value of x)
    - for each value of x, we find every value of y and see if those y values are normally distributed
    - difficult. we often have only one y for each x
  - homogeneity of variance
    - for every value of x, is the spread in the y data the same?
  - independence of samples
  - linearity between y and x

**Residuals**
- essential
- check normality of residuals, instead of original data!
- difference between observed value and predicted value (y - y-hat)
- studentized residuals = residual / SE of residuals
- check for homogeneity of variances
  - when we plot predicted  y against residuals: what we want to see is no pattern (even variance of y along x)
  - if you see a pattern, you can usually just transform one of the variables
    - but if you do, remember to label your axes appropriately when you graph later (ex. log(y))
  
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

