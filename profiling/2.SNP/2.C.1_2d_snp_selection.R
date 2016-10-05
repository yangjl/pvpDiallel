### Jinliang Yang
### date: 10-03-2016
### purpose: 2D SNP selection for GWAS


### SNP data
library("data.table")
library("plyr")
snp11m <- fread("largedata/SNP/allsnps_11m_gerpv2.csv", header=TRUE, sep=",") 
snp11m <- as.data.frame(snp11m)

### cM
map <- fread("largedata/SNP/allsnps_11m_genetic.map")
map$AGPv2_pos <- round(map$AGPv2_pos/1000000, 0)
map <- as.data.frame(map)
names(map) <- c("snpid", "chr", "genetic")

### Exonic bp per cM => quantiles
excm <- read.csv("cache/exonic_cM.csv")
excm$qt <- 9
excm[excm$exonbp <= quantile(excm$exonbp)[2], ]$qt <- 1
excm[excm$exonbp > quantile(excm$exonbp)[2] & excm$exonbp <= quantile(excm$exonbp)[3], ]$qt <- 2
excm[excm$exonbp > quantile(excm$exonbp)[3] & excm$exonbp <= quantile(excm$exonbp)[4], ]$qt <- 3
excm[excm$exonbp > quantile(excm$exonbp)[4], ]$qt <- 4








snps <- merge(map[, c(1,3)], snp11m, by="snpid")
snps <- snps[order(snps$chr, snps$pos),]

#############################################################################
##### generate same number of random SNPs
getRandomSNP <- function(fromdf=snp11m, num=nrow(snpb), nrep=10, 
                         basenm="snprandom_set", writeto="largedata/SNP/inmarker/"){
  
  ###
  for(i in 1:nrep){
    idx <- sample(1:nrow(fromdf), num, replace=FALSE)
    tempdf <- snp11m[idx,]
    tempout <- paste0(writeto, basenm, i, ".txt")
    write.table(subset(tempdf, select="snpid"), tempout, sep="\t", 
                row.names=FALSE, col.names=FALSE, quote=FALSE)
  }
  
  message(sprintf("###==> [%s] times of random [%s] SNPs were put in [%s]!", nrep, num, writeto))
  
}

###
set.seed(1234567)
getRandomSNP(fromdf=snp11m, num=nrow(snpb), nrep=10, basenm="snprandom_set", writeto="largedata/SNP/inmarker/")
getRandomSNP(fromdf=snp11m, num=nrow(snpb2), nrep=10, basenm="snp29k_set", writeto="largedata/SNP/inmarker/")
getRandomSNP(fromdf=snp11m, num=nrow(snps4), nrep=10, basenm="snps4_set", writeto="largedata/SNP/inmarker/")










test_p2g <- function(chr=9){
  source("~/Documents/Github/zmSNPtools/Rcodes/p2g.R")
  train <- read.csv("~/Documents/Github/zmSNPtools/shareData/ISU_integrated_IBM_AGPv2_training.csv")
  train$Physical <- as.numeric(as.character(gsub(",", "", train$Physical)))
  ### test the proformance of the function using the training data
  
  predict <- subset(train, Chr == chr)[, -3]
  #predict <- data.frame(marker=c("A", "B", "C"), chr=1, Physical=c(467, 41238467, 164555621)) 
  out <- p2g(predict, train)
  res <- merge(train, out, by.x="Marker", by.y="marker")
  
  message(sprintf("###>>> p2g testing results: correlation R2 = [ %s ]", cor(res$Genetic, res$genetic)))
}

use_p2g <- function(){
  source("~/Documents/Github/zmSNPtools/Rcodes/p2g.R")
  train <- read.csv("~/Documents/Github/zmSNPtools/shareData/ISU_integrated_IBM_AGPv2_training.csv")
  train$Physical <- as.numeric(as.character(gsub(",", "", train$Physical)))
  ### test the proformance of the function using the training data
  
  predict <- subset(train, Chr == chr)[, -3]
  #predict <- data.frame(marker=c("A", "B", "C"), chr=1, Physical=c(467, 41238467, 164555621)) 
  out <- p2g(predict, train)
  res <- merge(train, out, by.x="Marker", by.y="marker")
  
  message(sprintf("###>>> p2g testing results: correlation R2 = [ %s ]", cor(res$Genetic, res$genetic)))
}
