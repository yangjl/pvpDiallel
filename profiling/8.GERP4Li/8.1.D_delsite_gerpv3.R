### Jinliang Yang
### deterimine the deleterious alleles

######## reshape the reads
library("data.table", lib="~/bin/Rlib")
library(tidyr)
cal_del_allele <- function(chri = 1){
  res1 <- fread(paste0("largedata/Alignment/AGPv3_chr", chri, "_gerpsnp.txt"), header=FALSE)
  res1 <- as.data.frame(res1)
  res1$sp <- gsub("-.*", "", res1$V1)
  res1$V1 <- gsub(".*-", "", res1$V1)
  res2 <- spread(res1, sp, V2)
  #res2 <- res2[-2,]
  res2 <- res2[, c(1,14, 2:14)]
  write.table(res2, paste0("largedata/Alignment/AGPv3_chr", chri, "_gerpsnp.txt"), sep="\t", 
              row.names=FALSE,quote=FALSE)
}

cal_del_allele(chri = 10)
for(i in 1:9){
  cal_del_allele(chri = i)
}

#### for test purpose  
library("data.table")
library(tidyr)
test_cal_del_allele <- function(chri = 1){
  res1 <- fread("~/Documents/Github/zmSNPtools/packages/getsnpinfo/test2_out.txt", header=FALSE)
  res1 <- as.data.frame(res1)
  res1$sp <- gsub("-.*", "", res1$V1)
  res1$V1 <- gsub(".*-", "", res1$V1)
  res2 <- spread(res1, sp, V2)
  #res2 <- res2[-2,]
  res2 <- res2[, c(1,14, 2:14)]
  write.table(res2, "~/Documents/Github/zmSNPtools/packages/getsnpinfo/test.txt", sep="\t", 
              row.names=FALSE,quote=FALSE)
}