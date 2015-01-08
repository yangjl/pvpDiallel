# Jinliang Yang
# 12/9/2014
# purpose: checking the IBD blocks from Sofiane


ibd1 <- read.table("largedata/IBD/HapltypeShare_chr1.txt", header=TRUE)
ibd2 <- read.table("largedata/IBD/HapltypeShare_chr2.txt", header=TRUE)
ibd3 <- read.table("largedata/IBD/HapltypeShare_chr3.txt", header=TRUE)
ibd4 <- read.table("largedata/IBD/HapltypeShare_chr4.txt", header=TRUE)
ibd5 <- read.table("largedata/IBD/HapltypeShare_chr5.txt", header=TRUE)
ibd6 <- read.table("largedata/IBD/HapltypeShare_chr6.txt", header=TRUE)
ibd7 <- read.table("largedata/IBD/HapltypeShare_chr7.txt", header=TRUE)
ibd8 <- read.table("largedata/IBD/HapltypeShare_chr8.txt", header=TRUE)
ibd9 <- read.table("largedata/IBD/HapltypeShare_chr9.txt", header=TRUE)
ibd10 <- read.table("largedata/IBD/HapltypeShare_chr10.txt", header=TRUE)

ibdall <- rbind(ibd1, ibd2, ibd3, ibd4, ibd5, ibd6, ibd7, ibd8, ibd9, ibd10)
ibd <- ibdall[, 1:3]
ibd$len <- ibd$End - ibd$Start
ibd$Chr <- paste("chr", ibd$Chr, sep="")

#Note: start, 0-based; end, 1-based
write.table(ibd[, 1:3], "largedata/IBD/ibd_chrall.bed3", sep="\t", row.names=FALSE,
            col.names=FALSE, quote=FALSE)



## using BEDtools to map all the SNPs to the IBD regions
bedtools intersect -a largedata/SNP/allsnps_11m.bed3 -b largedata/IBD/ibd_chrall.bed3 -wa -wb \
> largedata/IBD/allsnps_11m_IBD.bed









