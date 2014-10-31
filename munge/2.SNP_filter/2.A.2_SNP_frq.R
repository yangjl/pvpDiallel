### Jinliang Yang
### codes run on farm

snp <- read.table("largedata/SNP/allsnps_frq.out", header=TRUE)

# Tiff Format  
# The 'bitmap' device allows for TIFF output. For a full list of bitmaps it can output,   
# see 'help(bitmap)'.   
#  
# Units: The dimension units that height and width are given in  
# Height and Width: Dimensions of the image in units specified by 'units'  
# Res: Resolution of the image in dots per inch  
pdf(file='graphs/mafmissing.pdf', height=5, width=10)  

# Plot your graph  
par(mfrow=c(1,2))
hist(snp$MAF, xlab="MAF", main="Minor Allele Frequency")
abline(v=0.1, col="red", lty=2, lwd=3)

hist(snp$missing, xlab="missing", main="SNP missing rate")
abline(v=0.1, col="red", lty=2, lwd=3)
dev.off() 

nrow(subset(snp, snp$MAF >= 0.1))
#[1] 11051839

###################
snp11m <- read.table("largedata/SNP/allsnps_frq.out", header=TRUE)
snp11m$chr <- gsub("_.*", "", snp11m$snpid)
snp11m$pos <- gsub(".*_", "", snp11m$snpid)

snp11m <- snp11m[, c(1, 18, 19, 2:17)]
write.table(snp11m, "largedata/SNP/allsnps_11m.dsf5", sep="\t", row.names=FALSE, quote=FALSE)

map<- snp11m[, 1:7]
names(map)[1:3] <- c("snpid", "AGPv2_chr", "AGPv2_pos")
write.table(snp11m, "largedata/SNP/allsnps_11m.map", sep="\t", row.names=FALSE, quote=FALSE)



