setwd("/Users/wolf/Dropbox/CORVID_DFE2/Manuscript/Submission/Genetics/R1/statisticalanalyses/")
source("./DFE2_dataprep_R1.R")

#install.packages("tidyverse")
#install.packages("ggpubr")
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(dplyr)
#### 
#fin
####

###bymode- final figure3

mainfig<-ggplot(data=fin,mapping=aes(x=r_cM,y=DFE))+
  labs(x="recombination [cM/Mb]",y=expression(paste(N[e],s%in%"(-1;0]")))+
  scale_colour_gradient(low="lightblue", high="darkblue")+
  geom_smooth(data=fin[fin$mode2=="without gBGC",] ,method=lm,se=T,mapping=aes(group=distribution,linetype=distribution),color="black",show.legend=F)+
  geom_smooth(data=fin[fin$mode2=="with gBGC",] ,method=lm,se=T,mapping=aes(group=distribution,linetype=distribution), color="black",show.legend=F)+
  geom_line(data=fin[fin$distribution=="Mainland",],stat="smooth",method=lm,se=F,mapping=aes(group=pop,color=log10(Ne),linetype=distribution),alpha=.5,linewidth=.8,show.legend=F)+
  geom_line(data=fin[fin$distribution=="Island",],stat="smooth",method=lm,se=F,mapping=aes(group=pop,color=log10(Ne),linetype=distribution),alpha=.5,linewidth=.8,show.legend=F)+
  
  facet_grid(~factor(mode2,levels=c("without gBGC","with gBGC")))+
  theme_classic()+
  theme(legend.text=element_text(size=13),
       axis.text=element_text(size=15),
       axis.title=element_text(size=18),
       strip.text=element_text(size=15),
       panel.spacing=unit(3,"lines"))
mainfig

#####panel 2: difference nocpg- all

difffig<-ggplot(data=dat.sel,mapping=aes(x=r_cM,y=DFE_all-DFE_noCpG))+
  labs(x="recombination [cM/Mb]",y=expression(paste(Delta,N[e],s%in%"(-1;0]")))+
  scale_colour_gradient(low="lightblue", high="darkblue")+
  geom_line(stat="smooth",method=lm,se=F,mapping=aes(x=r_cM,y=DFE_all-DFE_noCpG,group=pop,color=log10(Ne),linetype=distribution),alpha=.5,linewidth=.7)+
  geom_smooth(method=lm,se=T,mapping=aes(x=r_cM,y=DFE_all-DFE_noCpG,group=distribution,linetype=distribution),color="black")+
  theme_minimal()+
  theme(legend.title=element_text(size=16),
        legend.text=element_text(size=16),
        axis.text=element_text(size=16),
        axis.title=element_text(size=20),
        strip.text=element_text(size=20))

difffig

#plot both panels
ggarrange(mainfig,difffig,ncol=1, nrow=2)

png("Figure3.png",height=650, width=900)
ggarrange(mainfig,difffig,ncol=1, nrow=2)
dev.off()


pdf("Figure3.pdf",width=9,height=7)
ggarrange(mainfig,difffig,ncol=1, nrow=2)
dev.off()








#########Supplementary Figures

##plot DFE vs. Ne

test<-fin%>%group_by(pop,mode2,distribution)%>%summarise(mean.ne=mean(Ne),mean.dfe=mean(DFE),se=sd(DFE))
mean.dfe.group<-test%>%group_by(mode2,distribution)%>%summarize(mean.dfe.bydistmode=mean(mean.dfe),mean.ne.bydistmode=mean(mean.ne),min.ne=min(mean.ne),max.ne=max(mean.ne))
abline<-read.delim("abline_info.txt") # manually rearranged version of mean.dfe.group


