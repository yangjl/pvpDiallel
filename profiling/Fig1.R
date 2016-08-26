### Jinliang Yang
### 2016-08-16

##################### Figure 1a
#setwd("~/Documents/Github/pvpDiallel/")
H2 <- read.csv("data/DIalleleHeritability.csv")
h <- read.csv("cache/loh_pBPHmax_median.csv")
H2 <- merge(H2, h, by.x="Traits", by.y="trait")
H2 <- H2[order(H2$h),]

pdf("graphs/Fig1a_v3.pdf", width=5, height=5)
barplot(H2[,4], ylim=c(0, 1), col="antiquewhite3", names.arg = H2$Traits, ylab="Heritability", 
        cex.axis=1.3, cex.names=1.3, cex.lab=1.3)
box()
dev.off()

##################### Figure 1b
plot_loh <- function(trait,  ...){
  bymed2 <- with(trait, reorder(trait, pBPH, median))
  boxplot(pBPH ~ bymed2, data=trait,
          xlab = "", ylab= "BPH (100%)", col="antiquewhite3", 
          ...)
}
trait <- read.csv("manuscript/Figure_Table/STable_heterosis.csv")
pdf("graphs/Fig1b_v3.pdf", width=5, height=5)
bymed <- plot_loh(trait, main="", cex.axis=1.3, cex.lab=1.3)
dev.off()


