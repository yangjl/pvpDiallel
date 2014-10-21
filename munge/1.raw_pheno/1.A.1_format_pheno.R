## Jinliang Yang
## Oct. 13th, 2014
## phenotypic data of offpvp diallel


### pheno per se

pmatrix <- function(infile="Gvalues_Adj.GY", trait="GY"){
  nm <- c("Hyb", "P1", "P2", "valHyb", "valP1", "valP2", "BPHmax", "pBPHmax", 
          "BPHmin", "pBPHmin", "MPH", "pMPH")
  pheno <- read.table(infile, header=TRUE)
  names(pheno) <- nm
  pheno$trait <- trait
  message(sprintf("# [ %s ] rows loaded for trati [ %s ]!", nrow(pheno), trait))
  return(pheno)  
} 

###
gy <- pmatrix(infile="/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/Gvalues_Adj.GY", trait="GY")
asi <- pmatrix(infile="/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/Gvalues_ASI", trait="ASI")
dtp <- pmatrix(infile="/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/Gvalues_DTP", trait="DTP")
dts <- pmatrix(infile="/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/Gvalues_DTS", trait="DTS")
eht <- pmatrix(infile="/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/Gvalues_EHT", trait="EHT")
pht <- pmatrix(infile="/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/Gvalues_PHT", trait="PHT")
tw <- pmatrix(infile="/Users/yangjl/Box\ Sync/Projects/PVP-Diallel/GeneticValues/Gvalues_TW", trait="TW")

trait <- rbind(gy, asi, dtp, dts, eht, pht, tw)
#head(trait)
write.table(trait, "data/trait_matrix.csv", sep=",",
            row.names=FALSE, quote=FALSE)
