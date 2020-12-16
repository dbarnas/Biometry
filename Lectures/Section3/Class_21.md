# Biometry Class 11-19-2020

www.csun.edu/SEF
- course evaluations

### Multivariate Analyses

**uses of multivariate approaches**
-	Description: 
  - Combine variables in an optimal way
  - Visualize relationships
    - PCA
    - nMDS
-	hypothesis testing:
  - compare among groups
    - MANOVA (mostly replaced by PERMANOVA)
    - Discriminant Function Analysis 

**MANOVA and Discriminant Function Analysis**
-	>= 2 dependent variables; one or more predictors
-	Same mathematical approach for both
-	Different uses:
  - MANOVA uses all variables
    - Multivariate equivalent of ANOVA
    - Discriminant Function Analysis

**Multivariate data**
-	Centroid
  - Measure of location of multivariate data sets
  -	Represents the mean of all the variables
  -	In multivariate space, the centroid represents the univariate means of each of the variables

**MANOVA: multivariate analysis of variance**
-	Asks: is there a difference in response variables among groups?
-	Why?
  -	Could run many univariate ANOVAs, one for each response variable (ex. 10 ANOVAs for each variable
  -	Increases prob of type I error
-	MANOVA compares centroids among groups
  -	Just like ANOVA, get a ratio of variances
  -	How far is each data point from the centroid? Within groups
  -	Compare the mean of each group to each other. Among groups

**MANOVA tests**
-	Not so hard to get an F value, but hard to get p values
-	H0: no difference among centroids of groups
-	Different measures of a ratio of variances can be used
  -	Wilk’s lambda – measure of how much the total variance is due to the residual (i.e. smaller values indicate larger among group differences
    - Safest approach. Just default to Wilk’s lambda
    -	Report Wilk’s lambda, df, and p
  -	Hotelling-Lawley trace
    -	Uses the sum of squares of the cross products (measure of covariance) to look at covariance among groups over covariance within groups
  -	Pillai trace – ratio of eigenvalues
    -	For really small sample sizes (ex. < 10) and only two groups (ex. site a and site b)

**Relative importance of each variable**
-	Methods to assess relative contribution
  -	Univariate ANOVAs common, but meh. Not a good idea
  -	MANOVA fits a discriminant function and you can examine coefficients. The ones with the highest coefficients are the most important variables (greater weight)

**MANOVA example**
-	Trace metal concentrations in marine sediments 
-	Three sites
-	Variables: Concentrations of 4 metals
-	So we create our linear model and each variable has a coefficient in front of it (like a slope). 
  -	The variables with the highest coefficients are the dominant drivers of those variables at our sites
-	Univariate ANOVA’s give us p values but that doesn’t tell us importance
-	Coefficients (loadings) tell us importance
  -	Coefficients for discriminant function
  -	1 (Eigenvector 1)
  -	Sign doesn’t matter

**Assumptions of MANOVA**
-	Multivariate normality
  -	Normal in every dimension and throughout multidimensional space
-	Homogeneity of variance-covariance matrix
-	No collinearity between variables (r < 0.9)

**Descriminant Function**
- MANOVA linear model
- also used for Descriminant Function Analysis

**DFA: Discriminant Function Analysis**
-	How well does the discriminant function classify data to particular groups?
-	If you find that your DFA is good at classifying groups, then you could take new data, apply the DFA to it, and assign your data into your groups
-	Groups are pre-determined (by you)
-	Can also classify new observations into one of the groups
-	Produces a measure of the likelihood of success of our classification

**Classification and Prediction**
-	3 steps in using classification functions
  1.	Get the coefficients and constant of the classification equation for each group
  2.	Get a classification score for each observation for each group
    a.	Calculated by using the actual values for each variable to solve the classification for that group
  3.	Classify each observation into the group it matches most closely
    a.	This may or may not be the actual group from which the observation came
    b.	You have to know what group the observation goes into. You have to know the classifications already, and then you can see how good the DFA is at fitting the data

**Jackknife to evaluate success of classification**
-	Problem: we classify each observation with an equation that already used that observation (circular logic)
-	Jackknife:
  -	Take one data point out and do the analysis. Then take another data point out and do the analysis
  -	So you take your data point out and fit the DFA and then you take another data point out and fit the DFA again and get your coefficients and see which group your observation goes into.
-	Solution to avoid bias: use a jackknife procedure to derive classification functions
  -	Classification functions determined when the observation is omitted and only 


**R mode vs Q mode Analysis**
-	R mode is like a PCA
  - Association matrix of variables
  -	Create a matrix showing how one variable is related to another variable
  -	How well is one variable correlated with another variable
-	Q mode
  -	Instead of looking at variables, we’re looking at objects
  -	Dissimilarity matrix of objects
  -	The matrix depends on how many individuals we measured
  -	How similar is one fish to another fish (ex.). how similar is each object to the others?

MDS: multidimensional scaling**
-	Another way to summarize multivariate data
  -	Fewer assumptions to PCA
  -	Like PCA, does not formally test hypotheses
  -	MDS works directly on objects (sampling units) rather than variables
-	Why use MDS rather than PCA?
  -	MDS has fewer assumptions
  -	PCA relies on linear relationships among variables
  -	PCA doesn’t perform well with a lot of zeros (like with a benthic analysis for species composition using quadrats)
    -	MDS does just fine with the zero data for unrepresented species
  -	Dissimilarity among objects is often …

**MDS Steps**
1.	Raw data matrix
2.	Transform data, if desired
  a.	Transformations can have very strong effects on final MDS plot
  b.	Can affect interpretation of data
    i.	*No transformation* emphasizes large values
    ii.	*Square root* transformation de-emphasizes large values
    iii.	*Fourth root* de-emphasizes large values more than square root
    iv.	*Log transformation* de-emphasizes large values even more than fourth root
  c.	If you want to emphasize those large values, then you don’t have to do any transformation, but if you want to de-emphasize those large values, then do a transformation. And most of the time, folks do a fourth root transformation
    i.	Fourth root is most common and it’s more common to transform data than to not transform data
3.	Dissimilarity matrix
  a.	Bray-Curtis is the best dissimilarity measure for ecological data with lots of zeros
    i.	Default in R
    ii. no reason to not use Bray-Curtis
  b.	For other data, Euclidean distance and other measures are appropriate
4.	Decide number of axes (dimensions)
  a.	Usually between 2 and 4 dimensions
  b.	More dimensions means better match, but harder interpretation
  c.	Decision usually made based on stress values
  d.	Stress value < 2 is great. 2 is okay
5.	Arrange objects in ordination plot
  a.	Configure objects in space so that their distance from each other best represents their dissimilarity
    i.	Start with random configuration
    ii.	Then move points around to reduce stress
    iii.	Final configuration = lowest stress
  b.	Stress = difference between distance between points on the plot and actual dissimilarity
6.	Final plot
  a.	Further moving of objects on ordination plot cannot improve match between dissimilarities and distances 
  b.	Stress as low as possible
  c.	Helpful to color code your groups so you can make inferences about the similarity of groups

Two types of MDS: MDS and nMDS
-	MDS uses actual distances and dissimilarities
  -	Problem is that this is often non-linear
-	nMDS uses ranked distances and dssimilarities
  -	similar to spearman rank correlation
  -	common for biological data
  -	the most dissimilar things have to be the farthest things apart
  -	the second most dissimilar things have to be the second farthest things apart
  -	helps to see the spread of your data better
-	rarely see an MDS plot – almost always see an nMDS because it’s a non-parametric test so you get rid of all your assumptions

PERMANOVA (permutational ANOVA)
-	multivariate sums of squares partitioned within and among groups (based on distance from centroid)
-	difference from MANOVA is in how p values are generated
  -	MANOVA: calculate pseudo-F and then get p values
  -	In perMANOVA: shuffle items among groups (one permutation). Calculate F
  -	Do this many times (999?)
  -	P = # times permutedF > actualF) + 1 / (total number of permutations + 1)
-	Very powerful and flexible (can handle complex linear models)
- permutations: shuffle the data and check if the F value is better or worse

ANOSIM (Analysis of Similarity)
-	Same thing that permanova is doing, but instead of using actual dissimilarities, ANOSIM uses ranks of dissimilarities
-	ANOSIM actually a more direct test of what is shown in nMDS
  -	Recall that nMDS uses reanks too
-	While PERMANOVA is probably better to do with MDS
-	Maybe less powerful than PERMANOVA, but if we get a significant p, then we’re okay regardless

