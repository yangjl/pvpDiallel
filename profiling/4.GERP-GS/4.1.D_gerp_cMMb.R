### Jinliang Yang
### GERP in cM/Mb
### Feb 3th, 2016


### server and local
gerp <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")
gerp <- gerp[, 1:8]
write.table(gerp, "cache/gerpsnp_506898_gp.csv", sep=",", row.names=FALSE, quote=FALSE)

gerp <- read.csv("cache/gerpsnp_506898_gp.csv")


library(plyr)
BINSIZE = 5000000
gerp$bin <- paste(gerp$chr, round(gerp$pos/BINSIZE, 0), sep="_")
res <- ddply(gerp, .(bin), summarise,
            mgerp = mean(RS),
            gen = 1000000*(max(genetic) - min(genetic))/(max(pos) - min(pos)) )
range(res$gen)

t.test(subset(res, gen < 0.5)$mgerp, subset(res, gen > 0.5)$mgerp)

res$sq <- 0
res[res$gen < 0.5, ]$sq <- 1
res[res$gen >= 0.5, ]$sq <- 2

table(res$sq)

library("beanplot")
pdf("graphs/Fig1d.pdf", width=5, height=5)
beanplot(mgerp ~ sq, data = res, kernel="cosine", ll = 0.04, cex=1.5, side = "no", cut=3,
         border = NA, col="antiquewhite3", xaxt="n", ylab="GERP Score", xlab="Recombination rate (cM/Mb)")
axis(side =1, at =1:2, labels =c("< 0.5", " >= 0.5"))
dev.off()


