# Biometry Class 9-15-2020

Midterm next Tuesday
- 1 hour for conceptual
- 1 hour for R
  - coding only up through t-tests

Breakout Room: Why is the central limit theorem essential for estimating population parameters from samples
- if you keep taking a bunch of subsample means, you'll get a normal distribution
- this is important because we don't actually care about the mean of our sample, we care that the mean is representing the mean of the population/what's reelvant for the population
- the basis for a lot of what we do, but not something we'll actually talk about for the rest of the course
- when we go to estimate parameters (mean, errors, etc), this will be a useful essential tool

Fisher's Exact Test

Student's t distribution
- symmetrical, but not identical to normal distribution
- converges on normal distrbution when n>30 (so it's pretty close to the normal distribution)
- (sample mean - population mean) / standard error

Three types of t-tests
- one-sample t-test:
  - the mean of a sample is different from a constant
- two-sample t-test:
  - sampled two populations and want to know if the two means are different or not
- paired t-test: 
  - two samples that aren't independent of each other, and want to know if there are differences while accounting for the independence/pairing of samples
  - ex. testing the same patient before and after a drug. you're testing hte same person, so your second sample isn't independent of your first sample from the same person

t-test assumptions
- parametric
- assume normal distribution
- assume equal variance
- assume independent or specifically paired observations

one-sample t-test
- theta (your H0 constant) is whatever you set it to be
- general form:
  - t = (y-bar - theta) / SE
  - where y-bar is sample statistic
  - theta is parameter value spcified in H0
  - SE is standard error of sample
- don't usually care about the sign of the t-value
- how different is different enougH??
  - if our t-value is outside of the 95% confidence interval, there is less than a 5% chance of our sample statistic equalling theta (reject null hypothesis)
  - while if our t-value was within that 95% confidene interval, the probability of our sample statistic equallign theta is greater than 5% and we cannot reject null hypothesis
  
two-sample t-test (aka Student's t-test)
- used to compare two populations, each of which has been sampled
- H0: mean of pop.A = mean of pop.B
- equation needs:
  - mean of A, mean of B, sample size of A, sample size of B, variance for A, variance for B
- degrees of freedom: 
  - sample size of pop.A - 1 + sample size of pop.B - 1 = sample size A + sample size B - 2
- coding:
  - set up dataframe to be in long form (column for Group and column for variable/numbers)
  - var.equal=TRUE

two sample t-test with separate vaiances (Welche's t-test)
- if samples have different variances and/or sample size are very different
- some people say to just use Welch's anyway, even if you have low variance and similar sample sizes
- coding
  - default in R
  - var.equal=FALSE or don't include at all

paired t-test
- H0: no difference between the paired observations
- need:
  - difference between paired observations
  - standard deviation of the differences
  - df = n - 1 where n is number of pairs
- coding:
  paired = TRUE (saying our two groups are paired together)
- example: 
  - measured plots before a fire for diversity
  - measured the exact same plots after a fire for diversity
  - those plots would be paired
- can only have two time points. can only compare two groups

Evaluating Assumptions of the t-test: Normality
- rewatch over portion of video (~ an hour in, 6:05pm)

Presenting results of t-test in scientific writing
- Methods
  - variables measured
  - how assumptions were checked
- Results
  - state result then put statistics after (t-value, df, and p, then possibly a reference to a figure showing the graphs)

On an exam: he will likely just present us with an experimental design, and then ask us to perform a t-test, but won't tell us which

**Correlations**
- r: correlation coefficient
  - r = 0: no correlation
  - r = 1: perfectly positively correlated
  - r = -1: perfectly negatively correlated
- what is the degree of association, or covariance (how closely they co-vary), between 2 variables?
  - both variables are continuous
- correlation vs. regression 
  - regression: tests for/implies causation
    - there's a determined x and y axis (such that x causes y)
  - correlation: doesn't matter which variable is on the y-axis
    - no hypothesized cause and effect relationship between variables

Variance and Coveriance
- variance: (x - x-bar)*(x - x-bar)
- covariance: (x - x-bar)*(y - y-bar)

Non-parametric correlation coefficients
- best for nonlinear relationships
  - Spearman's rho (commonly used)
  - Kendall's tau (less common)

Spearman's rho
- rank all x values and rank all y values
- for each pair, doing covariance between ranks (vs between the actual data points)
- checks if the ranking of x matches the ranking of y



Kentall's tau
- looks at every pair, and asks if each pair is concordant (if x>y in one pair, is x>y in the next pair? if yes then concordant pair) or discordant (if x>y in one pair, but x<y in the next pair, then discordant pair)


