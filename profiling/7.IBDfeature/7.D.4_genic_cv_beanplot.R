### Jinliang Yang
### beanplot

#http://www.jstatsoft.org/v28/c01/paper

res0 <- read.csv("cache/cv_genic_BPHmax.csv")
res0$type <- "realgenic"
res0$mode <- gsub("^1", "", res0$mode)
res0 <- res0[, c("file", "R2", "r", "trait", "type", "mode", "sp", "cv")]

res_cs <- read.csv("cache/genic_cv_cs_pHPH.csv")
names(res_cs)[5] <- "type"

res0 <- res_cs
res0$type <- as.character(res0$type)
res0[res0$type %in% "cs0",]$type <- "realgenic"
res0[res0$type != "realgenic", ]$type <- "cs"


#res0 <- rbind(res0, res_cs)

table(subset(res0, type=="real")$trait)
table(subset(res0, type=="random")$trait)


library("beanplot")


res1 <- subset(res0, type=="realgenic" & mode %in% c("a2", "d2"))
#par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$mode <- factor(res1$mode, levels = c("a2", "d2"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(r ~ mode + trait, data = res1, ll = 0.04, cex=1.5,  ylim=c(0, 1),
         main = "Dominant for BPHmax (Exon GERP >0 and GERP <0)", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
legend("bottomleft", fill = c("black", "grey"),
       legend = c("Group 2", "Group 1"))



res1 <- subset(res0, mode == "a2")
#par(mfrow=c(2,2))
res1$type <- factor(res1$type, levels = c("realgenic", "cs"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5,  overallline = "median",
         main = "Additive for pHPH", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("blue", "grey"),
#       legend = c("real data", "permutation"))


res1 <- subset(res0, mode == "d2")
#par(lend = 1)
res1$type <- factor(res1$type, levels = c("realgenic", "cs"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5, 
         main = "Dominant for pHPH", side = "both", ylab = "cross-validation accuracy",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))










runttest <- function(res0=res0, mymode="d2", mytrait=myt[1]){
  res <- data.frame()
  for(i in 1:length(mytrait)){
    test <- t.test(subset(res0, type=="realgenic" & trait== mytrait[i] & mode == mymode)$r, 
                   subset(res0, type=="cs" & trait == mytrait[i] & mode == mymode)$r, alternative ="greater")
    tem <- data.frame(trait=mytrait[i], pval=test$p.value)
    res <- rbind(res, tem)
  }
  return(res)
}

#####
myt <- c("tw", "dtp", "dts", "pht", "eht", "asi", "gy")
runttest(res0=res0, mymode="d2", mytrait=myt[c(2:3,5:7)])







