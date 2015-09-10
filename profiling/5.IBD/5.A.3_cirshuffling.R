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
library(data.table, lib="~/bin/Rlib/")
gerp <- fread("largedata/SNP/allsnps_11m_gerpv2_tidy.csv", sep=",")
gerp <- subset(gerp, RS>0)
write.table(gerp, "largedata/SNP/gerpv2_b0_real.csv", sep=",", row.names=FALSE, quote=FALSE)

CirShuffling(gerp=gerp, SN=50000, times=10, outfile="largedata/SNP/gerpv2_b0")



