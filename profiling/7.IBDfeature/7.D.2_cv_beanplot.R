### Jinliang Yang
### beanplot

#http://www.jstatsoft.org/v28/c01/paper

res0 <- read.csv("cache/cv_exon_BPHmax.csv")

table(subset(res0, type=="real")$trait)
table(subset(res0, type=="random")$trait)


library("beanplot")


res1 <- subset(res0, mode %in% c("3d2", "4d2"))
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$mode <- factor(res1$mode, levels = c("3d2", "4d2"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ mode + trait, data = res1, ll = 0.04, cex=1.5,
         main = "Dominant for BPHmax (Exon GERP >0 and GERP <0)", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))


res1 <- subset(res0, mode == "d2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$type <- factor(res1$type, levels = c("real", "random"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5,
         main = "Dominant GERP Score for pHPH", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))










myt <- c("tw", "dtp", "dts", "pht", "eht", "asi", "gy")
runttest <- function(mymode="d2", mytrait=myt[1]){
  test <- t.test(subset(res0, type=="real" & trait== mytrait & mode == mymode)$r, 
                 subset(res0, type=="random" & trait == mytrait & mode == mymode)$r, alternative ="greater")
  print(test)
}
runttest(mymode="a2", mytrait=myt[7])
for(i in 1:7){
  runttest(mymode="d2", mytrait=myt[i])
}






