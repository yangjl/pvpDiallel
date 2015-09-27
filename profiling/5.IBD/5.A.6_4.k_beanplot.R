### Jinliang Yang
### beanplot

library("beanplot")


#http://www.jstatsoft.org/v28/c01/paper


mybean <- function(res0, mymode="a2"){
  res0$mode <- as.character(res0$mode)
  res1 <- subset(res0, mode == mymode)
  #print(nrow(res1))
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

res0 <- read.csv("~/Desktop/g2_k_perse.csv")
res0$type <- res0$cs
res0$type <- gsub("cs0", "real", res0$type)
res0$type <- gsub("cs.*", "random", res0$type)


library(ggplot2, lib="~/bin/Rlib/")
library(plyr)

res1 <- subset(res0, sp %in% c("sp1", "sp4", "sp5", "sp6", "sp8"))
res2 <- ddply(res0, .(type, trait, mode), summarise,
              r = mean(r),
              m = median(r))
res2$type <- res2$cs
res2$type <- gsub("cs0", "real", res2$type)
res2$type <- gsub("cs.*", "random", res2$type)


par(mfrow=c(1,3))
mybean(res2, mymode = "a2")
mybean(res2, mymode = "d2")
mybean(res2, mymode = "h2")



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









# A basic box with the conditions colored
library(ggplot2, lib="~/bin/Rlib/")

res0 <- read.csv("cache/g2_k_perse.csv")
res0 <- subset(res0, type=="real")
out2 <- ddply(res0, .(sp, trait, mode), summarise,
              r = mean(r),
              m = median(r))
out2$trait <- toupper(out2$trait)
out2$trait <- factor(out2$trait, levels = toupper(c("asi", "dts", "dtp", "tw", "pht", "eht", "gy")))

p2 <- ggplot(data=out2) +
  geom_boxplot(aes(x= mode, y=r, fill= factor(mode, labels=c("A", "D", "k")) ) ) +
  #guides(fill=FALSE) +
  labs(y=NULL, fill="") + theme_bw() +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  xlab("Trait per se") + ylab("Prediction Accuracy (r)") + facet_grid(~ trait) 

pdf("graphs/Figure5_a.pdf", height=5, width=10)
p2
dev.off()




###################################################################################
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
  runttest(res1, mymode="h2", mytrait=myt[i])
}