dfevsne<-ggplot(data=test,mapping=aes(x=log10(mean.ne),y=mean.dfe))+
  labs(x=expression(paste(log[10],N[e])),y=expression(paste(Delta,N[e],s%in%"(-1;0]")))+
  ylim(0,.4)+
  geom_point(mapping=aes(color=distribution))+
  #geom_text(aes(label = pop), vjust = -0.5, size = 4)+
  geom_line(data=abline,  aes(log10(posx),posy,group=distribution, colour=distribution), linewidth=2, alpha=0.5) +
  #geom_hline(data=mean.dfe.group,mapping=aes(yintercept=mean.dfe.bydistmode,group=distribution,color=distribution))+
  facet_grid(~factor(mode2,levels=c("without gBGC","with gBGC")))+
  theme_classic()+
  theme(legend.title=element_text(size=16),
             legend.text=element_text(size=16),
             axis.text=element_text(size=16),
             axis.title=element_text(size=20),
             strip.text=element_text(size=20),
             panel.spacing=unit(3,"lines"))

dfevsne

ggsave("SupplFigA.png",dfevsne,device="png")


###playground
fin$Neplot<-log10(fin$Ne)
fin$Neplot[fin$distribution=="Mainland"]<-fin$Neplot[fin$distribution=="Mainland"]*-1

mainfig<-ggplot(data=fin,mapping=aes(x=r_cM,y=DFE))+
  labs(x="",y=expression(paste(N[e],s%in%"(-1;0]")))+
  geom_line(data=fin[fin$distribution=="Mainland",],stat="smooth",method=lm,se=F,mapping=aes(group=pop,color=Neplot),alpha=.5,linewidth=.7,show.legend=T)+
  geom_line(data=fin[fin$distribution=="Island",],stat="smooth",method=lm,se=F,mapping=aes(group=pop,color=Neplot),alpha=.5,linewidth=.7,show.legend=T)+
  scale_colour_gradient2(low="red", mid="white", high="lightblue",midpoint = 0)+
 geom_smooth(data=fin[fin$mode2=="without gBGC",] ,method=lm,se=T,mapping=aes(group=distribution,linetype=distribution),color="black",show.legend=F)+
geom_smooth(data=fin[fin$mode2=="with gBGC",] ,method=lm,se=T,mapping=aes(group=distribution,linetype=distribution), color="black",show.legend=F)+
  facet_grid(~factor(mode2,levels=c("without gBGC","with gBGC")))+
  theme_classic()+
  theme(legend.text=element_text(size=13),
        axis.text=element_text(size=15),
        axis.title=element_text(size=18),
        strip.text=element_text(size=15),
        panel.spacing=unit(3,"lines"))
mainfig


mainfig<-ggplot(data=fin,mapping=aes(x=r_cM,y=DFE))+
  labs(x="",y=expression(paste(N[e],s%in%"(-1;0]")))+
  geom_smooth(data=fin[fin$mode2=="without gBGC"&&fin$distribution=="Island",] ,method=lm,se=T,aes(group=distribution,linetype=distribution),show.legend=F,color="blue")+
  geom_smooth(data=fin[fin$mode2=="without gBGC"&&fin$distribution=="Mainland",] ,method=lm,se=T,aes(group=distribution,linetype=distribution),show.legend=F)+
  geom_smooth(data=fin[fin$mode2=="with gBGC"&&fin$distribution=="Island",] ,method=lm,se=T,aes(group=distribution,linetype=distribution),show.legend=F)+
  geom_smooth(data=fin[fin$mode2=="with gBGC"&&fin$distribution=="Mainland",] ,method=lm,se=T,aes(group=distribution,linetype=distribution),show.legend=F)+
  geom_line(data=fin[fin$distribution=="Mainland",],stat="smooth",method=lm,se=F,mapping=aes(group=pop,color=log10(Ne),linetype=distribution),alpha=.5,linewidth=.7,show.legend=F)+
  geom_line(data=fin[fin$distribution=="Island",],stat="smooth",method=lm,se=F,mapping=aes(group=pop,color=log10(Ne),linetype=distribution),alpha=.5,linewidth=.7,show.legend=F)+

  facet_grid(~factor(mode2,levels=c("without gBGC","with gBGC")))+
  scale_colour_gradient(low="lightblue", high="darkblue")+
  theme_classic()+
  theme(legend.text=element_text(size=13),
        axis.text=element_text(size=15),
        axis.title=element_text(size=18),
        strip.text=element_text(size=15),
        panel.spacing=unit(3,"lines"))
mainfig

