#How to do nMDS and perMANOVA

rm(list=ls()) #Clears the environment

####
#How to do NMDS
#We're going to use some of Nyssa Silbiger's data. 
#Nyssa went to several different sites and quantified percent cover of different
#species, including bare rock and sand

PercentTotal<-read.csv('Data/PercentTotal.csv')
View(PercentTotal)

#We're going to need to vegan library, which is used for lots of multivariate stuff
library(vegan)

#There are a few ways to do MDS in R.
#I'm going to use metaMDS, which does a nMDS, and the code is pretty simple.

#create the ordination output using bray curtis dissimilarity matrix
ord<-metaMDS(PercentTotal[,-1],k=2, distance='bray') 
#We add [,-1] to get rid of the first column with the site names
#distance = is the type of dissimilarity matrix
#k is number of dimensions (you can try different ones to look at different stress)

# if it does not converge add more iterations (not necessary in this case)
ord<-metaMDS(PercentTotal[,-1],k=2, distance='bray', trymax = 30) #add more iterations

#let's look at the stress with k=2 dimensions. Is it < 0.3? 
ord$stress
# It is 0.2 which is "good/ok". Would it help to add a third dimension?
ord2<-metaMDS(PercentTotal[,-1],k=3, distance='bray', trymax=30) 
ord2$stress

#That's a little better, so we might want that one. But for simplicity, I'm going to
#stick with two dimensions, which was ok

# Let's look at the stress plot
stressplot(ord)
# looks like a good fit, want to minimize scatter

# basic plot
ordiplot(ord) # dots represent sites (tide pools in Nyssa's case) and 
#+ represents species
# add text
ordiplot(ord, type = 'text')

# let's make a better plot

plot(1, type='n', xlim=c(-2,2), ylim=c(-1.5,1.5), xlab='nMDS1', 
     ylab='nMDS2', xaxt='n', yaxt='n')
#You will need to play with the x and y lim to get a graph that best shows differences

points(ord$points[PercentTotal$Site=='Bodega',1],ord$points[PercentTotal$Site=='Bodega',2], 
       pch=19, col='red', cex=2)
points(ord$points[PercentTotal$Site=='BobCreek',1],ord$points[PercentTotal$Site=='BobCreek',2], 
       pch=19, col='purple', cex=2)
points(ord$points[PercentTotal$Site=='CDM',1],ord$points[PercentTotal$Site=='CDM',2], 
       pch=19, col='magenta', cex=2)
points(ord$points[PercentTotal$Site=='Monterey',1],ord$points[PercentTotal$Site=='Monterey',2], 
       pch=19, col='lightblue', cex=2)


# let's add a circle around all points by groups
ordiellipse(ord, groups=PercentTotal$Site, label=F, kind='ehull', border='white', col=c('purple','red','magenta','lightblue'), lwd=2, draw ='polygon')
# if you want to make the circles Standard deviations
ordiellipse(ord, groups=PercentTotal$Site, kind='sd', border='white', col=c('purple','red','magenta','lightblue'), lwd=2, draw ='polygon')

# can add or remove labels 
#other options # just draw a polygon
ordihull(ord, groups=PercentTotal$Site, col=c('purple','red','magenta','lightblue'))
#add site labels
ordispider(ord, groups=PercentTotal$Site, col=c('purple','red','magenta','lightblue'), label = T)# make a spider plot
#add a legend with stress
legend('topleft', legend = paste('2D stress = ', round(ord$stress,2)), bty='n')
#add a Site legend
legend('topright',legend=c('Bob Creek','Bodega','Monterey','Corona del Mar'),
       col=c('purple','red','lightblue','magenta'), pch=19, bty='n')

#This is too busy of a plot, so you probably only want to add SOME of the options above

####
#We could formally test whether sites are different using a perMANOVA. 
#This requires the adonis command in the vegan package

permanovamodel<-adonis(PercentTotal[,-1]~Site, PercentTotal, permutations = 999, 
                       method="bray")
permanovamodel

#If we are to trust the results of the permanova, then we have to assume that the dispersion among
#data is the same in each group. We can test with assumption with a PermDisp test:
disper<-vegdist(PercentTotal[,-1])
betadisper(disper, PercentTotal$Site)
#Look at the Average distance to median...these numbers should be reasonably similar
#A rule of thumb is that one number should not be twice as high as any other

#An option for doing post-hoc pairwise comparisons in R
  #library(devtools)
  #install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
library(pairwiseAdonis)
pairwise.adonis(PercentTotal[-1], PercentTotal$Site, perm=999)

#Get coefficients to see which species are most important in explaining site differences:
permanovamodel$coefficients
#striped parrotfish primarily drive the difference among sites, followed by squirrelfish


