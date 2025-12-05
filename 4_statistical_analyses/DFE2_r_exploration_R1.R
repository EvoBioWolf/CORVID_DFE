setwd("/Users/wolf/Dropbox/CORVID_DFE2/Manuscript/Submission/Genetics/R1/statisticalanalyses/")
source("./DFE2_dataprep_R1.R")

library(dplyr)
library(ggplot2)

###reported values for the results section of the paper


#test that r_cM is meaningful
tapply(dat.sel$lenClosest,dat.sel$pop,sum)/1e09 # first check: genome sizes are around 1Gb
tapply(dat.sel$r_cM*dat.sel$lenClosest/1e06,dat.sel$pop,sum)# next check: total genetic maps are around 3000-4000 cM (as in chicken and flycatcher) 
tapply(dat.sel$r_cM,dat.sel$chr,mean) # check median r cM/Mb per chromosome
tapply(dat.sel$r_cM,dat.sel$chr,summary) # check median r cM/Mb per chromosome

##Median genome-wide DFE 
#without gBGC
DFE.spec.noCpG <- tapply(dat.sel$DFE_noCpG,dat.sel$pop,median)
range(DFE.spec.noCpG)
median(DFE.spec.noCpG)

#with gBGC
DFE.spec.all <- tapply(dat.sel$DFE_all,dat.sel$spec,median)
range(DFE.spec.all)
median(DFE.spec.all)

#gBGC increases mutation load, on median average, by a factor of
median(DFE.spec.all)/median(DFE.spec.noCpG)

###DFE range across chromosomes and species withouth gBGC
DFE.chr.spec <- tapply(dat.sel$DFE_noCpG,list(dat.sel$chr,dat.sel$spec),median)
DFE.chr.spec.range <- apply(DFE.chr.spec,2,range)
apply(DFE.chr.spec.range,1,median)

median(DFE.chr.spec.range[2,]/DFE.chr.spec.range[1,])

###mean DFE (nogbgc) difference by Ne of species
DFE.spec<-tapply(dat.sel$DFE_noCpG,dat.sel$spec,mean)
Ne.spec<-tapply(dat.sel$Ne,dat.sel$spec,mean)

###compare large - small chr DFE delta (~Benoit)
DFE.chr.spec.yes <- tapply(dat.nocpg.yes$DFE,list(as.factor(dat.nocpg.yes$chr),as.factor(dat.nocpg.yes$spec)),median)
DFE.chr.spec.no <- tapply(dat.nocpg.no$DFE,list(as.factor(dat.nocpg.no$chr),as.factor(dat.nocpg.no$spec)),median)

a<-apply(DFE.chr.spec.yes,1,mean)
b<-apply(DFE.chr.spec.no,1,mean)

cbind(a,b)

mean(apply(DFE.chr.spec.yes,1,mean)[c(1,12,21,22)])-mean(apply(DFE.chr.spec.yes,1,mean)[13:20])
mean(apply(DFE.chr.spec.no,1,mean)[c(1,12,21,22)])-mean(apply(DFE.chr.spec.no,1,mean)[13:20])

####mean Ne and DFE per Island no / Island
test<-fin%>%group_by(spec,mode,Island)%>%summarise(mean.ne=mean(Ne),mean.dfe=mean(DFE),se=sd(DFE))
tapply(test$mean.dfe,list(test$Island,test$mode),median)
tapply(test$mean.ne,list(test$Island,test$mode),median)


test.rmhighNE<-filter(test,spec!="FriCoeCont",spec!="TaeGut")
tapply(test.rmhighNE$mean.dfe,list(test.rmhighNE$Island,test.rmhighNE$mode),mean)
tapply(test.rmhighNE$mean.ne,list(test.rmhighNE$Island,test.rmhighNE$mode),mean)

#0.31399667-0.21788515=9.6%
#0.20638012-0.14160617=6.4%

###global effect of gBGC
#mean
DFE.spec.noCpG.mean<-tapply(dat.sel$DFE_noCpG,dat.sel$spec,mean)
DFE.spec.all.mean<-tapply(dat.sel$DFE_all,dat.sel$spec,mean)

mean(DFE.spec.all.mean/DFE.spec.noCpG.mean)

#median
DFE.spec.noCpG.median<-tapply(dat.sel$DFE_noCpG,dat.sel$spec,median)
DFE.spec.all.median<-tapply(dat.sel$DFE_all,dat.sel$spec,median)

median(DFE.spec.all.median/DFE.spec.noCpG.median)

