### Jinliang Yang
### beanplot

library("beanplot")


#http://www.jstatsoft.org/v28/c01/paper


mybean <- function(res0, mode){

  res1 <- subset(res0, mode == mode)
  par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
  res1$type <- factor(res1$type, levels = c("real", "random"))
  res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
  beanplot(r ~ type + trait, data = res1, ll = 0.04, cex=1.5,
           main = "Additive GERP Score", ylab = "cross-validation accuracy", side = "both",
           border = NA, col = list(c("blue", "red"), c("grey", "black")))
  #legend("bottomleft", fill = c("black", "grey"),
  #       legend = c("Group 2", "Group 1"))
  #return(res0)
  
}

res0 <- read.csv("cache/g0_k_perse.csv")
res0$type <- res0$cs
res0$type <- gsub("cs0", "real", res0$type)
res0$type <- gsub("cs.*", "random", res0$type)


library(ggplot2, lib="~/bin/Rlib/")
library(plyr)
test <- ddply(res0, .(mode, type, trait, sp), summarise,
              r = mean(r))

par(mfrow=c(1,3))
mybean(test, mode = "a2")
mybean(test, mode = "d2")
mybean(test, mode = "h2")



res1 <- subset(res0, mode == "d2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$type <- factor(res1$type, levels = c("real", "random"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5,
         main = "Dominant GERP Score", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))

res1 <- subset(res0, mode == "h2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))

out$trait <- factor(out$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))

out$trait <- "gy"
out$type <- factor(out$type, levels = c("real", "random"))
beanplot(R2 ~ type + trait, data = out, ll = 0.04, cex=1.5,
         main = "h GERP Score", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))






myt <- c("tw", "dtp", "dts", "pht", "eht", "asi", "gy")
runttest <- function(res0, mymode="h2", mytrait=myt[7]){
  
  res0$R2 <- res0$r^2
  real <- subset(res0, cs == "cs0" & trait== mytrait & mode == mymode)
  rand <- subset(res0, cs != "cs0" & trait == mytrait & mode == mymode)
  
  real$sp <- as.character(real$sp)
  sps <- unique(real$sp)
  out1 <- data.frame()
  for(i in 1:length(sps)){
    tem <- data.frame(sp=sps[i], R2= mean(subset(real, sp==sps[i])$R2), r=mean(subset(real, sp==sps[i])$r))
    out1 <- rbind(out1, tem)
  }
  
  rand$sp <- as.character(rand$sp)
  sps2 <- unique(rand$sp)
  cs <- as.character(rand$cs)
  css <- unique(rand$cs)
  out2 <- data.frame()
  for(i in 1:length(css)){
    sub <- subset(rand, cs==css[i])
    for(j in 1:length(sps)){
      tem <- data.frame(cs=css[i], sp=sps[j], R2= mean(subset(sub, sp==sps[j])$R2), r=mean(subset(sub, sp==sps[j])$r))
      out2 <- rbind(out2, tem)
    }
  }
  
  test <- t.test(out1$R2, out2$R2, alternative ="greater")
  print(sprintf("### Trait [ %s ]", mytrait))
  print(test)
  #return(rbind(out1, out2[, -1]))
}


for(i in 1:7){
  runttest(res0, mymode="h2", mytrait=myt[i])
}



