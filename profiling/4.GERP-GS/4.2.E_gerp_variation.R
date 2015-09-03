### Jinliang Yang
### 9/3/2015
### purpose: find the variation of the GERP

library("plyr")
library("data.table", lib="~/bin/Rlib/")
#load data in the local machine for plotting
ob <- load("largedata/lcache/snpnzRS.RData")

### genotyping information
snp11m <- fread("largedata/SNP/allsnps_11m.dsf5")
snp11m <- as.data.table(snp11m)

##############################################################

gerp_b0 <- as.data.frame(subset(snpnz, RS >0)) #506898
gerp_b0 <- merge(gerp_b0[, 1:2], snp11m, by="snpid")[, c("snpid", "chr", "pos")]
names(gerp_b0)[3] <- "Physical"

####
test_p2g(chr=9)






gerpsnp <- merge(gerp_b0[, 1:2], snp11m, by="snpid")

gerpsnp <- subset(gerpsnp, B73 != "N")


out <- data.frame()
for(i in 10:ncol(gerpsnp)){
  tem <- subset(gerpsnp, B73 != gerpsnp[, i] & gerpsnp[, i]!= "N")
  temout <- data.frame(line=names(gerpsnp)[i], no=nrow(tem), score=mean(tem$RS))
  out <- rbind(out, temout)
}

write.table(out, "data/", sep=",", row.names=FALSE, quote=FALSE)


message(sprintf("###>>> calculating # of complementation!"))
SCA <- read.csv("")
out2 <- subset(SCA, trait=="GY" & P1 != "B73")
out2$P1 <- as.character(out2$P1)
out2$P2 <- as.character(out2$P2)
out2$compno <- 0
for(i in 1:nrow(out2)){
  #### non-deleterious of the two parents
  tem1 <- subset(gerpsnp, B73 == gerpsnp[, out2$P1[i]] )
  tem2 <- subset(gerpsnp, B73 == gerpsnp[, out2$P2[i]] )
  
  out2$compno[i] <- length(unique(c(tem1$snpid, tem2$snpid)))
}



sum(gerpsnp$major != gerpsnp$B73)
