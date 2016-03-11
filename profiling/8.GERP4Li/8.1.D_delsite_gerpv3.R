### Jinliang Yang
### deterimine the deleterious alleles


##############
library(tidyr)
library("data.table", lib="~/bin/Rlib")
cal_del_allele <- function(chri = 1){
  res1 <- fread(paste0("largedata/Alignment/AGPv3_chr", chri, "_gerpsnp.txt"), header=FALSE)
  res1 <- as.data.frame(res1)
  res1$sp <- gsub("-.*", "", res1$V1)
  res1$V1 <- gsub(".*-", "", res1$V1)
  res2 <- spread(res1, sp, V2)
  res2 <- res2[-2,]

  
  ### calculate maf
  message(sprintf("###>>> calculating major allele for chr [%s] ... ", chri))
  ma <- apply(res2, 1, function(x){
    n <- table(t(x[-1]))
    idx <- which(names(n) == "-")
    if(length(idx) > 0) n <- n[-idx]
    
    if(length(n) == 1){
      n <- sort(n, decreasing=TRUE)
      return(data.frame(snpid=x[1], major=names(n)[1], majc=n[1], minor="N", minc=0))
    }else if(length(n) >=2){
      n <- sort(n, decreasing=TRUE)
      return(data.frame(snpid=x[1], major=names(n)[1], majc=n[1], minor=names(n)[2], minc=n[2]))
    }
  })
  df <- ldply(ma, data.frame)
  res <- merge(df, res2[, c("V1", "Zea")], by.x="snpid", by.y="V1")
  return(res)
}

#####
outp <- data.frame()
for(i in 1:10){
  out <- cal_del_allele(chri = i)
  outp <- rbind(outp, out)
}

idx <- which(as.character(outp$Zea) != as.character(outp$major))
write.table(outp[, -2], "largedata/Alignment/conserved_alleles_AGPv2.csv", sep=",", row.names=FALSE, quote=FALSE )

