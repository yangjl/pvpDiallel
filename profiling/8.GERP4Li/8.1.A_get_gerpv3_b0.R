### Jinliang Yang
### exploring genome-wide feature of GERP score

library("data.table")

readgerp <- function(gerpfile="largedata/GERPv2/roast.chrom.10.msa.in.rates.full", chr=10){
  #### read the table fast
  chr1 <- fread(gerpfile, header=FALSE)
  names(chr1) <- c("N", "RS")
  chr1$chr <- chr
  chr1$pos <- 1:nrow(chr1)
  
  #### read chr length
  #chrlen <- read.csv("data/ZmB73_RefGen_v3.csv", header=T)
  #names(chrlen) <- c("chrom", "length")
  #len <- subset(chrlen, chrom == chr)$length
  #endpart <- data.frame(N=0, RS=0, chr=chr, pos=(nrow(chr1)+1):len)
  #chr1 <- rbind(chr1, endpart)
  
  message(sprintf("Chr [%s]: tot length [ %s ], >0 [ %s ], <0 [ %s ]", chr, nrow(chr1),
                  nrow(subset(chr1, RS>0)), nrow(subset(chr1, RS<0)) ))
  return(subset(chr1, RS>0))
}

####
chr1 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.1.msa.in.rates.full", chr=1)
# Chr [1]: tot length [ 301433381 ], >0 [ 35672919 ], <0 [ 15361221 ]
chr2 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.2.msa.in.rates.full", chr=2)
# Chr [2]: tot length [ 237865861 ], >0 [ 27149438 ], <0 [ 11830592 ]
chr3 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.3.msa.in.rates.full", chr=3)
# Chr [3]: tot length [ 232221667 ], >0 [ 25265529 ], <0 [ 11159023 ]
chr4 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.4.msa.in.rates.full", chr=4)
# Chr [4]: tot length [ 242024971 ], >0 [ 24828834 ], <0 [ 11350803 ]
chr5 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.5.msa.in.rates.full", chr=5)
# Chr [5]: tot length [ 217906509 ], >0 [ 25150515 ], <0 [ 10616256 ]
chr6 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.6.msa.in.rates.full", chr=6)
# Chr [6]: tot length [ 169354735 ], >0 [ 18722827 ], <0 [ 8220868 ]
chr7 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.7.msa.in.rates.full", chr=7)
# Chr [7]: tot length [ 176810428 ], >0 [ 18662751 ], <0 [ 8187078 ]
chr8 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.8.msa.in.rates.full", chr=8)
# Chr [8]: tot length [ 175344930 ], >0 [ 19580690 ], <0 [ 8497692 ]
chr9 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.9.msa.in.rates.full", chr=9)
# Chr [9]: tot length [ 157014581 ], >0 [ 18144925 ], <0 [ 7744240 ]
chr10 <- readgerp(gerpfile="/group/jrigrp/gerp/GERPv3/roast.chrom.10.msa.in.rates.full", chr=10)
# Chr [10]: tot length [ 149611521 ], >0 [ 15772647 ], <0 [ 7123455 ]


chrall <- rbind(chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10)
# server only
write.table(chrall, "largedata/gerpv3_228m.csv", sep=",", row.names=FALSE, quote=FALSE)


#chr1 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.1.msa.in.rates.full", chr=1)

