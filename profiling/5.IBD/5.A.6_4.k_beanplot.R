### Jinliang Yang
### beanplot

library("beanplot")
#http://www.jstatsoft.org/v28/c01/paper
mybean <- function(res0, mymode="a2", ...){
  res0$mode <- as.character(res0$mode)
  res1 <- subset(res0, mode == mymode)
  res1$trait <- toupper(res1$trait)
  #print(nrow(res1))
  par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
  res1$type <- factor(res1$type, levels = c("real", "random"))
  res1$trait <- factor(res1$trait, levels = toupper(c("asi", "dts", "dtp", "tw", "pht", "eht", "gy")))
  beanplot(m ~ type + trait, data = res1, kernel="cosine", ll = 0.04, cex=1.5, side = "both", bw=0.02,
           border = NA, col = list(c("#d41243", "#d41243"), c("#00aedb", "#00aedb")), ...)
  #legend("bottomleft", fill = c("black", "grey"),
  #       legend = c("Group 2", "Group 1"))
  #return(res0)
  
}

############################################################

library(ggplot2, lib="~/bin/Rlib/")
library(plyr)

res0 <- read.csv("cache/g0_k_perse.csv")

res1 <- ddply(res0, .(type, trait, mode, sp), summarise,
              r = mean(r),
              m = median(r))

res0 <- read.csv("cache/g0_k_bph.csv")

res2 <- ddply(res0, .(type, trait, mode, sp), summarise,
              r = mean(r),
              m = median(r))




############
pdf("graphs/Figure5_6plots.pdf", height=8, width=12)
par(mfrow=c(2,3))
mybean(res1, mymode = "a2", ylim=c(0, 1), main="Additive", ylab="Cross-validation Accuracy")
mybean(res1, mymode = "d2", ylim=c(0, 1), main="Dominance", ylab="Cross-validation Accuracy")
mybean(res1, mymode = "h2", ylim=c(0, 1), main="Incomplete Dominance", ylab="Cross-validation Accuracy")

mybean(res2, mymode = "a2", ylim=c(0, 1), main="Additive", ylab="Cross-validation Accuracy")
mybean(res2, mymode = "d2", ylim=c(0, 1), main="Dominance", ylab="Cross-validation Accuracy")
mybean(res2, mymode = "h2", ylim=c(0, 1), main="Incomplete Dominance", ylab="Cross-validation Accuracy")

dev.off()


############
pdf("graphs/Figure5_2plot2.pdf", height=5, width=10)
par(mfrow=c(1,2))
mybean(res1, mymode = "h2", ylim=c(0, 1), main="Trait per se", ylab="Cross-validation Accuracy")
mybean(res2, mymode = "h2", ylim=c(0, 1), main="Heterosis", ylab="Cross-validation Accuracy")
dev.off()










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
  real <- subset(res0, type == "real" & trait== mytrait & mode == mymode)
  rand <- subset(res0, type == "random" & trait == mytrait & mode == mymode)
  
  message(sprintf("###>>> real [ %s ] and random [ %s ]", nrow(real), nrow(rand)))
  test <- t.test(real$r, rand$r, alternative ="greater")
  print(sprintf("### Trait [ %s ]", mytrait))
  print(test)
  #return(rbind(out1, out2[, -1]))
}


for(i in 1:7){
  runttest(res2, mymode="d2", mytrait=myt[i])
}



