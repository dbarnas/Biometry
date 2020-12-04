# Biometry Class 11-10-2020

### Multivariate Analysis and Principal Component Analyses

**Multivariate Analyses**
- analyses that include > 1 dependent variables
- some questions can only be answered with multiple variables
- ex. what determines the structure of a forest community?
  - compare wet and dry forests
  - community consists of 10 herbaceous, 10 shrub, and 10 tree species; 20 arthropods, 10 bird, and 5 mammal species
- ex. how do three rodents coexist?
  - data: 10 environmental variables recorded for 30 individuals of each of the 3 species
  - use to find the niche of the species, but no one thing defines the niche, it's all the things simultaneously

**Uses of multivariate approaches**
- description: 
  - how are variables related to each other? are they colinear?
- hypothesis testing:
  - reduce variables to one derived variable
  - multivariate approaches

**Derived variables**
- summarize variation in the data set, based on combination of the variables
- simple
  - length/width = shape
- less simple
  -  consolidate variance from a data matrix into a new set of derived variables
- ex.
  z-ik = (c-1)(y-i1) + (c-2)(y-i2) + ... + (c-p)(y-ip)
  - z-ik is the value of the new derived variable
  - c-1 to c-p are weights or coefficients that indicate how much each original variable contributes the linear combination
  - y-i1 to y-ip are the values of the original variables
  - analogous to linear regression equation

Create multiple derived variables
- first derived variable explains most of the variance in the original variables
  - the most important
  - explains the most variance
- second explains most of the remaining variance after the first has been extracted
  - uncorrelated with the first
- third explains most of hte remaining variance after the first and second are extracted, and is uncorrelated with either the first or second, etc.
- number of new derived variables is the same as the number of original variables
  - but usually the first few explian much variance
- graphing for publication
  - typically folks just graph the first two (because often explain the most variation and difficult to visualize 3D on 2D paper)
  - you can display them in three-dimensional space, as well as possible on 2D
  - also can show the 3rd with the 1st
  - not really a right and wrong

**Eigenvalues and eigenvectors**
- eigenvalues
  - how much of the original variance is explained by each of the new derived variables
- eigenvectors
  - the list of coefficients (or weights) for each new derived variable
  - like an r2 value: how much of the variance in the original data is explained by the new derived variables
  - values shows how much each original variable contributes to each new derived variable
  - called "loadings"
  - like the slope, telling us how strong the relationship is

**PCA: Principal Components Analysis**
- visualization technique
- no hypothesis testing
- just like in a linear regression, PCA finds the best association among variables
- minimizes distance to line in both x and y directions
- does the same thing, but through 5 dimensions of space or 10 dimensions of space and we're fitting a best fit line through those dimensions
- best fit line is what we call PC1 (principal component 1), then we pass a line perpendicular to that (PC2), and it best fits the data left to be explained
- biplots: when you only plot two of the axes (usually between PC1 and PC2)

**Steps in PCA**
1. from raw data, calculate covariance or correlation matrix
  - use covariance matrix if variables on same scale
  - use correlation matrix if variables on different scale
  - OR convert all variables to z-scores (then use covariance matrix)
    - probably the most common thing folks do now for PCA
    - take the data point, subtract the mean, then divide by the standard deviation
2. Determine principal components (putting in the best fit lines through #-Dimensional space)
3. Calculate eigenvectors
    - weightings of each original variable on each component, aka "loadings"
    - and eigenvalues (variation explained by each component)
4. Decide how many components to retain
    - "scree plot"
    - will always go down, but what matters is how much it goes down
    - shows relatively how much each component explains
- if you have two variables that explain 90% of your variation, you don't have to try to use all of your 10 or whatever variables to run your analysis, you can just use the main 2 or 3 variables to run your stats

**Reading a PCA**
- loading value corresponds to how well the new derived variable aligns with the original variable (PC1 or PC2)
- ex. variables with high loading values close to parallel with PCA1 axis, 
- grouped variables are positively correlated with each other, and variables that are on opposite sides of the PCA are negatively correlated
- variables that are orthogonal are independent and not at all correlated with orthogonal variables
- not testing hypothesis, just letting us visualize and reduce the data, then we can come up with hypotheses to test
- we don't have to use all 7 variables, we just have to use those two PC axes
- visualizing hypotheses
  - coding different colors and shapes and coding to add confidence intervals
  - ex. 









