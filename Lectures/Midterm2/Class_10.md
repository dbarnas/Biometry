# Biometry Class 10-01-2020

**Homework**
- snake density would have been masked by the other variables. in 3 dimensional space, snake density may have been colinear with the other variables, but that's not something we would have seen in a 2 dimensional reduction. the effect of snake density may have been masked by the other independent variables, so by itself we didn't see a relationship.  in the multiple regression, we were able to tease apart the effect of the other variable (shrub) and see an effect by snake density.
- if you want to know if height and surface area and volume is different across sites, you do an anova, not a multiple regression, because it's categorical (because of the sites) but you can't look at all three of those things at the same time. so you can see how height differs by site and then how surface area differs by site and then how volume differs by site

**Housekeeping**

**Quiz on Tuesday**
- on ANOVA
- from last tuesday's lecture and today's lecture
- lectures 9 and 10
- know both interpretations of random and fixed factors (old school and new school)
Problem set 4 is up now
- all on ANOVA
- Due October 13
Paper up now (32 pages) for lecture 12
- fairly easy read on Mixed Models

**Reporting Stats**
- think about sig figs
- F-value: 1 sig fig is usually enough, 2 is pretty good, Casey usually reports 3 sig figs
- p-value: Casey also generally reports 3 sig figs; though, for super low p values (anything lower than 0.001) we don't care as much. in this case we would usually report as p<0.001 if less than 1 in a thousand chance you're wrong
- don't state a pattern if the results are not significant because you don't actually have a pattern
  - however, if you have a p-value of like 0.06 or 0.07, you could claim that is "marginally significant" or "marginally not significant" and then still interpret it and give trends, but cannot firmly say there is significance
  
**One Way ANOVA R code**
- notes in code

**How do we test for difference among means?**
- we can see that there is a difference between tidal height, but if we have low, middle, and high tides, we don't know where that difference is.  easier if only two factors, but three or more, we can't be sure where the difference is
- do post-hoc tests
  - tests all possible differences between the levels
  - there are some issues with doing these multiple comparisons
- planned comparisons (a priori contrasts)
  - better to plan in advance how to parse out these differences
  - better and more powerful than just an anova but hardly ever used

**Problem of multiple comparisons**
- if we have 5 levels in our treatments, we'd have to do 10 individual pairwise comparisons of means.
  - in a test we have a 5% chance of being wrong. but in 10 tests, we get a type I error for each test and the more tests we do, the more our error goes up. as it is, doing 10 tests, our type I error is 0.4 (4%) because we have a 5% chance of being wrong for each test

**Multiple Comparison tests:**
- Bonferroni adjusted pairwise tests (eg t-tests); Multiple comparisons: **Bonferroni correction**
  - least powerful
  - most conservative
  - do multiple t-tests for each pair
  - conservative correction:
    - divide the desired level of Type I error by the number of comparisons
    - New critical P-value = alpha / c
    - alpha = 0.05
    - number of comparisons (c) = 10, so the new critical p-value for an individual comparison is 0.05/10 = 0.005
  - if you still get a significant p-value, then no one will argue with you, but if you get a p-value between 0.05 and the new critical p-value, you might think you have no significant difference when there may be one (Type II error)
- **Tukey's HSD (Tukey's Test)**
  - honestly significant difference
  - much more common
  - does some magic. the tukey's test is weaker than an anova, but it's the strongest multiple comparison test
  - still might find no difference between our levels even if there's a difference in our anova, because it is weaker, but generally, it's pretty good
  - diff tells us the difference between each group
  - p adj is our p value if the difference is significantly different
  - visually represented with bars and letters
    - different letters are significantly different; shared letters are not significantly different
    - with just a few factors, not too bad
  - focus more on the graph and look at the effect sizes. sometimes we relay too much on the magic of p-values being arbitrarily set to 0.05.

**Planned comparisons**
- also called "contrasts" or "a priori comparisons"
- focus only on the interesting and logical compairsons
- can also lump things/levels together
- have to be orthogonal (meaning the tests are independent of each other)
  - ex. shouldn't compare group 1 to group 3 and then compare group 1 and 2 together to group 3
- examples
- does educational level affect income?
  - four levels/categories
    - no HS degree
    - HS degree
    - some college
    - college graduate
  - specific hypothesis (a priori)
    - H1: college graduate > some college
    - H2: any college experience > no college
      - lumping groups together. cannot do with a pairwise comparison
- Step 1: check assumptions
  - normality and homogeneity of variance
- Step 2: run anova (but could skip this because we don't really care about the anova here)
- coding the contrast
  - we have four levels (in our ex. above) and we're going to assign a coefficient to each level
  - row of coefficients must sum to 0
  - in R: must use numbers between 0 and 1
    - 1 1 -1 -1 (compares the 1st 2 groups to the second 2 groups)
    - 1 -1 0 0 (compares the 1st and 2nd groups and don't care about the other two, so we code them with 0's)
    - 1/2 1/2 -1 0 (compare the combination of groups 1 and 2 to group 3)
- Step 3: test contrast hypothesis
  - H1: college grad vs some college
    - no significant difference
  - H2: college vs no college
    - not significant but a lot closer than the first test, so there is some relevance there
  - often only report the results of the contrast and not of the anova if you did get a significant difference with the contrast
- make sure tests are orthogonal (independent)
  - at most, can have p-1 contrasts
  - if non-orthogonal, then have to Bonferroni correct
  - can get value difference between treatments and multiply together and should get a value of 0
  
- Statistical purist: shouldn't let your data inform your hypotheses
- In Practicality: sometimes after you look at your data, you may be inspired to try a Tukey Test and check out new comparisons
- DON'T just do the test that gets you to the p-value that you want ("p hacking")


Next Time
- Nested ANOVA
- Two-Way ANOVA


