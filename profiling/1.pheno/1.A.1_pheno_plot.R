## Jinliang Yang
## Oct. 13th, 2014
## phenotypic data of offpvp diallel

setwd("~/Documents/Github/pvpDiallel")
trait <- read.csv("data/trait_matrix.csv")

#######
plot_trait_perse <- function(trait=trait), ...{
  par(mar=c(2,2,3,2))
  layout(matrix(c(1,1,2,3,4,1,1,5,6,7), 2, 5, byrow = TRUE))
  ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
  for(i in 1:length(ti)){
    myp <- subset(trait, trait==ti[i])
    myp$norv <- scale(myp$valHyb)
    plot(density(myp$norv), col="black", lwd=4, bty="n",
         main=ti[i], xlab="", ...)
  }
}
#####
plot_trait_perse(trait=trait)

