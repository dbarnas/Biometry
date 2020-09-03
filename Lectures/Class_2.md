Biometry Class 8-27-2020

**Probabilities**
- What's the probability that our result is significant (likely correct) vs just due to chance?
- What is the prob of two separate events occurring?
  - P = P(A) * P(B)
  - multiply their independent probabilites together
- sum of probabilities of all possible outcomes equals 1

**Binomial distribution**
- binomial = two possible outcomes
- don't need the same chance of getting either outcome.
- only used for discrete variables (ex. either Head or Tails, Yes or No)
- assumes possible outcomes/events are independent of each other
  - flipping a different coin every time we flip for Head or Tails
  - observing a different organism every time to determine each subsequent outcome
- need:
  - n (number of trials)
  - p (probability of each event)

**Probability distribution**
- Normal
- Exponential
- Lognormal (often fit biological data)
- Poisson

Frequentist vs Baysian
- Frequentist: based on determining the probability of obtaining the observed data
  - most often used in science
  - based on the "magic number" of 95% certainty

Poisson distribution
- the probability of some independent event is low (rare); not 0.5 (50%)
- used often in biology
- ex. the probability of finding a non-germinating seed of a plant produced by a seed company. you'll find some but on rare occassion. was less than 50% of the time
- discrete variables (often counts)
- assume possible outcomes are independent
- mean must be small relative to possible number of events (number of non-germinating seeds is very small compard to number of seeds we observed)
- need:
  - n (number of trials)
  - u (mean) = # occurrences / total number of samples

Normal distribution
- need:
  - n (number of trials)
  - u (mean) = # occurrences / total number of samples
  - sigma (standard deviation) 
- if you change the mean, you move the curve right or left on the graph (location)
- standard deviation controlls the width of the curve
- number of samples controls the height of the curve
- "significant" if 95% of the items fall between u +/- 1.96 standard deviations
  - what do 95% of the treatment group look like and what to 95% of the control group look like and do those overlap?  if they do, they aren't so different.  if they don't we can assume there is a difference

Standardizing curves
- look at curves from different scales on the same scale
- Z-score
  - often with multivariate analyses
  - each independent value has its own z-score so the different variables on different scales can be compared on the same scale

**Descriptive statistics**
- Estimation: determing the parameters (for normal: mean and sd) of a frequency distribution
- statistics of location - position of the curve (based on mean)
  - mean
    - arithmetic mean (i.e., the average)
    - weighted average (can assign weight/importance to certain data points and then instead of dividing by N we divide by the sum of all the weights)
    - geometric mean - more useful when variables are distribued on a log scale
  - median
    - the value of the observation numer (n+1)/2
  - mode
    - the most frequently occuring value in a sample
  - normal distribution: mean, median, and mode are all at the same place
  - non-normal distribution
    - mean is heavily influenced by outliers
    - median isn't really influenced by outliers
    - mode is even more close to the hump of the curve
  - which to use?
    - mean often preferred (uses all the data, but affected by outliers)
    - ordinal (ranked) data: median better than mode
    - skewed distributions: median may be better than mean
- statistics of dispersin - width/breadth of the curve (based on sd)
  - range = max - min
    - quick and easy, but uses very little information about the dataset
  - better used to tell us how variable are the data - how far away are the data from the mean?
  - a deviate = each value - mean
    - but the mean of deviates would always be 0
  - squared deviations
    - sum of squares or SS = (sum of deviates)^2
  - variance
    - average of the squared deviations (aka the mean square, MS)
    - sum of squares divided by the sample size
  - standard deviation = square root of variance
    - sigma (sd) = square root of variance (sigma squared)
    - so now the units for sd are back in the original units, rather than squared units

**Population statistics vs Sample statistics**
- sample variance is calculated slightly differently, instead we divide by (n-1) to estimate the population variance more closely than dividing by n.
  - why? Degrees of Freedom, df, n-1
    - the number of observations that are "free to vary"
      - ex. if our population size is 100, then there are 99 samples that are free to vary. because if we take 99 samples and we know the average, then we know the 100th sample value.
      - we usually underestimate the variance but if it's n-1, we are closer to the true variance
      - almost always n-1 but no rare occassions it'll be n-2 (like with regressions)

**Standard Error of Mean (SEM)**
- you can reduce SEM by replicating more
- variance divided by the square root of sample size
- used to tell us how confident we are that our sample mean is reflective of the population mean
- standard error bars: "we measured the sample mean, and we're pretty sure the population mean falls within this range"
  - does not tell us variance of the data.

**Standard Deviation**  
- used if we care about the distribution of the data, which is used sometimes, but much less often then standard error
- usually when we plot means we want to show our confidence in the mean (which is SE), but SD used occassionally










