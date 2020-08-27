Biometry Class 8-25-2020

[Canvas](https://canvas.csun.edu/courses/82026)  
[Padlet Page](https://padlet.com/casey_terhorst/biometry2020)  
-  can find embedded in Canvas
[Text book pdf](https://www2.ib.unicamp.br/profs/fsantos/apostilas/Quinn%20&%20Keough.pdf)  

**Cam's Zoom Office Hours:**  
Thursdays 10:30-11:30 am  
Meeting ID: 809 012 5889  
Passcode: introbio  

**What are "statistics"?**
- a way of understanding patterns in some system
- mathematics for analyzing and interpreting results
- descriptive vs inferential statistics
  - descriptive: ex. average. tells us something, but doesn't tell us how confident we are
  - inferential: 
- picking out patterns or picking out if things are different from each other and how different those things are

**What do we use them for?**
- understanding where we've been so we can hopefully project or predict where we're going
- teasing apart complicated relationships - finding correlations

**What are your goals for this course?**
- Have a practical understanding of various statistical tests/analyses
- Learn how to more effectively communicate science/analyses
- How to work with big data sets

**What do you want to leave knowing?**
- I want to be able to choose my statistical analyses confidently for my project/future research.
- How to spot poor statistics

**Lecture**
- "We disprove hypotheses in science, we don't prove anything." We are driven by probabilities.
- "Every statistic answers exactly one question.  We need to make sure we're asking the right question"
- Sources of natural variation
  - measurement error: experimental variation (possible human error)
  - variability in phenotypes and genotypes
  - variability in space and time (day vs night, seasonal differences, etc.)
- How many measurements do we need to take?
  - subset = SAMPLE (representative of the population)
  - complete set = POPULATION (what we're really interested in)
  - the more we measure in the sample, the closer we get to describing the population
- Hierarchy of observational units
  - Variable: the actual property that is measured on each observation
  - Observation (sampling unit): the unit upon whcih the measurement is made
  - Sample: the subset of observations collected from the population
  - Population: the complete set of observations about which inferences are to be made
- Types of variables
  - Continuous (best): can take any real value (ex. temperature, O2, lengths)
  - Discontinuous (almost as good): integers (ex. counts)
  - Ordinal (= ranked): quantitative differences betwen sampling units, but the difference is not measured
  - Nominal (= categorical): (ex. color, shape)
  - Derived variables: derived from other data (ex. ratios, %, rates)
- Collecting data
  - the more detailed info we have on each sampling unit, the easier it will be to detect differences
  - wherever possible, collect data by counting or measuring
- Accuracy
  - the closeness of a measured or computed value to its true value
- Pricision
  - the closeness of repeated measurements of the same quantity to each other; measure of exactness/consistency
  - ex. how fine scaled the ruler is to measure. getting to 0.1 vs 0.001
- Bias
  - consistent over- or underestimation of the true value of the population
  - if our ruler is off by an inch for every measurement
- implied limits
  - the last digit of measurement should imply precision
  - ex. if measurement = 12.3, the implied limits are 12.25-12.35
  - should always report our data to the same scale as our measurement (ex. to the nearest decimal that was actually measured)

"We should think about how we want to measure things when we think of what to measure"

**Syllabus**
- quizes maybe every other week or so
- exams:
  - "theory" (paper)
  - "practice" (computer)
- midterms will cover just their 1/3 section
- final exam will be cumulative with heavy emphasis on the final 1/3 section
- problem sets
  - do your own work, turn in your own, BUT collaborate with others for these
- it's possible lectures will get pushed back depending on how quickly we get through things, but exams will stay on the same date
- if there's a midterm, we won't have class, we'll just take the midterm during class time
- final exam: the theory portion will be during the scheduled time, but for the computer portion, we will have a week to complete
- quizes: we will be asked on material that was covered in the last lecture or two (very recently)

**How to succeed in this class**
- studying is a way to get to learning, but learning is the goal
- think about how we study. is that studying an effective way to get to learning
- know which task to do
- recognize the patterns
- start homework early - the day it's assigned
- work the problems first, then check your notes later
- make flashcards for things you need to memorize
- explain things out loud to test understanding
- spend time with the material every day
- aim for 100% mastery, not just what you need to get an A
- don't give up too soon or spend too much time, and know when to ask for help

**IntroToR.R Questions**
- what is IQR (interquartile range)?



```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
