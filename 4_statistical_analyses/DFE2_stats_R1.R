setwd("/Users/wolf/Dropbox/CORVID_DFE2/Manuscript/Submission/Genetics/R1/statisticalanalyses/")
source("./DFE2_dataprep_R1.R")

#install.packages("lme4")
#install.packages("car")

library(lme4)
library(car)

options(digits=8) 
#n<-dim(fin)[1]
n<-24 # divided by number of species

########
#testing RANDOM effects
#######

r<-log(fin$r_cM)
N<-fin$Island

lmA<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1+r|pop)+(1|chr), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmA1<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1+r|species)+(1|chr), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmB<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1+r|pop), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmB1<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1+r|species), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmC<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1|chr), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmD<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1|pop)+ (1|chr), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmE<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1|pop), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmF<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1+r|pop/species) + (1|chr) , fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmG<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1+r|pop/species), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmH<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1|pop/species)+ (1|chr), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
lmI<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode*r + (1|pop/species), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))


n<-24
aic.models<-AIC(lmA,lmA1,lmB,lmB1,lmC,lmD,lmE,lmF,lmG,lmH,lmI) 
aic<-aic.models$AIC
k<-I(aic.models$df)  
AICc<-aic+2*k*(k+1)/(n-k-1)
deltaAIC<-I(aic-min(aic.models[,2]))
deltaAICc<-I(AICc-min(AICc)) 
wAIC<-exp(-deltaAIC/2)/sum(exp(-deltaAIC/2))
wAICc<-exp(-deltaAICc/2)/sum(exp(-deltaAICc/2))
bic<-AIC(lmA,lmA1,lmB,lmB1,lmC,lmD,lmE,lmF,lmG,lmH,lmI,k=log(n))$AIC 

result.aic<-data.frame("model"=rownames(aic.models),
                       k,"AIC"=aic,"AICc"=round(AICc,3),"deltaAIC"=round(deltaAIC,3),"deltaAICc"=round(deltaAICc,3),
                       "wAIC"=round(wAIC,3),"wAICc"=round(wAICc,3),bic)

result.aic<-result.aic[order(result.aic$AIC),]#sorted AIC table
result.aic

write_excel_csv2(result.aic,"./out2.csv")

#############
####testing FIXED effects
#############


r<-log(fin$r_cM) #log(fin$r_cM) or log(fin$lenClosest)
N<-log(fin$Ne)#fin$Island or log(fin$Ne) 


