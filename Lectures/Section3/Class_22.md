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











