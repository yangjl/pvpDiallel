## Jinliang Yang
## Oct. 13th, 2014
## phenotypic data of offpvp diallel

#setwd("~/Documents/Github/pvpDiallel/")
trait <- read.csv("data/trait_matrix.csv")

#######
plot_trait_per_se <- function(trait=trait, ...){
  par(mar=c(3,3,4,1))
  layout(matrix(c(1,1,2,3,4,1,1,5,6,7), 2, 5, byrow = TRUE))
  ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
  for(i in 1:length(ti)){
    myp <- subset(trait, trait==ti[i])
    myp$norv <- scale(myp$valHyb)
    d <- density(myp$norv)
    plot(d, main=ti[i], xlab="", cex.axis=1, bty="n", ...)
    polygon(d, col="antiquewhite3", border="antiquewhite3", lwd=3)
  }
}
#####
pdf("graphs/Fig1a.pdf", width=8, height=4)
plot_trait_per_se(trait=trait)
dev.off()


normality_test <- function(trait=trait){
  ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
  
  res <- vector()
  for(i in 1:length(ti)){
    myp <- subset(trait, trait==ti[i])
    out <- shapiro.test(myp$valHyb)
    res <- c(res, out$p.value)
  }
  return(res)
}

#######
res <- normality_test(trait=trait)



