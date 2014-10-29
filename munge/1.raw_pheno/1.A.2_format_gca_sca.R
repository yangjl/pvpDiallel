## Jinliang Yang
## Oct. 13th, 2014
## combining abilities of offpvp diallel


# pheno per se
ca_matrix <- function(infile="Gvalues_Adj.GY", trait="GY"){
  nm3 <- c("Hyb", "P1", "P2")
  pheno <- read.table(infile, header=TRUE)
  names(pheno)[1:3] <- nm3
  pheno$trait <- trait
  message(sprintf("[ %s ] rows loaded for trait [ %s ]!", nrow(pheno), trait))
  return(pheno)  
} 

#######
gy <- ca_matrix(infile="/Users/yangjl/Documents/Data/pvpDiallel/pheno/GCA-SCA_Adj.GY.txt", trait="GY")
asi <- ca_matrix(infile="/Users/yangjl/Documents/Data/pvpDiallel/pheno/GCA-SCA_ASI.txt", trait="ASI")
dtp <- ca_matrix(infile="/Users/yangjl/Documents/Data/pvpDiallel/pheno/GCA-SCA_DTP.txt", trait="DTP")
dts <- ca_matrix(infile="/Users/yangjl/Documents/Data/pvpDiallel/pheno/GCA-SCA_DTS.txt", trait="DTS")
eht <- ca_matrix(infile="/Users/yangjl/Documents/Data/pvpDiallel/pheno/GCA-SCA_EHT.txt", trait="EHT")
pht <- ca_matrix(infile="/Users/yangjl/Documents/Data/pvpDiallel/pheno/GCA-SCA_PHT.txt", trait="PHT")
tw <- ca_matrix(infile="/Users/yangjl/Documents/Data/pvpDiallel/pheno/GCA-SCA_TW.txt", trait="TW")

trait <- rbind(gy, asi, dtp, dts, eht, pht, tw)
#head(trait)
write.table(trait, "data/trait_CA.csv", sep=",",
            row.names=FALSE, quote=FALSE)
