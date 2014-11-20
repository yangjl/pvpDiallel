### Jinliang Yang
### exploring genome-wide feature of GERP score

library("plyr")
library("data.table")


chrlen <- read.table("data/ZmB73_RefGen_v2.length", header=FALSE)
names(chrlen) <- c("chrom", "length")


tab5rows <- read.table("largedata/GERPv2/roast.chrom.1.msa.in.rates.full", header=FALSE, nrows=5)
classes <- sapply(tab5rows, class)
chr10 <- read.table("largedata/GERPv2/roast.chrom.10.msa.in.rates.full", header=FALSE, colClasses=classes)
names(chr10) <- c("N", "RS")
chr10$chr <- 10
chr10$pos <- 1:nrow(chr10)


#### read the table fast
chr1 <- fread("largedata/GERPv2/roast.chrom.1.msa.in.rates.full", header=FALSE)
names(chr1) <- c("N", "RS")
nrow(subset(chr1, RS > 0)) 

hist(chr1[chr1$RS!=0,]$RS, breaks=100)


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












