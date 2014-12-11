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


table(ibd1[,4])
table(ibd1[,5])





