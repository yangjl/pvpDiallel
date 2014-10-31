## Jinliang Yang
## Oct. 13th, 2014
## phenotypic data of offpvp diallel

#setwd("~/Documents/Github/pvpDiallel/")
trait <- read.csv("data/trait_matrix.csv")
trait$Hyb <- paste(trait$P1, trait$P2, sep="x")


gy <- subset(trait, trait=="GY")
gy <- gy[, c(1,4,5)]
names(gy) <- c("Genotype", "GY", "Fix")
gy$Fix <- 1

write.table(gy, "largedata/pheno/gy_diallel.txt",sep="\t", row.names=FALSE, quote=FALSE)
