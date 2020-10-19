# Biometry Class 9-10-2020

### Null hypothesis testing; Confidence limits

Confidence:
- the mean is a meaningless number, what we want to knoow is our confidence that the mean is representative of the population

**Central Limit Theorem**
- As sample size (n) increases, the means of samples drawn from a population of any distribution approach the normal distribution
- the distribution of many means will always be a normal distribution (works with larger sample sizes)
- if the sample size is really large, if we took a bunch of means of our samples, we would get a normal distribution of means
  - and we can use that distribution of means to make inferences now that we have a normal distribution (even if our original data not averages wasn't normally distributed)
- at the center of our normal distribution of means should lie the population mean
  - we know then that if we take the 95% confidence interval of our sample mean, there's a 95% chance of our population mean being within that range
- if we take the standard devaition of those means, we get our standard error
  - s.e. = sigma sub y-bar = standard deviation / square root of n
  - s.e. tells us our error in using the sample mean to estimate the population mean
- **will need to explain the CLT on the midterm**
- Questions
  - is it not useful for all datasets, though, just datasets with pseudoreplicates? or data we just don't want to average?
  
  
**Estimating Means**

**Bootstrap Estimation**
- use our sample to create a distribution by randomly subsampling the original sample
  - usually with the same sample size
  - sampling with replacement means the same observation can be sampled more than once
    - therefore each bootstrapped sample mean will be different
- if we do this enough times, we should be able to get the full distribution of means
  - out of 1000 bootsrapped means in order, tehn the population mean should be sample 500 (right in the middle)
  - 95% CI is sample 25 to samples 975 (cut off 2.5% from the low end and 2.5% from the high end)
- Questions
  - Why is this useful instead of using your entire sample?
  - listen back during the "break for questions"

**Jackknife Sampling**
- better with a smaller sample size
- like bootstrapping except you remove one observation at a time
- use full sample with 1st observation removed, then only 2nd observation removed, etc
- then calcuate the mean form your sample of means

**Ordinary Least Squares (OLS)**
- assumes a normal distribution
- get all the deviates, square the deviates, sum the squared deviates (sum of squares), out of all the possible means, the mean where the sum of squares is the least (the minimum), is our OLS mean
- identifies parameter estimate that minimizes the sum of squared differences between each value in a sample and the parameter
- to get the range of sum of squares, you use every possible mean of your sample (within your range) to get each set of deviates to square and sum. 
- we can try all the means, and the one that is the most likely population mean is the one with the lowest sum of squared deviates/ minimum squared deviates
  - take all possible means
  - calculate the squared deviates
  - where the sum of squares is minimized is where half the data is on one side of the mean and half the data is on the other side
  - so i think to get OLS, you would use every number within your data range as a "mean" estimate and then you'd get deviations from each mean, which is why on the parabola you have those super far away points, because most of the data isn't going to be that close to the most extreme low and high value, but at one particular number/mean, the data will be close enough to have that minimum value. so when we graph the regression line, we're basically plotting the residuals (i think) and drawing a straight line through those residuals to get our slope. and with that ols mean, we're assuming the residuals will be minimized for each data point or at least the data set so our slope is the most representative of our data
  - and residuals = deviations

**Maximum Likelihood (ML)**
- does not assume a normal distribution
- more in baysian and mixed models

The above methods help you put confidence limits on your sample mean in relation to the population mean. put confidence in your sample mean compared to the population mean

- How reliable are our estimates
- How probable is it that the difference between observed results and those expected on the basis of a hypothesis are due to chance alone?


**Null Hypotheses**
- "There's no differences in these groups"
- vs Alternative Hypothesis that says "There is a difference in these groups"
- we can never prove an alternative hypothesis. there will always be a small chance of confounding effects, that our treatment alone gave the result we saw
- but we can disprove a null hypothesis. we can see when there is not "no effect", which points to an alternative hypothesis
- we cannot prove, but we can disprove.  By disproving a null hypothesis, we gain support for our alternative hypothesis

**Possible outcomes of tests of null hypothesis**
- Type I Error: False positive. Reject the null hypothesis, but there was no effect
- Type II Error: False negative. Accept the null hypothesis, but we're missing out on a real effect

**Type I Error**
- P(Type I error) = alpha
- by convention, not law, alpha = 0.05 (5%)
- the 5% in the tails (2.5% on the low end and 2.5% on the high end) of the distribution comprises the rejection region, and the range comprising 95% of the outocmes comprises of the acceptance region
- When we reject Ho we say that the sample is significantly different form what Ho suggested
- if we say p < 0.05, there is a small chance we made a type I error. but if we say p < 0.0001, there is a very tiny small chance we made a type I error

**One vs Two-tailed tests**
- Two-tailed: type I errors could be in the 2.5% low end or 2.5% high end
  - use unless you have a priori reason to expect one-tail
- One-tailed: when there's no way the type I error could be in one of the tails, we assume the 5% error is at one of the tails
  - much less common

**Type II Error**
- beta = type II error rate
- trade-off between alpha and beta
- less commonly reported
- if we accept the null, how sure are we about that result, especially if there are important consequences?

**Power of a test**
- power = probability that we correctly accept the alternate hypothesis Ha
- power = 1 - beta
- decreasing alpha increases beta and thus decreases power
- p (probability) (type I error: rejecting H0 when we shouldn't) = alpha
  - by convention, alpha = 0.05 (5%)
- beta = type II error rate: accepting H0 when we shouldn't


**Guidelines for making and interpreting null hypotheses**
- Just because we accept something, doens't mean it's true. we have to put a probability on that. we say we failed to reject the null, but doesn't mean the null is true
- significance does not equal importance
- p-values
  - don't say how different the groups are. we need effect sizes for that
  - do not equal replicability
  - do not equal variability
