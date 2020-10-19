# Biometry Class 10-08-2020

### Housekeeping
- Problem Set 4 due Tuesday
- Today: Mixed Model ANOVAs, with Fixed and Random factors
- Midterm Oct 22

**Questions**
- you won't always be able to get orthogonal contrasts, you may have to bonferonni correct to get them all to be orthogonal

**Breakout Rooms**
- My Breakout Room (Group 3)
- CONSIDERATIONS WHEN FITTING RANDOM EFFECTS
  - need at least 5 levels or groups
  - if < 5 levels, may not be able to estimate the among-population variance accurately
  - can be unstable if sample sizes across groups are highly unbalanced
  - determining significance among groups - do you want to get a p value for whether there is significance among the effects
  - mis-specification of random effects:
  - (i) failure to recognise non-independence caused by nested structures in the data e.g. multiple clutch measures from a single bird (pseudoreplication issue)
  - (ii) failing to specify random slopes to prevent constraining slopes of predictors to be identical across clusters in the data
  - (iii) testing the significance of fixed effects at the wrong ‘level’ of hierarchical models that ultimately leads to pseudoreplication and inflated Type I error rates (which model is the best model to use?)
  - F tests can provide a check of model hierarchy using residual degrees of freedom for fixed effects (presumably to test which of multiple models is the best fit)
  - LRT might not give you the hierarchical check to make sure you've nested things correctly, while an F test could
- Questions:
  - what do they mean by hierarchy?
    - maybe to help prove to you that you've nested in the right way
  - What is the LRT (likehood ratio test) used for or why would you use LRT over F tests

- BOR Group 1
  - Fixed effects: the researcher chooses the levels to look at specifically
    - temperatures
    - drug treament doses
    - light
    - pH
    - etc. controlled by researcher
  - whatever results you get from that model cannot be generalized/extrapolated to the population
  - Random effects
    - uses levels found in nature and extrapolate to population because assume random distribution of levels are representative of population
- BOR Group 2
  - ex. when estimating clutch size, the hen IDs are a fixed effect because we can't extrapolate outside of those hens
  - we have our population. and we take a sample from the population
  - with fixed effects, we assume we've sampled the population
  - with random effects, we assume we've only taken a subsample of the population
- BOR Group 4
  - nested: the hens within a woodland independent of hens outside the woodland/another location
  - crossed: testing the hens within the woodland year after year
  - random slopes: take into account the potential differences in foraging effects
  - no one fits in random slopes in ecology but they probably should, but you need really high sample sizes
- Generalized Linear Models
  - used for non-Gaussian/non-normal distributions
  
**Why use random effects**
- you can choose (in many cases) whether you want an effect to be fixed or random
  - except with nested factors, which are often decidedly random effects based on your design
- avoid pseudoreplication. samples are not independent
- account for biological variation (variance components)
- Subsampling population
- Parameter estimation (biologists don't necessarily care about the mean, we want to know the difference in the groups, so the relative mean, vs the exact value)
- Generalize/Extrapolate to unmeasured groups
- To account for variation

**Fixed Factors**
- our "among group" sum of squares increases by and added component due to treatment (alpha-i)
- assume we've included all the relevant levels of our population. effectively sampled the whole population
- no variance components
- no unknowns - have measured the exact effect of a treatment level
- if we ran the experiment again, we'd use the exact same treatment levels and expect the same result

**Random Factors**
- our "among group" sum of squares increases by an added variance component (sigma-a)
- assume we only sampled a subset of a treatment that we care about
- we don't know the exact effect of every level, only the levels we tested
- should use at least 5 levels, but gauge based on your particular system if you need more levels

**Variance component**
- if we measured the vc among groups, it's a factor of the variance component due to a random factor and the sample size of our group
- expected mean squares if both factors fixed
  - if we divide MS-A by the MSresidual, we get an F-ratio for group A, and subsequesntly for group B, and for the interaction
- expected mean squares if both factors random
  - need to divide by the interaction (MS-AB) to isolate the effect of A or B
  - if we want to test the effect of the interaction, we need to divide by the MSresidual
- one fixed and one random factor
  - for our fixed factor, we divide by the interaction
  - for our random factore, we divide by the residual
  - (opposite from if both were fixed or random)
- R tells us to just not test the random effects at all. only get the F-ratio for the fixed effects

**Two-Way Factorial ANOVAs** or more complex ANOVAs (3-way, 4-way, 9-way, etc)
- Model I (both fixed)
- Model II (both random, less common except with nesting)
- Model III (one is fixed and one is random)

**Likelihood Ratio Test**
- tests likelihoods of how well the model fits the data
- get a chi-squared value, not an F value
- a way of saying here's a p value for whether that random effect is important in the model

- new-school thinking:
  - if you care about the random effect, then just make it a fixed effect (as long as it isn't needed for pseudoreplication) because then you can look to see if the slopes are significantly different between the levels of that factor. 
  - if you don't care about the random effects that much, make them random and then you still account for the variance between groups but don't care if the slopes are different
