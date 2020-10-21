# Biometry Class 10-20-2020

Midterm on Thursday

Class on Tuesday, but no Lab portion (Casey's on Jeopardy!) ABC at 7pm

Q/A
- in nested models, you don't typically have an interaction in your model
- which ANOVA to use
  - how many factors are there and what are they?
  - are the factors fixed or random or nested?
  - build your model off of that
  - the tricky part can be determining what's fixed and what's random
  - have to figure out what Casey was thinking when writing the question
  - if Casey asked:
    - asked us what's the effect of EMF. didn't ask us to test anyting about the donors, so he was probably thinking donor was a random factor
  - for our factors:
    - are they fully crossed or are they nested?
    - crossed: put in the factors and get all the interactions included
    - nested: make sure we code correctly to get things nested appropriately.
- look into how to get effect sizes
  

## Power Analysis

**Power**
- probability of detecting an effect if it exists
- probability of rejecting a false H0
- 1-beta, where beta is the probability of type II error
- we have the arbitrary alpha of 0.05, where we accept a 5% chance of being wrong
- but we don't have that for beta
- generally, higher power is better and lower power is worse, but we dont' have that critical threshold for what is good or bad
- typically describe analyses as having a certain amount of "power", rather than talking about their "accuracy", but the terms may be synonymous
- power = what are your chances of getting the right answer, if the right answer is that there's a difference

**What affects power?**
- critical p values (alpha)
  - higher alpha = higher power
- effect size
  - bigger effect = higher power
  - if the means of our two groups are close to each other, we either need to have not a lot of variance or a high sample size
- replication
- variation
  - background variation: unexplained variation among experimental units
  - greater background variability = less likely to see effect
  
**When to use Power Analyses**
- a priori (designing an experiment)
  - sample size needed? how many replicates?
  - how to partition money, resources, etc?
- a posteriori
  - is a non-significant result interseting?
  - given the effect size, how likely were you to detect it if there was a difference?
  
**Power Analysis**
- Power is proportional to ES (effect size) and alpha and the sqrt of our sample size and the inverse of our standard deviation

**a priori power analysis**
- if we know: 
  - what power we want
  - what effect size we wish to be able to detect if it occurs
  - background variation (from pilot study or previous study)
- then we can determine:
  - sample size needed

**Example: does fish predatin affect mudflat crab abundance?**
- want to detect 50% increase in crab numbers due to caging
  - ES = 50%
- want to be 80% sure of picking up such an effect if it occured
  - power = 0.80
- two treatments: cage vs cage control pilot study:
  - number of crabs in 3 plots (only 3 replicates)
  - variance was 19 (s^2 = 19) = average variance within each treatment
  - mean was 20
- how many replicate plots required for each treatment?

**Effect Size**
- how big is big?
  - what size of effect is biologically important?
  - ho wbig an effect do we wnat to detect if it occurs?
- where from?
  - biologicaly knowledge/intuition
  - previous work/literature
  - compliance requirements (e.g. water quality)
- implications
  - what are the implications of doing the study and not detecting a true effect vs not doing the study?
  - how bad would it be if you accepted the null but should have rejected it 

**a posteriori power analysis**
- do this when accepting the null
- is our conclusion that the null is true reasonable?
  - we know: 
    - sample size
    - effect size (we can calculate the difference between treatments)
    - background variation (s.d.) (we can look at the residuals in our models or calculate the standard deviation)

**Cautionary Points**
- no point in doing a power analysis if you already found statistically significant results
  - you already rejected the H0, so your power is high enough
- are you interested in interactions or main effects?
- low power does not mean a poor design
  - especially with demonic intrusion
  
**How to do Power Analysis in R**
- www.statmethods.net/stats/power.html
- need pwr package
  - pwr.t.test(n = , d = , sig.level = , power = , type = c("two.sample", "one.sample", "paired"))
  - n = sampel size
  - d = effect size
  - type = type of t-test (choose one)
  - enter 3 of the 4 things and leave one blank and R will calculate the 4th thing for you
  - variation is built in to the effect size (d)
  - for the t-test it would be the pooled standard deviation


