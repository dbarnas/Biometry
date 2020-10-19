# Biometry Class 10-06-2020

## Quiz today

### Housekeeping
- Read the paper (long one) by Thursday
- Problem Set 4 due Tuesday next

GLM:  
- y = mx + b + error
  - mx + b is the model
Anova  
- y = u + alphai + error
  - where the u (overall population mean) + alphai (effect if ith treatment or group (u - ui)) is the model

**Two-way ANOVA**
- Two factors (2 categorical predictor variables)
  - Factor A (with p groups or levels)
  - Factor B (with q groups or levels)
- Crossed design (= orthogonal)
  - every level of one factor is crossed with every level of the second factor
  - if not every level is crossed with every other level, then do a **nested** anova
- Greater efficiency
  - can answer two questions with one experiment
  - test effects of multiple predictors on a dependent factor
  - test statistical interactions

**Linear model (two-way anova)**
- yijk (any given data point) = u (mean) + alphai (effect of factor A) + betai (effect of factor B) + (alpha*beta)ij (interaction term; effect of interaction between A and B) + error
- can test the whole model, but also can test the effect of just factor A and just factor B

**ANOVA table**
- degrees of freedom are the same as a one-way anova for each independent factor
  - df factor A = p-1 (# levels - 1)
  - df factor B = q-1 (# levels - 1)
- df for the interaction term is (p-1)*(q-1)
- df residual/error is pq*(n-1)
- interaction null hypothesis: no interaction between predictor factors
  - p < 0.05 shows significant interaction
- Look at test of interaction first, THEN determine whether to interpret main effects
  - no interaction if roughly parallel lines
  - different slopes means interaction
    - non intersecting: can still interpret main effects
    - intersecting: do not interpret main effects
  
**Example**
- marginal mean:
  - could get the mean of all densities for each season
  - or could get the mean of both seasons for each density
  - both are marginal means
- grand mean
  - the mean of all data points. or the mean of our marginal mean
- SSseason or SSdensity
  - qn*sum((yi-bar - ybar)^2)
  - yi-bar is the marginal mean (of either the densities or the seasons)
  - y-bar is the grand mean
- SSerror
  - sum(sum(sum((yijk - yij-bar)^2)))
  - yijk is each data point
  - yij-bar is the mean of the season-density intersection
    - on the slide's table, we're only seeing hte mean of the 3 replicates for each season-density intersection

**Interaction**
- null hypothesis: there is no interaction between factor A and factor B
  - "their effects are additive" meaning we can look at the effect of factor A and then add in the effect of factor B and look at the combined effects because they are independent/orthogonal
- SS(AB)
  - n*sum(sum(yij - yi-bar - yj-bar + ybar))

**Testing effects**
- assuming all fixed factors:
- roughly parallel lines (about the same slope) = no interaction
  - means the relationhips of the data betwen both factors is about the same
- if the slopes are not the same, there is a significant interaction
  - in this case (with non-overlapping lines), we can still interpret effect of season
  - interaction of magnitude (where lines don't intersect)
    - dependent on one another but each still have individual effects
- significant interaction, where lines cross each other
  - interactino of direction (where lines do intersect)
  - do not interpret main effects; cannot interpret the effect of season or density because it depends on which density or season we're looking at, respectively
  - the interaction of A and B is hiding/masking the effect of each
- always plot the data before moving on to see what you're working with and to help you with interpretations

**Assumptions**
- look at residuals from the model and see if the residuals are normal, homoscedastic, and independent
- all factors are fixed factors

**Nested ANOVA**
- use to account for subsamples nested within replicates
- if nesting is not acknowledged, these designs are pseudoreplicated
- variation is partitioned among hierarchical levels
- all levels of one factor are not present in all levels of another factor
  - ex. counting seeds for different flower individuals in different temperature treatments. you don't have the same flower for level A, B, and C, so B (temperature treatment B) has three different levels (flowers) than A, and the seed number would be our sample replicates
  - ex. regions along CA coast
    - each region has three sites which aren't represented at the other regions
    - multiple transects at each site that also aren't represented across sites/regions
- our error term is always for the next level down, and we'll get the error for every level, where each error term is for the average of each level below
- Q: do we care that/does it matter if the transects are different between sites in one region or that the transects are different between regions?

**Partitioning total variation**
- Factor A: SS(A): how much variation there is among all level means in factor A
- Factor B(A): SS(B(A)): how much variation there is among all B means within each level of A
- Residual/Error: SSresidual: variation among replicates within each B(A) <- B is nested within A

**F ratios**
- Factor A: F = MS of factor A / MS of the nested factor B(A)
  - df = p-1 (p = # levels in bigger factor)
- Factor B(A): F = MS B(A) / MSresidual
  - df
  
- example
  - test teacher effect with nested anova
  - when you graph, you don't take the standard error of all scores for school A. you use the standard error for teacher a and then use the standard error for teacher b
  - want to make sure we get our within group variation figured out first

Power
- more replication gives you more power
- but in nested ANOVA there is replication at various levels
- good to think about it before doing an experimental design: where do you need to have that replication?
- if you have nested factors wihtin your treatments, you need to replicate the nested factor, not the subsamples
- make sure your replication is where the most variation is (whichever level will have the most variation)
- don't want to get a bunch of replicates that aren't helpful if variation is low

Variance component in nested design
- tells us how much of the total variation of our model is explained by each factor, the interaction term, and how much isn't explained by our model
- in this case, Location didn't explain much, but region did. so we might not need to sample more Regions because what we sampled already explains a lot, but we could sample more Locations
- R will calculate the var. comp value, but to get percentages explained, we have to add up those values and then divide each value by that sum.



