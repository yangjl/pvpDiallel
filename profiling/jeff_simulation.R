library(cowplot)
library(ggplot2)
library(tidyr)

h=runif(10000)/2 #dominance from 0 (recessive) to 0.5 (additive)
s=rep(1:100/1E6,100) #selection values (uncorrelated to dominance) from 1E-5 to 1E-4, roughly what we see
bob=data.frame(h,s) %>%
  mutate(p=ifelse(h<0.04,(3E-8/s)^0.5,3E-8/(h*s))) 
# for h<0.04 treat as completely recessive so p=(u/s)^0.5. for h>0.04 use equation for dominance p=u/hs
ggplot(bob,aes(x=s,y=h))+
  geom_point()+
  geom_smooth(method="lm")


sue=bob[which(rbinom(size=12,n=100000,prob=bob$p)>0),] 
#for each SNP, keep in data if observed in sample of n=12 based on (true) allele freq
ggplot(sue,aes(x=s,y=h))+
  geom_point()+
  geom_smooth(method="lm")