lm0<-lmer(DFE ~ 1 + (1+r|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm1<-lmer(DFE ~ r + (1+1|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm2<-lmer(DFE ~ r + N + (1+r|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm3<-lmer(DFE ~ r + mode  + (1+r|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm4<-lmer(DFE ~ r + N + mode + (1+r|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm5<-lmer(DFE ~ r + N + mode + r*mode  + (1+r|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm6<-lmer(DFE ~ r + N + mode + r*N + (1+r|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm7<-lmer(DFE ~ r + N + mode + r*N + r*mode + (1+r|pop)+(1|chr),fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm8<-lmer(DFE ~ r + N + mode + N*mode + (1+r|pop)+(1|chr), fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm9<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode + (1+r|pop)+(1|chr), fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
lm10<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode+ N*mode*r + (1+r|pop)+(1|chr), fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))


aic.models<-AIC(lm0,lm1,lm2,lm3,lm4,lm5,lm6,lm7,lm8,lm9,lm10) 
aic<-aic.models$AIC
k<-I(aic.models$df)  
AICc<-aic+2*k*(k+1)/(n-k-1)
deltaAIC<-I(aic-min(aic.models[,2]))
deltaAICc<-I(AICc-min(AICc)) 
wAIC<-exp(-deltaAIC/2)/sum(exp(-deltaAIC/2))
wAICc<-exp(-deltaAICc/2)/sum(exp(-deltaAICc/2))
bic<-AIC(lm0,lm1,lm2,lm3,lm4,lm5,lm6,lm7,lm8,lm9,lm10,k=log(n))$AIC 

result.aic<-data.frame("model"=rownames(aic.models),
                       k,"AIC"=aic,"AICc"=round(AICc,3),"deltaAIC"=round(deltaAIC,3),"deltaAICc"=round(deltaAICc,3),
                       "wAIC"=round(wAIC,3),"wAICc"=round(wAICc,3),bic)

result.aic<-result.aic[order(result.aic$AIC),]#sorted AIC table
result.aic

#######
###testing fixed effects no random effects
######

#########
##inspecting BEST MODEL
########

lm5.REML<-lmer(DFE ~ r + N + mode + (1+r|pop)+(1|chr),fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
Anova(lm5.REML)
summary(lm5.REML)

lm7.REML<-lmer(DFE ~ r + N + mode + (1+r|pop)+(1|chr),fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
Anova(lm7.REML)
summary(lm7.REML)
  
lm8.REML<-lmer(DFE ~ r + N + mode + N*mode + (1+r|pop)+(1|chr),fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
Anova(lm8.REML)
summary(lm8.REML)

lm9.REML<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode + (1+r|pop)+(1|chr), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead"))
Anova(lm9.REML)
summary(lm9.REML)

lm10.REML<-lmer(DFE ~ r + N + mode + r*N + r*mode + N*mode+ N*mode*r + (1+r|pop)+(1|chr), fin,REML=T,control = lmerControl(optimizer ="Nelder_Mead")) 
Anova(lm10.REML)
summary(lm10.REML)



##have a look at predicted values
fin$pred<-predict(lm10.REML)
plot(pred~DFE,fin,col=as.numeric(as.factor(pop)),pch=as.numeric(as.factor(pop)));lines(c(0,1),c(0,1))

ggplot(data=fin,mapping=aes(x=log(lenClosest),y=DFE))+
  geom_smooth(data=fin[fin$Island=="Yes",],method=lm,se=F,mapping=aes(group=pop),color="grey",linetype="solid")+
  geom_smooth(data=fin[fin$Island=="No",],method=lm,se=F,mapping=aes(group=pop),color="lightblue",linetype="solid")+
  geom_smooth(data=fin[fin$Island=="Yes",],method=lm,se=T,mapping=aes(group=mode),color="black",linetype="solid")+
  geom_smooth(data=fin[fin$Island=="No",],method=lm,se=T,mapping=aes(group=mode),color="blue",linetype="solid")+
  facet_grid(~mode)+
  theme_minimal()



####to HERE with changed parameters###

####check of model fit
obs.pred<-ggplot(data=fin,mapping=aes(x=DFE,y=pred))+
  geom_point(aes(color=Island))+
  geom_abline(slope=1)+
  labs(x = "Estimated proportion of mildly deleterious sites", y = "Predicted values")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))+
  theme(axis.title.x = element_text(size = 20), axis.title.y = element_text(size = 20))+
  ylim(0,.5)+
  xlim(0,.5)+
  facet_grid(mode~pop)
obs.pred

ggsave("./DFEvsPredicted.pdf",obs.pred,width=25,height=10)


##play with prediction - model with Island
model.island<-lmer(DFE ~ r_cM + Island + mode + r_cM*Island + r_cM*mode + Island*mode+ Island*mode*r_cM + (1+r_cM|pop)+(1|chr), fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
a<-summary(model.island)$coefficients[1:8] 
test.pred<-function(r=mean(fin$r_cM),Island=0,mode=0){
  a[1] + a[2]*r + a[3]*Island +  a[4]*mode + a[5]*r*Island + a[6]*r*mode + a[7]*Island*mode+ a[8]*Island*mode*r
}

test.pred(r=0,Island=0,mode=0)

# predicted change of DFE through gbgc
# Island effect no gbgc
all.NO <- test.pred(r=mean(fin$r_cM),Island=0,mode=0)
all.YES <- test.pred(r=mean(fin$r_cM),Island=1,mode=0)

# Island effect with gbgc
nocpg.NO <- test.pred(r=mean(fin$r_cM),Island=0,mode=1)
nocpg.YES <- test.pred(r=mean(fin$r_cM),Island=1,mode=1)

#proportional
all.NO/nocpg.NO #mainland
all.YES/nocpg.YES #island

#absolute
all.NO-nocpg.NO #mainland
all.YES-nocpg.YES #island

#effect island vs mainland
all.YES/all.NO # 1.6 more mutation loads on islands
nocpg.YES/nocpg.NO # 1.6 more mutation load on islands

#test for effect of recombination
all.NO.low <- test.pred(r=min(fin$r_cM),Island=0,mode=0); all.NO.low 
all.NO.high <- test.pred(r=max(fin$r_cM),Island=0,mode=0); all.NO.high
all.NO.low/all.NO.high # 1.8 times higher on mainland in low r regions thatn high r regions

all.YES.low <- test.pred(r=min(fin$r_cM),Island=1,mode=0); all.YES.low 
all.YES.high <- test.pred(r=max(fin$r_cM),Island=1,mode=0); all.YES.high
all.YES.low/all.YES.high # 1.8 times higher on mainland in low r regions thatn high r regions



##play with prediction - model with logNe
model.Ne<-lmer(DFE ~ r_cM + exp(logNe + mode + logNe*mode + (1+r_cM|pop)+(1|chr), fin,REML=F,control = lmerControl(optimizer ="Nelder_Mead"))
a<-summary(model.Ne)$coefficients[1:5] 
test.pred.Ne<-function(r=mean(fin$r_cM),Ne=mean(fin$logNe),mode=0){
  a[1] + a[2]*r + a[3]*Ne +  a[4]*mode + a[5]*mode*Ne
}


# predicted change of DFE through gbgc
# Island effect no gbgc
all.small <- test.pred.Ne(r,Ne=min(fin$logNe),mode=0) #min logNe species: 63236
all.large <- test.pred.Ne(r,Ne=max(fin$logNe),mode=0) #max logNe species: 1197641
1197641/63236

# Island effect with gbgc
nocpg.small <- test.pred.Ne(r,Ne=min(fin$logNe), mode=1)
nocpg.large <- test.pred.Ne(r,Ne=max(fin$logNe), mode=1)

#change in DFE etween larges and smallest Ne in dataset
all.small/all.large # DFE doubles with 18-fold diff in Ne
nocpg.small/nocpg.large #DFE double with 18-fold diff in Ne

all.r.high <- test.pred.Ne(r=max(fin$r_cM),Ne=mean(fin$logNe),mode=0); all.r.high
all.r.low <- test.pred.Ne(r=min(fin$r_cM),Ne=mean(fin$logNe),mode=0); all.r.low

all.r.low/all.r.high #for mean Ne chr with lowst r has on average 1.4 x more del mutations than smallest

nocpg.r.high <- test.pred.Ne(r=max(fin$r_cM),Ne=mean(fin$logNe),mode=1); nocpg.r.high
nocpg.r.low <- test.pred.Ne(r=min(fin$r_cM),Ne=mean(fin$logNe),mode=1); nocpg.r.low

nocpg.r.low/nocpg.r.high #for mean Ne chr with lowest r has on average 1.7 x more del mutations than smallest 



