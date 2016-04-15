### Jinliang Yang
### test the accuracy differences


###################################################################################
library(plyr, lib="~/bin/Rlib/")
runttest <- function(res0){
  
  #res0$R2 <- res0$r^2
  res0$trait <- as.character(res0$trait)
  res0$type <- as.character(res0$type)
  res0$cs <- as.character(paste0("cs", res0$cs))
  res0$cv <- as.character(paste0("cv", res0$cv))
  res0$sp <- as.character(paste0("sp", res0$sp))
  
  tab <- ddply(res0, .(trait, type, cs, sp), summarise,
                r = mean(r),
                m = median(r))
  
  #tab$trait <- as.character(tab$trait)
  #tab$type <- as.character(tab$type)
  
  tab <- res0
  myt <- c( "dtp", "dts", "tw", "asi", "pht", "eht",  "gy")
  res <- data.frame()
  for(i in 1:7){
    real <- subset(tab, type == "real" & trait== myt[i])
    
    rand <- subset(tab, type == "cs" & trait == myt[i])
    nl <- subset(tab, type == "null" & trait == myt[i])
    
    message(sprintf("###>>> real [ %s ], null [ %s ] and random [ %s ]", 
                    nrow(real), nrow(nl), nrow(rand)))
    test <- t.test(real$r, rand$r)
    tem <- data.frame(trait = myt[i], pval=test$p.value,
                      r_real = mean(subset(res0, type == "real" & trait== myt[i] )$r),
                      r_cs = mean(subset(res0, type == "cs" & trait == myt[i] )$r))
    res <- rbind(res, tem)
  }
  return(res)
}


res1 <- read.csv("largedata/newGERPv2/res_a2_perse_42000.csv")
t1 <- runttest(res0=res1)

res2 <- read.csv("largedata/newGERPv2/res_d2_perse_42000.csv")
t2 <- runttest(res0=res2)

res3 <- read.csv("largedata/newGERPv2/res_k5_perse_42000.csv")
t3 <- runttest(res0=res3)


######
res4 <- read.csv("largedata/newGERPv2/res_d2_bph_42000.csv")
t4 <- runttest(res0=res4)

res5 <- read.csv("largedata/newGERPv2/res_k5_bph_42000.csv")
t5 <- runttest(res0=res5)


