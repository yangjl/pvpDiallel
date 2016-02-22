### Jinliang Yang
### extract SNP from fasta file


### get the parental genotype info
geno <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")

bed3 <- geno[, c("chr", "pos")]
bed3$end <- bed3$pos
bed3$pos <- bed3$pos - 1
write.table(bed3, "largedata/Alignment/GERP_b0_AGPv2.bed", sep="\t",
            row.names=FALSE, quote=FALSE, col.names=FALSE)

sps <- c("Zea", "Coelorachis","Vossia","Sorghum","Oryza","Setaria",
         "Brachypodium","Hordeum","Musa","Populus","Vitis","Arabidopsis","Panicum")


for(i in 1:10){
  chr <- subset(geno, chr==i)
  
  bed3 <- data.frame(chr= rep(sps, times=nrow(chr)), start=rep(chr$pos, each=length(sps)))
  bed3$end <- bed3$start
  bed3$start <- bed3$start - 1 
  bed3$name <- paste(bed3$chr, i, bed3$end, sep="_")

  write.table(bed3, paste0("largedata/Alignment/chr", i, ".bed"), sep="\t", 
              row.names=FALSE, quote=FALSE, col.names=FALSE)
}

#bedtools getfasta -name -tab -fi roast.chrom.1.msa.in -bed chr1.bed -fo chr1_gerpsnp.txt

#bedtools getfasta -name -tab -fi roast.chrom.10.msa.in -bed test.bed -fo out.txt



res1 <- read.table("largedata/Alignment/chr1_gerpsnp.txt", header=FALSE)
res1$sp <- gsub("_.*", "", res1$V1)
res <- subset(res1, sp %in% "Zea")
res$V1 <- gsub("Zea_", "", res$V1)

chr <- subset(geno, chr==1)

res <- merge(res, chr[, c("marker", "B73")], by.x="V1", by.y="marker", sort=FALSE)

res$V2 <- as.character(res$V2)
res$B73 <- as.character(res$B73)
sum(res$V2 == res$B73)


