## Jinliang Yang
## Oct. 13th, 2014
## phenotypic data of offpvp diallel

setwd("/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/")

### pheno per se

pmatrix <- function(infile="Gvalues_Adj.GY", trait="GY"){
  nm <- c("Hyb", "P1", "P2", "valHyb", "valP1", "valP2", "BPHmax", "pBPHmax", 
          "BPHmin", "pBPHmin", "MPH", "pMPH")
  pheno <- read.table(infile, header=TRUE)
  names(pheno) <- nm
  pheno$trait <- trait
  return(pheno)  
} 

###
gy <- pmatrix(infile="Gvalues_Adj.GY", trait="GY")
asi <- pmatrix(infile="Gvalues_ASI", trait="ASI")
dtp <- pmatrix(infile="Gvalues_DTP", trait="DTP")
dts <- pmatrix(infile="Gvalues_DTS", trait="DTS")
eht <- pmatrix(infile="Gvalues_EHT", trait="EHT")
PHT <- pmatrix(infile="Gvalues_PHT", trait="PHT")
TW <- pmatrix(infile="Gvalues_TW", trait="TW")
















gy <- read.table("Gvalues_Adj.GY", header=TRUE)
asi <- read.table("Gvalues_ASI", header=TRUE)



hist(gy$valHyb)



