# Installation
library(devtools)
source("http://bioconductor.org/biocLite.R")
biocLite("graph")
biocLite("Rgraphviz")
install.packages('RColorBrewer', dependencies=T)
install_github('ragrawal/GBMUtils')

# Usage

```R
library(gbm)
library(rjson)
library('Rgraphviz')
library('graph')
library(GBMUtils)

N <- 1000
X1 <- runif(N)
X2 <- 2*runif(N)
X3 <- ordered(sample(letters[1:4],N,replace=TRUE),levels=letters[4:1])
X4 <- factor(sample(letters[1:6],N,replace=TRUE))
X5 <- factor(sample(letters[1:3],N,replace=TRUE))
X6 <- 3*runif(N) 
mu <- c(-1,0,1,2)[as.numeric(X3)]
 
SNR <- 10 # signal-to-noise ratio
Y <- X1**1.5 + 2 * (X2**.5) + mu
sigma <- sqrt(var(Y)/SNR)
Y <- Y + rnorm(N,0,sigma)
 
# introduce some missing values
X1[sample(1:N,size=500)] <- NA
X4[sample(1:N,size=300)] <- NA
 
data <- data.frame(Y=Y,X1=X1,X2=X2,X3=X3,X4=X4,X5=X5,X6=X6)
 
# fit initial model
gbm1 <-
gbm(Y~X1+X2+X3+X4+X5+X6,         # formula
    data=data,                   # dataset
    var.monotone=c(0,0,0,0,0,0), # -1: monotone decrease,
                                 # +1: monotone increase,
                                 #  0: no monotone restrictions
    distribution="gaussian",     # see the help for other choices
    n.trees=1000,                # number of trees
    shrinkage=0.05,              # shrinkage or learning rate,
                                 # 0.001 to 0.1 usually work
    interaction.depth=3,         # 1: additive model, 2: two-way interactions, etc.
    bag.fraction = 0.5,          # subsampling fraction, 0.5 is probably best
    train.fraction = 0.5,        # fraction of data for training,
                                 # first train.fraction*N used for training
    n.minobsinnode = 10,         # minimum total weight needed in each node
    cv.folds = 3,                # do 3-fold cross-validation
    keep.data=TRUE,              # keep a copy of the dataset with the object
    verbose=FALSE,               # don't print out progress
    n.cores=1)                   # use only a single core (detecting #cores is
                                 # error-prone, so avoided here)


#Display first tree
treeplot(gbm1, tree=1)

#Display second tree
treeplot(gbm1, tree=2)

#save top 10 trees
output = gbm2json(gbm1, n.trees=10, owner="Ritesh Agrawal", description="Sample gbm tree")



```


