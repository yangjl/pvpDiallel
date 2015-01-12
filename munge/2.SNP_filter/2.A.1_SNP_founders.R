### Jinliang Yang
### codes run on farm

snp <- read.table("largedata/SNP/FinalSNPs_all.txt", header=T)
dim(snp)
#[1] 13,782,809       18

snp <- snp[, -5:-6]
names(snp)[1:4] <- c("chr", "pos", "ref", "alt")
#0       1       2       3       4       5       6       7       8       9        10
#10991 2142843 1761501 1629370 1506567 1372563 1136154 1207457 1076253 1077722 861388
snp <- subset(snp, chr != 0)

write.table(snp, "largedata/SNP/allsnps_13.7m.dsf2", sep="\t", row.names=FALSE, quote=FALSE)



############# dsf2vcf
tab5rows <- read.table(inputfile, header=TRUE, nrows=5)
classes <- sapply(tab5rows, class)
res <- read.table(inputfile, header=TRUE, colClasses=classes)

library(data.table)
dsf <- fread("largedata/SNP/allsnps_13.7m.dsf2", header=TRUE)
