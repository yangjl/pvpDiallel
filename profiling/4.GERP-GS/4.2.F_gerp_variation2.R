### Jinliang Yang
### 9/3/2015
### purpose: find the variation of the GERP

gerpsnp <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")
gerpsnp <- subset(gerpsnp, B73 != "N")

#### compute deleterious snps carried per line
out <- data.frame()
for(i in 11:ncol(gerpsnp)){
  tem <- subset(gerpsnp, B73 != gerpsnp[, i] & gerpsnp[, i]!= "N")
  temout <- data.frame(line=names(gerpsnp)[i], no=nrow(tem), score=mean(tem$RS))
  out <- rbind(out, temout)
}

write.table(out, "data/", sep=",", row.names=FALSE, quote=FALSE)

#### compute complementary snps of two lines
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

#### compute R^2 of complementary & SCA 
sum(gerpsnp$major != gerpsnp$B73)

#### compute variation of GERP per cM
gerp_var <- function(gerpsnp){
  df <- gerpsnp
  df$B73 <- as.character(df$B73)
  for(i in 11:ncol(df)){
    df[,i] <- as.character(df[,i])
    df[df[,i] != df$B73 & df[,i] != "N", i] <- df[df[,i] != df$B73 & df[,i] != "N", ]$RS
    df[df[,i] == df$B73 | df[,i] == "N", i] <- 0  
  }
  
  ### compute the sum of GERP in genetic bins
  df$bin <- paste(df$chr, round(df$genetic, 0), sep="_")
  library("plyr")
  
  mydf <- df[, 11:ncol(df)]
  mydf[, 1:11] <- apply(mydf[, 1:11], 2, as.numeric)
  
  binsum <- data.frame()
  for(bini in unique(mydf$bin)){
    tem <- subset(mydf, bin==bini)
    out <- tem[1, ]
    out[, -12] <- apply(tem[, -12], 2, sum)
    binsum <- rbind(binsum, out)
  }
  
  binsum$var <- apply(as.matrix(binsum[, 1:11]), 1, var)
  binsum$mean <- apply(as.matrix(binsum[, 1:11]), 1, mean)
  
  binsum$chr <- as.numeric(as.character(gsub("_.*", "", binsum$bin)))
  binsum$pos <- as.numeric(as.character(gsub(".*_", "", binsum$bin)))
  
  chr1 <- subset(binsum, chr==10)
  plot(chr1$pos, chr1$var)
}








