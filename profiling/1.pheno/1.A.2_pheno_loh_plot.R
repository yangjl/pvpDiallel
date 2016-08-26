# Jinliang Yang
# Octo. 27th, 2014
# updated 8/15/2016, changed the calculation of BPH for flowering time traits
# purpose: levels of heterosis


#######
plot_loh <- function(trait,  ...){
  bymed2 <- with(trait, reorder(trait, pBPH, median))
  boxplot(pBPH ~ bymed2, data=trait,
          xlab = "", ylab= "BPH (100%)", col="antiquewhite3", 
          ...)
}
##### note: change to abs value

trait <- read.csv("data/trait_matrix.csv")
trait$pBPH <- trait$pBPHmax
trait[trait$trait == "DTS", ]$pBPH <- -(trait[trait$trait == "DTS", ]$pBPHmin)
trait[trait$trait == "DTP", ]$pBPH <- -(trait[trait$trait == "DTP", ]$pBPHmin)
trait[trait$trait == "ASI", ]$pBPH <- -(trait[trait$trait == "ASI", ]$pBPHmin)

trait$pBPH <- trait$pBPH*100
trait <- subset(trait, pBPH<300)

bymed <- plot_loh(trait, main="")

pdf("graphs/Fig1b_v2.pdf", width=5, height=5)
bymed <- plot_loh(trait, main="")
dev.off()
write.table(trait, "manuscript/Figure_Table/STable_heterosis.csv", sep=",", row.names=FALSE, quote=FALSE)

#######################
trait <- read.csv("data/trait_matrix.csv")
trait$pBPH <- trait$pBPHmax
trait[trait$trait == "DTS", ]$pBPH <- -(trait[trait$trait == "DTS", ]$pBPHmin)
trait[trait$trait == "DTP", ]$pBPH <- -(trait[trait$trait == "DTP", ]$pBPHmin)
trait[trait$trait == "ASI", ]$pBPH <- -(trait[trait$trait == "ASI", ]$pBPHmin)

trait$BPH <- trait$BPHmax
trait[trait$trait == "DTS", ]$BPH <- -(trait[trait$trait == "DTS", ]$BPHmin)
trait[trait$trait == "DTP", ]$BPH <- -(trait[trait$trait == "DTP", ]$BPHmin)
trait[trait$trait == "ASI", ]$BPH <- -(trait[trait$trait == "ASI", ]$BPHmin)

write.table(trait, "data/trait_matrix_updated_BPH.csv", sep=",", row.names=FALSE, quote=FALSE)

##########
library(plyr)
loh <- ddply(trait, .(trait), summarise,
             h = median(pBPH))
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
