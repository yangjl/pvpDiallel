## Jinliang
## 12/3/2014
## purpose: plot the correlat


### calculate pMPH and pHPH
library("plyr")
trait <- read.csv("data/trait_matrix.csv")
res1 <- ddply(trait, .(trait), summarise,
              median= abs(median(pMPH, na.rm=T)))
names(res1)[2] <- "pMPH" 
res2 <- ddply(trait, .(trait), summarise,
              median= abs(median(pBPHmax, na.rm=T)))
names(res2)[2] <- "pHPH"
heterosis <- merge(res1, res2, by="trait")

vars <- data.frame(trait=c("TW", "DTP", "DTS", "PHT", "EHT", "ASI", "GY"),
                   h2=c(65, 95, 96, 89, 88, 45, 41))

heterosis <- merge(heterosis, vars, by="trait")
heterosis <- heterosis[order(heterosis$pMPH),]


#####plot the correlation
par(mfrow=c(1,2))
plot(x=heterosis$pHPH, y=heterosis$h2, type="p", ylim=c(0,100), xlab="pBPH", ylab="h^2 (SNP)", main="Better Parental Heterosis")
cor.test(x=heterosis$pHPH, y=heterosis$h2)
reg2 <- lm(h2~pHPH, data=heterosis)
abline(reg2, lwd=2, col="red")

plot(x=heterosis$pMPH, y=heterosis$h2, type="p", ylim=c(0, 100), xlab="pMPH", ylab="h^2 (SNP)", main="Mid-Parental Heterosis")
cor.test(x=heterosis$pMPH, y=heterosis$h2)
reg1 <- lm(h2~pMPH, data=heterosis)
abline(reg1, lwd=2, col="red")
