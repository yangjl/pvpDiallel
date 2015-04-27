### Jinliang Yang
### beanplot

#####
res1 <- runttest(resfile="cache/gerpall_perse.csv")
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


library("beanplot")


res1 <- subset(res0, mode == "a2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$type <- factor(res1$type, levels = c("real", "random"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5,
         main = "Additive GERP Score for pHPH", ylab = "cross-validation accuracy", side = "both",
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












