### Jinliang Yang
### GERP in cM/Mb


##############################################
tab_p2g <- function(tab,  binsize=1000000){
  source("lib/p2g.R")
  
  map <- read.csv("~/Documents/Github/zmSNPtools/shareData/ISU_integrated_IBM_AGPv2_training.csv")
  map$Physical <- as.numeric(as.character(gsub(",", "", map$Physical)))
  
  #Input file:  Three columns: 1.marker_name 2.chromosome (Integer) 
  #3. Physical position (Colname must be Physical);
  names(tab) <- c("marker_name", "binrs", "chrosomosome", "Physical")
  tab1 <- tab[, -2]
  tab1$Physical <- tab1$Physical*binsize
  tab1 <- tab1[order(tab1[,2], tab1[,3]),]
  res <- p2g(predict=tab1, train=map) 
  res <- merge(res, tab[, -3:-4], by.x="marker", by.y="marker_name")
  res <- res[order(res$chr, res$physical),]
  
  out <- data.frame()
  for(i in 1:10){
    tem <- subset(res, chr == i)
    tem$cmmb <- c(0, (tem$genetic[-1] - tem$genetic[-length(tem$genetic)])/(tem$physical[-1] - tem$physical[-length(tem$physical)]) )
    tem <- tem[-1, ]
    tem$cmmb <- tem$cmmb*1000000
    #tem <- subset(tem, abs(cmmb) < 5)
    tem$cmmb <- abs(tem$cmmb)
    print(mean(tem$cmmb))
    print(summary(tem$cmmb))
    out <- rbind(out, tem)
  }
  return(out)
}

### server and local

gerp <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")
gerp <- gerp[, 1:8]
write.table(gerp, "cache/gerpsnp_506898_gp.csv", sep=",", row.names=FALSE, quote=FALSE)

gerp <- read.csv("cache/gerpsnp_506898_gp.csv")


BINSIZE = 5000000
gerp$bin <- paste(gerp$chr, round(gerp$pos/BINSIZE, 0), sep="_")
res <- ddply(gerp, .(bin), summarise,
            mgerp = mean(RS),
            gen = 1000000*(max(genetic) - min(genetic))/(max(pos) - min(pos)) )
range(res$gen)

head(gerp)
res$sq <- 0
res[res$gen < 0.5, ]$sq <- 1
res[res$gen >= 0.5, ]$sq <- 2
#res[res$gen >= 1 & res$gen < 4, ]$sq <- 3
#res[res$gen >=1, ]$sq <- 3
table(res$sq)
boxplot(mgerp ~ sq, col="antiquewhite3", data=res, ylab="Mean GERP score", xlab="Recombination rate", xaxt="n")
axis(side =1, at =1:2, labels =c("< 0.5", " >= 0.5"))

t.test(subset(res, gen < 0.5)$mgerp, subset(res, gen > 0.5)$mgerp)




cor.test(res$mgerp, res$gen)

plot(res$gen, res$mgerp, xlab="cM/Mb", ylab="Mean GERP")
fit <- glm(mgerp ~ log(gen), data=res, family="gaussian")
summary(fit)
abline(fit, col="blue", lwd=3)

lw1 = loess(mgerp ~ gen, data=res, span=0.1)
j <- order(res$gen)
lines(res$gen[j], lw1$fitted, col="blue", lwd=3)



library("beanplot")
beanplot(mgerp ~ sq, data=res, ll = 0.04, cex=1.5,
         side = "both", border = NA)


ob1 <- load("cache/4.1.B_gerpbins.RData")
map <- read.csv("data/gam_p2g_traindata.csv")

ob2 <- load("cache/4.1.B_gerpbins_big0.RData")


res1 <- tab_p2g(tab=tab1m, binsize=1000000)


fit <- lm(mgerp ~ gen, data=res)
summary(fit)









library(plyr)

res1 <- tab_p2g(tab=tab100k, map, binsize=100000)

res1$c <- round(res1$cmmb, 3)


d <- ddply(res1, .(c), summarise,
           mgerp= mean(binrs))

d <- subset(d, c < 10 & c >0)

lw1 = loess(mgerp ~ c, data=d)
plot(mgerp ~ c, data=d, pch=19, cex=0.5, xlab="cM/Mb (recombination rate)", ylab="GERP socre")

j <- order(d$c)
lines(d$c[j], lw1$fitted, col="blue", lwd=3)

plot(res1$cmmb, res1$binrs)

res1 <- subset(res1, genetic > 0 & cmmb > 0)
lw1 = loess(binrs ~ cmmb, data=res1, span=0.9)
plot(binrs ~ cmmb, data=res1, pch=19, cex=0.5)

j <- order(res1$cmmb)
lines(res1$cmmb[j], lw1$fitted, col="blue", lwd=3)



res2 <- tab_p2g(tab=tab100k, map, binsize=100000)
res2 <- subset(res2, genetic > 0 & cmmb > 0 & cmmb < 10)

lw1 = loess(binrs ~ cmmb, data=res2, span=0.1)
plot(binrs ~ cmmb, data=res2, pch=19, cex=0.1)
j <- order(res2$cmmb)
lines(res2$cmmb[j], lw1$fitted, col="blue", lwd=3)


res3 <- tab_p2g(tab=tab10k, map, binsize=10000)
res3 <- subset(res3, genetic > 0 & cmmb > 0 & cmmb < 10)

lw1 = loess(binrs ~ cmmb, data=res3)
plot(binrs ~ cmmb, data=res3, pch=19, cex=0.1)
j <- order(res3$cmmb)
lines(res3$cmmb[j], lw1$fitted, col="blue", lwd=3)

library(ggplot2)
p1 <- ggplot(res3, aes(x=RS, y=Effect_A, colour=factor(trait, levels=med2$trait),
                      linetype=factor(trait, levels=med2$trait))) +
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Additive Effect") +
  #  (by default includes 95% confidence region)
  #scale_fill_manual(values=c("#008080", "#003366", "#40e0d0", "#ffa500", "#f6546a", "#ff00ff", "#800000")) +
  #http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
  scale_color_manual(values=cols) +
  scale_linetype_manual(values=lty1) +
  guides(colour=FALSE, linetype=FALSE) +
  
  geom_smooth(method="gam", size=1.3) +
  theme(axis.text.y = element_text(angle = 90, hjust = 1))

