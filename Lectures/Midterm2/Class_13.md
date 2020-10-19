# Biometry Class 10-13-2020

## Mixed Models

**Why are we talking about fixed and random effects so much?**
- When setting up an experiment, we need to know what question we want to answer, and the way to answer that will be through either specific manipulations or specific measurements. Teasing apart the difference of when to use fixed vs random effects allows us to set up our experiment effectively for out question and avoid pseudoreplication.
- setting up a model with different fixed and random effects will change the model, so we must know what can be considered or should be considered fixed vs random vs not at all
- changes how you collect your data and how you interpret your data
1. mainly to account for pseudoreplication
2. affects how we design our experiment, plan for our measurements
3. will change our interpretation
4. will change how we even test our model and construct our F values
- if fixed factor, testing our MS over the residual
- if fixed and random factors, testing our MS over the interaction
- if you put in a random effect, we don't want to test for it, but we do want to account for the variation
- if we add in random effects that help explain some of the variation, then we reduce residual/undexplained variation, which reduces the denominator in our F ratio, and therefore a higher F ratio

**Fixed vs Random snail example on slide**
- site as random factor:
  - sites are going to be different, and we can account for the natural variation by sampling from multiple sites as random effects
  - if we sample as a random factor, we don't have to sample the whole coast, we can extrapolate and say this is a random sampling along the coast and gives a broad understanding of what's happening along the coast
- site as fixed factor:
  - if we want to know the differences at these specific sites, if they were ecologically important sites, then we would treat them as fixed effects
- will change our test, the way the stats are run, the results we get, and our interpretation
- may depend on our biological intuition of what should be fixed/random for our question

**ANOVA Experimental Design**
- Block Design
- Split Plot Design

**Blocking**
- group replicates in blocks
- usually across space, but may be across time
- usually to reduce unexplained variation, without increasing size of experiment
- used to unconfound effect of treatment from another variable that you know is present and may influence response to the treatment
- if we can account for more variation, then we can test better for the thing we're trying to test for
- most often used as a random effect

**Blocking Examples**
- Completely randomized (no blocking)
  - randomly placed water and control plots
- Randomized block (no replication w/n blocks)
  - one replicate of water and of control plots within each block
  - Treatment is fixed
  - block is random: we're just trying to account for variation in space/time, 
- Replicated Randomized block
  - maximize blocks, minimize replication within blocks
  - some replication within and among blocks (two of each treatment in each block)
  - total degrees of freedom = 23
  - block as random effect, our degrees of freedom are 1 and 5
  - if block were a fixed effect, our df would be 1 and 12
- Replicated Randomized block
  - maximize blocks, maximize replication within blocks
  - the degrees of freedom in our denominator tell us about our sample size. we want a greater df in the denominator for more power
  - would have to get average for each block, then we really only have n=2, vs the other replicated randomized block design where n = 6
  - and if we want to test A, then the randomized block with no replication w/n blocks might be even better because our n = 12, except we don't have any replicates to get us MS-residuals, so we would have to assume there are no interactions between our treatment A and the block.

**Split Plot Designs**
- usually 3 factors, with one partly nested within the others
- 1 treatment is applied to the whole plot
- every level of A interacts with every level of B
- block is confounded with treatment A
- factor C is a block that includes each level of A, often where A is unreplicated because of limited resources
- the block accounts for environmental variation, but we're also using the block to accuoont for treatment variation

**Model Selection**
- How to choose the "best" model
- AIC is generally what is used to pick the best model, but isn't/wasn't always
- used to be an informal rule that if the p value was insignificant (0.25) then we'd say that interaction term is not important and we'd drop it from the model
  - 0.25 is kind of arbitrary
- library(MASS)
  - fullmodel
  - stepAIC() uses your full model to test every iteration of your model to see which fits best
  
**Likelihood Ratio Tests (LRT)**
- compares the model with the random effect in it to the model without the random effect in it
- fits the two to a chi-squared distribution and it spits out a chi-squared value p-value and tells us if the random effect is making the model better for us
- used to ask if our random effect is important/how important it is in our model, whether we want/need to include the random effect or not 
- degrees of freedom = 1
- methods: state which test you did and how you got the p values. ex. "got p values from a likelihood ratio test"

**Unbalanced designs in ANOVA**
- more replicates in one level than another
- often because something went wrong and we lost replicates
- three ways to calculate Sums of Squares (if our design is balanced, all three will give us the same answer)
  - Type I
  - Type II
  - Type III: Marginal or Orthogonal
    - basically ALWAYS use type III if you have an unbalanced design
    - library(car)
    - Anova(model, type="III")

