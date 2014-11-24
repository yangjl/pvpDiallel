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
  chrlen <- read.table("data/ZmB73_RefGen_v2.length", header=FALSE)
  names(chrlen) <- c("chrom", "length")
  
  len <- subset(chrlen, chrom ==paste("chr", chr, sep=""))$length
  endpart <- data.frame(N=0, RS=0, chr=chr, pos=(nrow(chr1)+1):len)
  
  chr1 <- rbind(chr1, endpart)
  
  message(sprintf("Chr [%s]: tot length [ %s ], >0 [ %s ], <0 [ %s ]", chr, nrow(chr1),
                  nrow(subset(chr1, RS>0)), nrow(subset(chr1, RS<0)) ))
  return(subset(chr1, RS!=0))
  
}

####
chr1 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.1.msa.in.rates.full", chr=1)
# Chr [1], tot length [301354135], >0 [13437827], <0 [6937810]
chr2 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.2.msa.in.rates.full", chr=2)
# Chr [2]: tot length [ 237068873 ], >0 [ 10279322 ], <0 [ 5417491 ]
chr3 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.3.msa.in.rates.full", chr=3)
# Chr [3]: tot length [ 232140174 ], >0 [ 9349572 ], <0 [ 4862035 ]
chr4 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.4.msa.in.rates.full", chr=4)
# Chr [4]: tot length [ 241473504 ], >0 [ 8745127 ], <0 [ 4649992 ]
chr5 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.5.msa.in.rates.full", chr=5)
# Chr [5]: tot length [ 217872852 ], >0 [ 10044887 ], <0 [ 5238169 ]
chr6 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.6.msa.in.rates.full", chr=6)
# Chr [6]: tot length [ 169174353 ], >0 [ 7032695 ], <0 [ 3670782 ]
chr7 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.7.msa.in.rates.full", chr=7)
# Chr [7]: tot length [ 176764762 ], >0 [ 6785123 ], <0 [ 3579891 ]
chr8 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.8.msa.in.rates.full", chr=8)
# Chr [8]: tot length [ 175793759 ], >0 [ 7643517 ], <0 [ 3950170 ]
chr9 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.9.msa.in.rates.full", chr=9)
# Chr [9]: tot length [ 156750706 ], >0 [ 6854718 ], <0 [ 3516827 ]
chr10 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.10.msa.in.rates.full", chr=10)
# Chr [10]: tot length [ 150189435 ], >0 [ 5834100 ], <0 [ 3066858 ]

save(file="largedata/lcache/4.1.A_gerpdis.RData", list=c("chr1", "chr2", "chr3", "chr4", "chr5",
                                      "chr6", "chr7", "chr8", "chr9", "chr10"))
chrall <- rbind(chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10)
write.table(chrall, "largedata/GERPv2/gerp130m.csv", sep=",", row.names=FALSE, quote=FALSE)





chr1 <- readgerp(gerpfile="largedata/GERPv2/roast.chrom.1.msa.in.rates.full", chr=1)





names(chr10) <- c("N", "RS")



hist(chr1[chr1$RS!=0,]$RS, breaks=100)

#### read the table fast
chr2 <- fread("largedata/GERPv2/roast.chrom.2.msa.in.rates.full", header=FALSE)
names(chr2) <- c("N", "RS")
nrow(subset(chr2, RS > 0)) 

hist(chr2[chr2$RS!=0,]$RS, breaks=100)

chr <- rbind(chr1, chr2)

#chr10 <- chr10[chr10$RS!=0, ]
hist(chr10$RS, breaks=50)

nrow(subset(chr10, RS > 0)) / 150189435

chr <- chr10
BINSIZE=1000
chr$bin <- paste(chr$chr, round(chr$pos/BINSIZE, 0), sep="_")


tab <- ddply(chr, .(bin), summarise,
             binrs = mean(RS))

tab$chr <- as.numeric(as.character(gsub("_.*", "", tab$bin)))
tab$pos <- as.numeric(as.character(gsub(".*_", "", tab$bin)))

plot(x=tab$pos, y=tab$binrs, pch=19, cex=0.2)







message(sprintf("###>>> input [ %s ]", nrow(res)))


chr1 <- read.table




ele10 <- read.table("~/Documents/Data/GERP/roast.chrom.1.msa.in.rates.full")


#Columns 6-8 arent actually listed in the README file. 
#Column 6 is the total number of bases within conserved elements up to a including
#that row. I believe that columns 7 and 8 correspond to the false positive rate assuming a given p-value, 
#but Id have to contact to Sidow lab to be sure.

gerp1 <- read.table("~/Documents/Data/GERP/roast.chrom.1.msa.in.rates.full", header=FALSE)
gerp1$pos <- 1:nrow(gerp1)


sub1 <- subset(gerp1, V2!=0)


hist(sub1$V2)


#plot(x=sub1$pos, y=sub1$V2)












