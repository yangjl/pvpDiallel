### Jinliang Yang
### Sept 4th, 2015
### get degree of dominance


geno <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")




ped <- read.table("largedata/pheno/wholeset/asi_perse.txt", header=TRUE)

ped$P1 <- gsub("x.*", "", ped$Genotype)
ped$P2 <- gsub(".*x", "", ped$Genotype)

res <- geno[, 1:5]
for(i in 1:nrow(ped)){
  p1 <- ped$P1[i]
  p2 <- ped$P2[i]
  # note: need to get the reference allele!
  geno$tem1 <- 3
  geno[geno[, p1] == geno[, "B73"] & geno[, "B73"] != "N", ]$tem1 <- 1
  if(nrow(geno[geno[, p1] != geno[, "B73"] & geno[, p1]!="N" & geno[, "B73"] != "N", ]) > 0){
    geno[geno[, p1] != geno[, "B73"] & geno[, p1]!="N" & geno[, "B73"] != "N", ]$tem1 <- 0
  }
  
  geno$tem2 <- 3
  geno[geno[, p2] == geno[, "B73"] & geno[, "B73"] != "N", ]$tem2 <- 1
  geno[geno[, p2] != geno[, "B73"] & geno[, p2]!="N" & geno[, "B73"] != "N", ]$tem2 <- 0
  
  res$out <- geno$tem1 + geno$tem2
  names(res)[ncol(res)] <- ped$Genotype[i]
  message(sprintf("###>>> impute genotype for [ %sth ] hybrid [ %s ]", i, ped$Genotype[i]))
}

for(chri in 1:10){
  chr <- subset(res, chr==chri)
  chrmx <- chr[, -1:-5]
  chrmx[chrmx>3] <- 3
  tchr <- as.data.frame(t(chrmx))
  names(tchr) <- chr$marker
  outchr <- cbind(data.frame(Sample_ID=ped$Genotype), tchr)
  write.table(outchr, "", sep="\t", row.names=FALSE, quote=FALSE)
}

chr <- res
chrmx <- chr[, -1:-5]
chrmx[chrmx>3] <- 3
tchr <- as.data.frame(t(chrmx))
names(tchr) <- chr$marker
outchr <- cbind(data.frame(Sample_ID=ped$Genotype), tchr)
write.table(outchr, "largedata/SNP/genotype_500k_h.txt", sep="\t", row.names=FALSE, quote=FALSE)




