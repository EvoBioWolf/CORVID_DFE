library(tidyverse)
library(dplyr)
setwd("/Users/wolf/Dropbox/CORVID_DFE2/Manuscript/Submission/Genetics/R1/statisticalanalyses/")
dat<-read.delim("./data_allData_newFormat_R1.txt")
dat<-dat[,1:13]
dat<-data.frame(dat,logNe=log(dat$Ne))
#remove pooled populations
dat.sel<-subset(dat,pop!="FicHypAll"&pop!="FicAlbAll")
#recode Island and Mode for more intuitive printing
dat.sel<-dat.sel%>%mutate(distribution=fct_recode(Island,"Mainland" = "No", "Island" = "Yes"))
#remodel data frame as to separate gBGC classes in rows to make findal data set.
dat.allsites<-subset(dat.sel,select=-DFE_noCpG);names(dat.allsites)[7]<-"DFE"
dat.nocpg<-subset(dat.sel,select=-DFE_all);names(dat.nocpg)[7]<-"DFE"
dat.nocpg.yes<-subset(dat.nocpg[dat.nocpg$Island=="Yes",])
dat.nocpg.no<-subset(dat.nocpg[dat.nocpg$Island=="No",])                    
fin<-data.frame(rbind(dat.allsites,dat.nocpg),mode=rep(c("all","nocpg"),each=dim(dat.sel)[1]))
fin$mode<-as.factor(fin$mode)
fin$chr<-as.factor(fin$chr)
#recode Mode for more intuitive printing
fin<-fin%>%mutate(mode2=fct_recode(mode,"with gBGC" = "all", "without gBGC" = "nocpg"))


