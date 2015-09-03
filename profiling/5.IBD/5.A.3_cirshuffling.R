### Jinliang
### Jan. 8th, 2015

### circular shuffling
CirShuffling <- function(gerp=gerp, SN=1000000, times=10, outfile="allsnps_11m_gerpv2"){
  for(i in 1:times){
    gerp$RS <- c(gerp$RS[(SN + 1):nrow(gerp)], gerp$RS[1:SN])
    outfile0 <- paste(outfile, "_cs", i, ".csv", sep="")
    write.table(gerp, outfile0, sep=",", row.names=FALSE, quote=FALSE)
    message(sprintf(">>> output [ %s ] !!!", outfile0))
  }
}

#########
library(data.table)
gerp <- fread("largedata/SNP/allsnps_11m_gerpv2_tidy.csv", sep=",")
CirShuffling(gerp=gerp, SN=50000000, times=10, outfile="largedata/SNP/allsnps_11m_gerpv2_50m")



