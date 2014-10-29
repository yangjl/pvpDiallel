## Jinliang Yang
## Oct. 13th, 2014
## phenotypic data of offpvp diallel

#setwd("~/Documents/Github/pvpDiallel/")
ca <- read.csv("data/trait_CA.csv")

#######
get_GCA_matrix <- function(trait=ca){
  ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
  out <- trait[, c("P1", "GCA1.all")]
  out <- out[!duplicated(out$P1), ]
  for(i in 1:length(ti)){
    myp <- subset(trait, trait==ti[i])
    myp <- myp[, c("P1", "GCA1.all")]
    myp <- myp[!duplicated(myp$P1), ]
    names(myp)[2] <- ti[i]
    
    out <- merge(out, myp)
  }
  row.names(out) <- out$P1
  return(out[, -1:-2])
}

GCA <- get_GCA_matrix(trait=ca)



