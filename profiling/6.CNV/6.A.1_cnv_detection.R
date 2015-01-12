# Jinliang Yang
# 12/11/2014
# do a CNV call for 12 founders

#source("http://bioconductor.org/biocLite.R")
#biocLite("cn.mops")

library(cn.mops)
BAMFiles <- list.files(path = "/group/jrigrp2/DiallelSofiane/MappingResults/bwaResults", pattern=".bam$")

setwd("/group/jrigrp2/DiallelSofiane/MappingResults/bwaResults")
chrs <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10")
bamDataRanges <- getReadCountsFromBAM(BAMFiles, refSeqName=chrs,  mode="paired")
#Window length set to: 3000

#back to mine wd
setwd("/home/jolyang/Documents/Github/pvpDiallel")

#resHaplo <- haplocn.mops(bamDataRanges)
#resCN <- calcIntegerCopyNumbers(resHaplo)
#This function performs the cn.mops algorithm for copy number detection in NGS data
res <- cn.mops(bamDataRanges)
resCNV <- calcIntegerCopyNumbers(res)

### transform GRanges to data.frame
mycnv <- cnvr(resCNV)


cnvdf <- data.frame(chr=as.character(seqnames(mycnv)), start=start(mycnv), end=end(mycnv))
callcnv <- mcols(mycnv)
cnvdf <- cbind(cnvdf, callcnv)

save(file="largedata/lcache/bamDataRanges.RData", list=c("bamDataRanges","cnvdf") )

