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

plot(x=heterosis$pMPH, y=heterosis$h2, type="o")
