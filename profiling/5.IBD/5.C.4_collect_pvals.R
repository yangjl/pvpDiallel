### Jinliang Yang
### beanplot

#http://www.jstatsoft.org/v28/c01/paper

runttest <- function(resfile="cache/gerpall_perse.csv"){
  resin <- read.csv(resfile)
  print(table(resin$trait))
  print(head(resin))
  #### >>>>
  res <- data.frame()
  myt <- unique(resin$trait)
  resin$cs <- gsub("cs.*", "cs", resin$cs)
  mode <- unique(resin$mode)
  for(ti in myt){
    for(modei in mode){
      test <- t.test(subset(resin, cs=="real" & trait== ti & mode == modei)$r, 
                     subset(resin, cs=="cs" & trait == ti & mode == modei)$r, alternative ="greater")
      tem <- data.frame(trait= ti, pval=test$p.value, mode=modei,
                        r_real=mean(subset(resin, cs=="real" & trait== ti & mode == modei)$r),
                        r_cs=mean(subset(resin, cs=="cs" & trait == ti & mode == modei)$r))
      res <- rbind(res, tem)
    }
    
  }
  res$file <- resfile
  return(res)
}

#####
res1 <- runttest(resfile="cache/gerpall_h_perse_gy.csv")
res2 <- runttest(resfile="cache/gerpall_BPHmax.csv")
res3 <- runttest(resfile="cache/gerpall_pBPHmax.csv")
res4 <- runttest(resfile="cache/gerpall_BPHmin.csv")
res5 <- runttest(resfile="cache/gerpall_pBPHmin.csv")
res6 <- runttest(resfile="cache/gerpall_MPH.csv")
res7 <- runttest(resfile="cache/gerpall_pMPH.csv")

pval <- rbind(res1, res2, res3, res4, res5, res6, res7)
pval <- subset(pval, mode %in% c("a2", "d2"))
write.table(pval, "cache/pval_gerpall.csv", sep=",", row.names=FALSE, quote=FALSE)



##################################################################################################################









