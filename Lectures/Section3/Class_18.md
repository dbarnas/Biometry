# Biometry Class 11-5-2020

### Paper Presentation  
November 17, slot 6  
3-5 minute informal presentation. Talk through it, no powerpoint

1. What is the question the paper is trying to answer?
2. What is the design of the experiment?
3. What stats did they use to answer this question?
4. Do you think their stats were right?


### Problem Set 7 due next Tuesday, 4 questions, all covered in today's lecture

**Analysing Frequencies**
- Chi-square and G-tests
- dependent variable is categorical
- if two categories, a binomially distributed variable
- if > 2 categories, a multinomially distributed variable

**Types of Frequency Analyses**
- Goodness of Fit tests
- Tests of Independence (Contingency Tables)
  - goodness of fit and tests of independence are set up similarly but interpreted differently
- Log-Linear Models

**Single variable goodness of fit tests**
- Chi-square tests; G test
- design: 
  - one variable wiht >= 2 categories
  - dependent variable is the counts (frequencies) in each category
- expected frequencies in each category calculted from predicted proportions

**Chi-Square Test**
- Example: chi-square test for sex ratio of senorita fish
- H-0: equal sex ratio
- expected f (frequency) = total expected p (proportion) times total observed f (the actual number of fish you counted)
- double check that your total expected frequency equals your total observed frequency
- chi-squared (X2) is like an f statistic, in that you aren't squaring anything or taking the square root of anything
  - sum of ((observed minus expected)squared) divided by expected
- get the p value the same way we get the f and t. we compare our chi-squared value to the chi-squred distribution
- each level of degrees of freedom has a slightly different shape of chi-squared distribution curve, and similar to f and t, you compare your chi-squared value along the correct distribution, with p values on the y axis and chi-squared values on the x axis to see if your value shows significance or not

**note** that a likelihood ratio test is actually different from a true chi-squared test.  LRT's use the chi-squared distribution (by chance), but calculates the chi-squared value differently, so not actually chi-squared but called chi-squared sometimes

**G test**
- G = 2 * sum of each observed times ln(observed/expected)
- fairly new, not as commonly used as chi-squared
- the example gave us the exact same p value
- sometimes G values fit the chi-squared distribution better than a chi-squared value.
  - slightly better, but almost always going to give us the exact same answer, or very close
  - so use either for your statistics unless p value is actually significant with one and insignificant with another, in which case use G

**Tests of Independence / Contingency Tables**
- one more dimention to a goodness of fit test
- design: 
  - >= 2 categories crossed with >= 2 other categories
- observed frequencies (counts) entered into each cell
- example:
  - tests whether you find dead trees depending on which habitat you look in
  - 3 categories of one factor crossed with 2 factors of another factor
- like an ANOVA, looking at the interaction of these factors, seeing if one factor depends on the other factor
- if the two variables (rows and columns) are **independent**, then the expected probability of them occurring together is just the product of their independent probabilities
  - P(AB) = P(A) * P(B)
- null hypothesis is that they are independent of each other
- p < 0.05 means they are not independent of each other

**on the problem set, we could just calculate these by hand instead of in R**
- there's a package and function where all we have to do is input our frequencies and say G test and it spits out oa p value if we want to go that way

**Why G tests are better than Chi-squared**
- multiple G tests can be summed together
- like in ANOVA, can partition a total G test into separate G tests
  - example:
    - measure sex ratios at multiple locations
    - can combine all our data from all sites and do G test on that
    - but can also do G tests for each site and compare across sites
- G test additivity
  - G total: do the data fit the model?
  - G h (heterogeneity): do different sites have different sex ratios 
    - H-0 heterogeneity: the ratio of wild-type to pale-eyed is the same across 
  - G p (pooled): 
- we use the G-t to get to the G-h, but people don't usually report the G-t


**Log-Linear Models in R**
- always use family = "poisson" for frequencies
- important to set up your data (excel sheet) the right way for the code
- model
  - frequency as our dependent variable
  - only putting interactions in our model
    - season:fruit (effect of treatment) (whether they produced fruits or not varies across seasons)
    - treatment: fruit (effect of treatment) (whether they produced fruits or not varies across treatments)
    - season:treatment:fruit (effect of season-treatment interaction) (whether they produced fruits or not varies across season-treatment interaction)
- anova(model, test="Chisq") but you aren't actually doing a chi-squared test here. you're doing a G test, but you're telling R to comapre to the chi-squared distribution

- simple G test:
  - GTest() function and specify the expected probabilities p=c(#, #, #)








