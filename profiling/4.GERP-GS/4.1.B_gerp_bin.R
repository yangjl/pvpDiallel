### Jinliang Yang
### exploring genome-wide feature of GERP score

library("plyr")
#library("data.table")
GerpBin <- function(chr=chr10, binsize=1000000){

  message(sprintf("Chr: tot length [ %s ], >0 [ %s ], <0 [ %s ]", nrow(chr),
                  nrow(subset(chr, RS>0)), nrow(subset(chr, RS<0)) ))
  
  #### get the bin average RS
  chr$bin <- paste(chr$chr, round(chr$pos/binsize, 0), sep="_")
  tab <- ddply(chr, .(bin), summarise,
               binrs = sum(RS)/binsize)
  
  tab$chr <- as.numeric(as.character(gsub("_.*", "", tab$bin)))
  tab$pos <- as.numeric(as.character(gsub(".*_", "", tab$bin)))
  return(tab)
  
}

### server and local
ob <- load("largedata/lcache/4.1.A_gerpdis.RData")
chrall <- rbind(chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10)

### binsize = 1000bp
tab1k <- GerpBin(chr=chrall, binsize=1000)
tab1m  <- GerpBin(chr=chrall, binsize=1000000)

savefile="largedata/lcache/4.1.A_gerpdis.RData", 
list=c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10")
#tab1k <- rbbind(tab1, tab2, tab3, tab4, tab5, tab6, tab7, tab8, tab9, tab10)
#plot(x=tab$pos, y=tab$binrs, pch=19, cex=0.3, main="Chr10", xlab="Chr", ylab="Avg RS")




