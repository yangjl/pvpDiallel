# Jinliang Yang
# Octo. 27th, 2014
# purpose: levels of heterosis


#######
plot_loh <- function(trait=trait, ...){
  bymed2 <- with(trait, reorder(trait, pBPHmax, median))
  boxplot(pBPHmax ~ bymed2, data=trait,
          xlab = "", ylab= "BPH (100%)", col="antiquewhite3", 
          ...)
}
##### note: change to abs value
trait <- read.csv("data/trait_matrix.csv")
write.table(trait, "manuscript/Figure_Table/STable_heterosis.csv")

trait[trait$trait == "DTS", ]$pBPHmax <- abs(trait[trait$trait == "DTS", ]$pBPHmin)
trait[trait$trait == "DTP", ]$pBPHmax <- abs(trait[trait$trait == "DTP", ]$pBPHmin)
trait[trait$trait == "ASI", ]$pBPHmax <- abs(trait[trait$trait == "ASI", ]$pBPHmin)
trait$pBPHmax <- trait$pBPHmax*100
trait <- subset(trait, pBPHmax<300)

pdf("graphs/Fig1b_v2.pdf", width=5, height=5)
bymed <- plot_loh(trait=trait, main="")
dev.off()


##########
library(plyr)
loh <- ddply(trait, .(trait), summarise,
             h = median(pBPHmax))
loh <- loh[order(loh$h),]
write.table(loh, "cache/loh_pBPHmax_median.csv", sep=",", row.names=FALSE, quote=FALSE)


####>>>>
mean(trait$BPHmax)
sd(trait$BPHmax)
mean(trait$pBPHmax) #0.33
sd(trait$pBPHmax) #0.45

mean(subset(trait, trait == "GY")$pBPHmax) #95.01229 
sd(subset(trait, trait == "GY")$pBPHmax) #16

median(subset(trait, trait == "GY")$BPHmax) 
