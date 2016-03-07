### Jinliang Yang
### extract SNP from fasta file


### get the parental genotype info
geno <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")

bed3 <- geno[, c("chr", "pos", "pos", "marker", "B73")]
names(bed3) <- c("chrom", "start", "end", "name", "score")
bed3$start <- bed3$start - 1

write.table(bed3, "largedata/Alignment/GERP_b0_AGPv2.bed", sep="\t",
            row.names=FALSE, quote=FALSE, col.names=FALSE)

### AGPv2 -> AGPv3 conversion
### http://plants.ensembl.org/Oryza_sativa/Tools/AssemblyConverter?db=core

pre_bed5 <- function(){
  v3 <- read.table("data/output_GERP_b0_AGPv2.bed")
  names(v3) <- c("chr", "start", "end", "name", "B73")
  ### pull out seq for different species
  
  sps <- c("Zea", "Coelorachis","Vossia","Sorghum","Oryza","Setaria",
           "Brachypodium","Hordeum","Musa","Populus","Vitis","Arabidopsis","Panicum")
  
  for(i in 1:10){
    chr <- subset(v3, chr==i)
    
    bed5 <- data.frame(chr= rep(sps, times=nrow(chr)), start=rep(chr$start, each=length(sps)),
                       end = rep(chr$end, each=length(sps)), name= rep(chr$name, each=length(sps)),
                       score= rep(chr$B73, each=length(sps)))
    bed5$name <- paste(bed5$chr, bed5$name, sep="-")
    write.table(bed5, paste0("largedata/Alignment/chr", i, ".bed"), sep="\t", 
                row.names=FALSE, quote=FALSE, col.names=FALSE)
  }
}

###########
pre_bed5()

#bedtools getfasta -name -tab -fi roast.chrom.1.msa.in -bed chr1.bed -fo chr1_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.2.msa.in -bed chr2.bed -fo chr2_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.3.msa.in -bed chr3.bed -fo chr3_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.4.msa.in -bed chr4.bed -fo chr4_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.5.msa.in -bed chr5.bed -fo chr5_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.6.msa.in -bed chr6.bed -fo chr6_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.7.msa.in -bed chr7.bed -fo chr7_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.8.msa.in -bed chr8.bed -fo chr8_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.9.msa.in -bed chr9.bed -fo chr9_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.10.msa.in -bed chr10.bed -fo chr10_gerpsnp.txt

res1 <- read.table("largedata/Alignment/chr1_gerpsnp.txt", header=FALSE)
res1$sp <- gsub("-.*", "", res1$V1)

res <- subset(res1, sp %in% "Zea")

geno <- read.table("largedata/Alignment/chr1.bed", header=FALSE)
test <- merge(res, geno[, c("V4", "V5")], by.x="V1", by.y="V4", sort=FALSE)

test$V2 <- as.character(test$V2)
test$V5 <- as.character(test$V5)
idx <- which(test$V2 != test$V5 & test$V5 != "N")
### 182/81127


