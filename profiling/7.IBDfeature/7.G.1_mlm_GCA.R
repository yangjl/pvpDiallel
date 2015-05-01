### Jinliang Yang
### April 27th, 2014
### using MLM to compare models


run_model_comp <- function(ghatfile="cache/ghat_wholeset.csv", modes=c("1a2", "1d2")){
  
  
  #### ghat
  ghat <- read.csv(ghatfile)
  ghat <- subset(ghat, tsf =="perse")
  ghat$trait <- toupper(ghat$trait)
  
  #### combining ability
  ca <- read.csv("data/trait_CA.csv")
  ca$genotype <- paste(ca$P1, ca$P2, sep="x")
  
  #setwd("~/Documents/Github/pvpDiallel/")
  trait <- read.csv("data/trait_matrix.csv")
  trait$genotype <- paste(trait$P1, trait$P2, sep="x")
  
  outres <- data.frame()
  for( ti in unique(ghat$trait) ){
    subca <- subset(ca, trait == ti )
    subghat <- subset(ghat, trait == ti )
    subt <- subset(trait, trait == ti )
    
    sub1 <- merge(subghat, subca[, c("genotype", "GCA1.all", "GCA2.all", "SCA.all")], by="genotype")
    sub2 <- merge(subt[, c("genotype", "valHyb")], sub1)
    
    for(mi in modes){
      df <- subset(sub2, mode == mi)
      fit1 <- lm(valHyb ~ GCA1.all + GCA2.all, data=df)
      fit2 <- lm(valHyb ~ GCA1.all + GCA2.all + ghat, data=df)
      fit3 <- lm(valHyb ~ GCA1.all + GCA2.all + SCA.all, data=df)
      fit4 <- lm(valHyb ~ GCA1.all + GCA2.all + SCA.all +ghat, data=df)
      
      out <- data.frame(trait = ti, mode = mi, p21=anova(fit2, fit1)[2, 6], p43=anova(fit4, fit3)[2, 6] )
      outres <- rbind(outres, out)
    } 
  }
  return(outres)
}


mc1 <- run_model_comp(ghatfile="cache/ghat_wholeset.csv", modes=c("1a2", "1d2"))
mc2 <- run_model_comp(ghatfile="cache/gerpall_ghat.csv", modes=c("a2", "d2"))

