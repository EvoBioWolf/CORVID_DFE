setwd("/Users/wolf/Dropbox/CORVID_DFE2/Manuscript/Submission/Genetics/R1/statisticalanalyses/")
source("./DFE2_dataprep_R1.R")

#install.packages("MCMCglmm")
#install.packages("brms")

library(dplyr)
library(ape)
library(MCMCglmm)

fin2<-fin%>%mutate(pop = fct_recode(pop, "FicAlb"="FicAlbIta","FicHyp"="FicHypSwe"))
tree.org<-read.tree("mtTree.tre")
tree<-drop.tip(tree.org,7)

# Build the phylogenetic covariance matrix
A <- vcv(tree, corr = F)   # correlation matrix from the tree
heatmap(A)
Ainv <- solve(A)
heatmap(Ainv)

#check
A%*%Ainv

# ensure species names match the matrix:
fin_sub <- fin2%>%filter(as.factor(pop) %in% as.factor(tree$tip.label))%>%mutate(pop=droplevels(pop)) 

phylo_levels <- levels(fin_sub$pop)  # or after creating the phylo column
Ainv <- A[phylo_levels, phylo_levels]
Ainv_sparse<-as(Ainv, "dgCMatrix")

fin_sub <- fin_sub %>% mutate(animal = factor(pop, levels = phylo_levels))

all(levels(fin_sub$animal) == rownames(Ainv))  # TRUE
all(levels(fin_sub$animal) == colnames(Ainv))  # TRUE


###MCMCglmm

#including phylogeny and chromosome as random factor
prior2 <- list(G = list(G1 = list(V = 1, nu = 0.002), G2 = list(V = 1, nu = 0.002)), R = list(V = 1, nu = 0.002))

model2a <- MCMCglmm(DFE ~ Island*log(r_cM)*mode,random = ~animal + chr,
                   family="gaussian",
                   data = fin_sub,
                   ginverse = list(animal = Ainv_sparse),
                   prior=prior2,
                   nitt=150000, burnin=50000, thin=50) 

model2b <- MCMCglmm(DFE ~ log(r_cM)*Island + log(r_cM)*mode + Island*mode,random = ~animal + chr,
                    family="gaussian",
                    data = fin_sub,
                    ginverse = list(animal = Ainv_sparse),
                    prior=prior2,
                    nitt=150000, burnin=50000, thin=50) 

model2c <- MCMCglmm(DFE ~ 1,random = ~animal + chr,
                    family="gaussian",
                    data = fin_sub,
                    ginverse = list(animal = Ainv_sparse),
                    prior=prior2,
                    nitt=150000, burnin=50000, thin=50) 


#can be compared across random factors? 
model<-model1a

summary(model2a)$DIC 
summary(model2b)$DIC 
summary(model2c)$DIC 


#
model<-model1a

summary(model)

par(mar = c(2, 2, 2, 2))
plot(model$Sol)
effectiveSize(model$Sol)
autocorr.diag(model$Sol)
heidel.diag(model$Sol)


plot(model$VCV)
effectiveSize(model$VCV)
autocorr.diag(model$VCV)
heidel.diag(model$VCV)




