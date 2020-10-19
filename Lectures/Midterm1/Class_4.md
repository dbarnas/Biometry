# Biometry Class 9-8-2020

### Experimental Design

**Housekeeping**  
- No class last Thursday
- Problem Set 2 is up and pretty long so don't wait, but a lot is coming from next Tuesday's lecture on t-tests
- Quiz on Thursday on lectures 3 and 4

Any good experiment needs:
- replication
- representation
- independence

Designing
1. define population of interest
1. choose an appropriate sampling unit
1. design exp./sampling that addresses the hypothesis of interest
  1. surprisingly common mistake to not do this
  
Know your limitations
- cost
- time
- site conditions
- population size
- etc

What's the least and cheapest we can do but still test the question we want to test?

**Measurements**
- what exactly will you measure?
- how will you measure it (tools)?
  - is it possible to measure in the field? if not, how does that change things?
- will one measuremennt per replicate be adequate? 
  - is your measuring tool preceise?
- sometimes using a proxy measure for what we actually want to meausure
  - ex. want to measure Fitness but need a proxy to indicate fitness level
    - i.e., size, fecundity (number of children or number of grandchildren), etc

**Randomization**
- why sample randomly
  - avoid variability and biases
- how do we sample randomly
  - 'haphazardly' is not exactly randomly but it likely removes biases
  - random number generator: randomize numbers that correspond to locations or organisms
    - excel has a function: =rand(#)
    - can find random number tables online
    - R has a function as well
    
There are different levels of randomness - Sampling Designs
- completely randomized sampling
- random transect sampling
- stratified random transect sampling
  - sometimes called a Block Design

**Confounding Effects**
- differences bdue to our factor of interest cannot be separated from other factors
- between group A and group B, make sure the only difference between those groups is the variable we're testing (theoretically, both groups should otherwise be the same, chosen the same way)

**Deliberate Counfounding Effects**
- be cautious and recognize when you are doing it!
- good allocation of replicates helps
- maybe better to use a Block Design
  - we know variation exists, so we want to make sure we account for that variation
  - deliberately apply your treatment to each different block (location/group)
    - accounts for the difference between blocks (locations/groups) and also accounts for the difference between your test variable(s)
  - the blocks are chosen deliberately, but your treatments are randomized within
  - you could have blocks within blocks
  - can partition out effects of block 1 and effects of block 2, etc. and can partition out effect of treatments, and then can look at interaction effects (effects of the block with the treatment)

**Replication**
- **need replication within each experimental treatment and control**
- need > 1 sampling units (make sure you identify correctly)
- might have replicates and then subsets of those replicates
  - taking 3 blood samples from each mouse, the blood samples from each mouse will be more like each other than blood samples from different mice
  - if you have multiple organisms in a tank and adjust the tank parameters (change the temp, ex) you don't have replicates because it's possible that when some of the organisms get stressed, they release hormones that might stress out the other organisms. those organisms are no longer independent. so ideally, you'd want to have multiple tanks where you adjust the tank parameter the same
  - to be precise, you then take the mean of your replicates
- Inappropriate replication
  - taking diversity measurements within a burnt area and within an unburnt area
    - we are only asking if the one burnt area is different from the one unburnt area
    - **note to self: make sure when I do my research I am intentional that i am only testing one sgd spring to one coral reef without sgd**

**Pseudoreplication**
- Simple pseudoreplication
  - we have replicates within one system and replicates within another system. we aren't testing differences in treatment, we're testing differences between the two systems
- Sacrificial pseudoreplication
  - n=2 for the treatment and n=2 samples per replicate
  - we have some replication per treatment and some replicates within each treatment
  - would be better if we spread out our sampling to have more treatment replication. having n=4 samples from n=4 treatment replicates vs n=4 samples from n=2 treatment replicates
- Temporal pseudoreplication
  - measuring the same individual/area over time
  - our samples aren't truly independent of each other beacuse it's just one individual over time
  - should have multiple replicates at time 1, time 2, time 3, etc. rather than just one

**Control Treatments**
- shows what occurs in the absence of manipulation
- shows relative difference between control and treatment group
- procedural controls
  - used to eliminate artifacts introduced by manipulation
  - injection control in drug studies (placebo group)
  - cage controls in testing effects of concsumers
  - translocation controls in transplant experiments (moving the org around may stress org)
- make sure replicates are independent and randomized



