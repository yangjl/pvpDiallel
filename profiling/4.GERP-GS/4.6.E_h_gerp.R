

### SNP data
library("data.table", lib="~/bin/Rlib/")

snp11m <- fread("largedata/SNP/allsnps_11m_gerpv2.csv", header=TRUE, sep=",") 
snp11m <- as.data.frame(snp11m)
snp11m <- snp11m[, 1:5]

h <- read.table("largedata/snpeff/gy_h.txt", header=TRUE) 

gh <- merge(h, snp11m, by="snpid")
write.table(gh, "largedata/snpeff/gh.txt", sep="\t", row.names=FALSE, quote=FALSE)



gh <- read.table("largedata/snpeff/gh.txt", header=TRUE)

cor.test(abs(gh$h), gh$RS)

gh1 <- subset(gh, RS > 1)
cor.test(abs(gh1$h), gh1$RS)
plot(gh1$RS, abs(gh1$h))

gh2 <- subset(gh, RS > 2)
cor.test(abs(gh2$h), gh2$RS)




