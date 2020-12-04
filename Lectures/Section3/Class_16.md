# Biometry Class 10-27-2020

**Housekeeping**
- PS6 due Tuesday (3 questions)
- Paper:
  - in my field
  - 3-5 minutes
  - "here's what they were looking at", "here's the stats they used", "here's what they did well or maybe did differently from what i would have done"
  - 11/12 and 11/24
- Mid-semester check in
  - anonymous form (check email)

**Linear Models**
- General Linear Models: assume normality
  - could use OLS (ordinary least squares) or MS (maximum likelihood)
- Generalized Linear Models: can use other dsitribtions (don't assume normality); must use MS
  - looking for the parameter value that gives us the maximum possible likelihood (log(likelihood) on the y axis)

**Assumptions of a general linear model**
- normality (residuals/error)
- homogeneity of variance
- linearity
- independence of replicates

**Assumptions of a generalized linear model**
- linearity
- independence of replicates

**Generalized Linear Models**
- data may be right or left skewed
- binomial
- guassian (normal)
- gamma (often fits well for biological data)
- poisson (often works well)
- incorporates two functions into the linear equation
- Link function:
  - describes the relationship of the observations to the predictions
- Error distribution: 
  - describew how the variance depends on the mean

**Keep the chart handy for links to try fitting to our data**

**Generalized linear model in R**
- lme4::glm()
- glm assumes all factors are fixed
- glmer used for models with random effets/factors
- model<-glm(y~x, family="Gamma"(link="inverse"))
  - specify what family and put in the link
  - could leave link blank like link="" and R will put in the default
- test different functions to figure out which looks the best for you
- could use the model with the lowest AIC value, but this isn't always the best test. tells you if your distribution is better than normal, but not necessarily telling you if your model is better than another kind of distirbution
- must use "Anova" to get p-values
- same basic set up as anova's but using glm and glmer, and specify the distribution
  - can look at the best distribution in your qqp plot

**Transforming vs GLM**
- usually transform first and use lm() becuase takes less computing power and often get fewer errors in R using lm than glm, but technically could use glm for any model you would also make with lm







