# Jinliang Yang
# Octo. 27th, 2014
# purpose: levels of heterosis


#######
plot_loh <- function(trait=trait, ...){
  trait$pMPH <- abs(trait$pMPH)
  trait$pBPHmax <- abs(trait$pBPHmax)
  trait$pBPHmin <- abs(trait$pBPHmin)
  #par(mfrow=c(1,2))
  #bymed <- with(trait, reorder(trait, pMPH, median))
  #boxplot(BPHmax ~ bymed, data=trait,
  #        xlab = "phenotypic traits", ylab= "BPH", col="lightgray", 
  #        main="better parental heterosis")
  
  bymed2 <- with(trait, reorder(trait, pBPHmax, median))
  boxplot(pBPHmax ~ bymed2, data=trait,
          xlab = "Phenotypic Traits", ylab= "percent BPH", col="lightgray", 
          main="Percentage of Better Parental Heterosis")
  return(trait)
}
##### note: change to abs value
trait <- read.csv("data/trait_matrix.csv")
trait[trait$trait == "ASI", ]$pBPHmax <- trait[trait$trait == "ASI", ]$pBPHmin
trait[trait$trait == "ASI", ]$BPHmax <- trait[trait$trait == "ASI", ]$BPHmin

pdf("manuscript/Figure_Table/Sfig_pBPH.pdf", width=5, height=5)
trait <- plot_loh(trait=trait)
dev.off()

####>>>>
mean(trait$BPHmax)
sd(trait$BPHmax)
mean(trait$pBPHmax) #0.33
sd(trait$pBPHmax) #0.45

mean(subset(trait, trait == "GY")$BPHmax) #95.01229 
sd(subset(trait, trait == "GY")$BPHmax) #16
