### Jinliang Yang
### extract SNP from fasta file

pre_bed5 <- function(gp, outbase="largedata/Alignment/hmp3_chr"){
  #v3 <- read.table("data/output_GERP_b0_AGPv2.bed")
  v3 <- gp[, c("chr", "pos", "pos", "N", "ref")]
  names(v3) <- c("chr", "start", "end", "name", "B73")
  v3$start <- v3$start - 1
  v3$name <- paste(v3$chr, v3$end, sep="_")
  ### pull out seq for different species
  
  sps <- c("Zea", "Coelorachis","Vossia","Sorghum","Oryza","Setaria",
           "Brachypodium","Hordeum","Musa","Populus","Vitis","Arabidopsis","Panicum")
  
  for(i in 1:10){
    message(sprintf("### analyzing chr [ %s ] ...", i))
    
    chr <- subset(v3, chr == i)
    bed5 <- data.frame(chr= rep(sps, times=nrow(chr)), start=rep(chr$start, each=length(sps)),
                       end = rep(chr$end, each=length(sps)), name= rep(chr$name, each=length(sps)),
                       score= rep(chr$B73, each=length(sps)))
    bed5$name <- paste(bed5$chr, bed5$name, sep="-")
    write.table(bed5, paste0(outbase, i, ".bed"), sep="\t", 
                row.names=FALSE, quote=FALSE, col.names=FALSE)
    
  }
}

### get the parental genotype info
gp <- read.table("largedata/GERPv3_hmp3.csv")
pre_bed5(gp, outbase="largedata/Alignment/hmp3_chr")

#bedtools getfasta -name -tab -fi roast.chrom.1.msa.in -bed hmp3_chr1.bed -fo hmp3_chr1_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.2.msa.in -bed hmp3_chr2.bed -fo hmp3_chr2_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.3.msa.in -bed hmp3_chr3.bed -fo hmp3_chr3_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.4.msa.in -bed hmp3_chr4.bed -fo hmp3_chr4_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.5.msa.in -bed hmp3_chr5.bed -fo hmp3_chr5_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.6.msa.in -bed hmp3_chr6.bed -fo hmp3_chr6_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.7.msa.in -bed hmp3_chr7.bed -fo hmp3_chr7_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.8.msa.in -bed hmp3_chr8.bed -fo hmp3_chr8_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.9.msa.in -bed hmp3_chr9.bed -fo hmp3_chr9_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.10.msa.in -bed hmp3_chr10.bed -fo hmp3_chr10_gerpsnp.txt


### checking consistency
res1 <- fread("largedata/Alignment/hmp3_chr1_gerpsnp.txt", header=FALSE, data.table=FALSE)
res1$sp <- gsub("-.*", "", res1$V1)
res <- subset(res1, sp %in% "Zea")

geno <- fread("largedata/Alignment/hmp3_chr1.bed", header=FALSE, data.table=FALSE)
geno <- subset(geno, V1 %in% "Zea")

test <- merge(res, geno[, c("V4", "V5")], by.x="V1", by.y="V4", sort=FALSE)

test$V2 <- as.character(test$V2)
test$V5 <- as.character(test$V5)
idx <- which(test$V2 != test$V5 & test$V5 != "N")
### 11


