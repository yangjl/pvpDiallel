## Jinliang Yang
## Oct. 13th, 2014
## phenotypic data of offpvp diallel

#setwd("~/Documents/Github/pvpDiallel/")
trait2gs <- function(){
  
  trait <- read.csv("data/trait_matrix.csv")
  trait$Hyb <- paste(trait$P1, trait$P2, sep="x")
  
  ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
  
  for(i in 1:7){
    pheno <- subset(trait, trait==ti[i])
    pheno <- pheno[, c(1,4,5)]
    names(pheno) <- c("Genotype", ti[i], "Fix")
    pheno$Fix <- 1
    
    out <- paste("largedata/pheno/", tolower(ti[i]), ".txt", sep="")
    write.table(pheno, out, sep="\t", row.names=FALSE, quote=FALSE) 
    message(sprintf(">>> output pheno [ %s ] to [ %s ]", ti[i], out)) 
  } 
}

trait2gs()
