### Jinliang Yang
### beanplot

#http://www.jstatsoft.org/v28/c01/paper

runttest2 <- function(resfile="cache/genic_perse.csv"){
  resin <- read.csv(resfile)
  print(table(resin$trait))
  print(head(resin))
  #### >>>>
  res <- data.frame()
  myt <- unique(resin$trait)
  resin$cs <- gsub("cs0", "real", resin$cs)
  resin$cs <- gsub("cs.*", "cs", resin$cs)
  mode <- unique(resin$mode)
  for(ti in myt){
    for(modei in mode){
      test <- t.test(subset(resin, cs=="real" & trait== ti & mode == modei)$r, 
                     subset(resin, cs=="cs" & trait == ti & mode == modei)$r, alternative ="greater")
      tem <- data.frame(trait= ti, pval=test$p.value, mode=modei)
      res <- rbind(res, tem)
    }
    
  }
  res$file <- resfile
  return(res)
}

#####
res1 <- runttest2(resfile="cache/genic_perse.csv")
res2 <- runttest2(resfile="cache/genic_BPHmax.csv")
res3 <- runttest2(resfile="cache/genic_pBPHmax.csv")
res4 <- runttest2(resfile="cache/genic_BPHmin.csv")
res5 <- runttest2(resfile="cache/genic_pBPHmin.csv")
res6 <- runttest2(resfile="cache/genic_MPH.csv")
res7 <- runttest2(resfile="cache/genic_pMPH.csv")

pval <- rbind(res1, res2, res3, res4, res5, res6, res7)
#pval <- subset(pval, mode %in% c("a2", "d2"))
write.table(pval, "cache/pval_genic.csv", sep=",", row.names=FALSE, quote=FALSE)






