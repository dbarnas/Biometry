# Biometry Lecture 12-3-2020


**Types of Regression**
- non-linear regression
  - trait selection plotted against fitness (y) (fitness could be inseminations, or survival, or # eggs, etc)
  - ex. fly larvae in a gall. if too small, could be parasitized by a wasp.  if too big, could be found and eaten by birds. intermediate size where the gall/larvae survive well
- In R
  - LinearModel<- lm(fitness ~ hornLength)
  - PolynomialModel <- lm (ProportionSurvived ~ GallDiameter + GallDiameter^2)
- How to choose?
  - ideally you know going into your study that you may look for nonlinear relationship
    - you should know your analysis before looking at your data
  - often people will put in a squared element to test fo rnonlinear component
  


