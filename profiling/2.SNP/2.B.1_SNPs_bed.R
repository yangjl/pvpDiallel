### Jinliang Yang
### 12/12/2014
### tranform to bed format

library("data.table")
snp11m <- fread("largedata/SNP/allsnps_11m.dsf5")
bed3 <- subset(snp11m, select = c("chr", "pos"))
bed3$end <- bed3$pos
names(bed3)[2] <- "start"
bed3$start <- bed3$start -1;
bed3$chr <- paste("chr", bed3$chr, sep="")
write.table(bed3, "largedata/SNP/allsnps_11m.bed3", sep="\t", 
            col.names=FALSE, row.names=FALSE, quote=FALSE)



