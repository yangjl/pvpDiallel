### Jinliang Yang
### 12. 3rd, 2014
### purpose: apply gam and project the genomic position to cM

get_training_map <- function(){
  nammap <- read.csv("data/NAM_map_20080419.csv")
  nammap <- nammap[, 1:5]
  phy <- read.csv("data/NAM_1144SNPs_AGPv2_positions.csv")
  phy <- phy[, 1:6]
  
  map <- merge(nammap, phy, by.x="marker", by.y="SNP_NAME")
  map <- map[, c("marker", "ch", "cumulative", "AGPv2_pos")]
  names(map) <- c("Marker", "Chr", "Genetic", "Physical")
  map <- map[map$Physical != "unknown", ]
  map$Physical <- as.numeric(as.character(map$Physical))
  return(map)
}

map <- get_training_map()


##############################################
use_p2g <- function(training=map){
  source("lib/p2g.R")
  
  ### format data for predicting genetic position
  ###
  pfile <- read.table("largedata/SNP/allsnps_11m.map", sep="\t", header=TRUE)
  names(pfile)[1:3] <- c("marker_name", "chromosome", "Physical")
  #Input file:  Three columns: 1.marker_name 2.chromosome (Integer) 
  #3. Physical position (Colname must be Physical);
  pfile$chromosome <- as.numeric(as.character(pfile$chromosome))
  pfile$Physical <- as.numeric(as.character(pfile$Physical))
  gp <- p2g(train=map, predictdf=pfile[,1:3]) 
  gp$genetic <- 1000000*gp$genetic
  gp <- gp[, c(1,2,4)]
  names(gp) <- c("snpid", "AGPv2_chr", "AGPv2_pos")
  return(gp)
}


snpmap <- use_p2g(training=map)
write.table(snpmap, "largedata/SNP/allsnps_11m_genetic.map", sep="\t", row.names=FALSE, quote=FALSE)

