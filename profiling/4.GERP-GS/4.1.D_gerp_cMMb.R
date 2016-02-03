### Jinliang Yang
### GERP in cM/Mb


##############################################
tab_p2g <- function(tab, map, binsize=1000000){
  source("lib/p2g.R")
  
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
    print(mean(tem$cmmb))
    print(summary(tem$cmmb))
    out <- rbind(out, tem)
  }
  return(out)
}

### server and local
ob1 <- load("cache/4.1.B_gerpbins.RData")
map <- read.csv("data/gam_p2g_traindata.csv")

ob2 <- load("cache/4.1.B_gerpbins_big0.RData")


res1 <- tab_p2g(tab=tab1m, map, binsize=1000000)

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

