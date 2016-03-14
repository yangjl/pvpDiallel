### Jinliang Yang
### extract SNP from fasta file

library("data.table", lib="~/bin/Rlib")
pre_bed <- function(){
  chrall <- fread("largedata/gerpv3_228m.csv")
  dim(chrall)
  #[1] 228,951,075         4
  
  gerps <- as.data.frame(chrall)
  #[1] 86006888        4
  bed5 <- gerps[, c("chr", "pos", "pos", "chr", "RS")]
  names(bed5) <- c("chrom", "start", "end", "name", "score")
  bed5$start <- bed5$start - 1
  bed5$name <- paste(bed5$chrom, bed5$end, sep="_")
  #v3 <- read.table("data/output_GERP_b0_AGPv2.bed")
  #names(v3) <- c("chr", "start", "end", "name", "B73")
  ### pull out seq for different species
  v3 <- bed5
  sps <- c("Zea", "Coelorachis","Vossia","Sorghum","Oryza","Setaria",
           "Brachypodium","Hordeum","Musa","Populus","Vitis","Arabidopsis","Panicum")
  
  for(i in 1:10){
    chr <- subset(v3, chrom==i)
    
    mybed <- data.frame(chrom= rep(sps, times=nrow(chr)), start=rep(chr$start, each=length(sps)),
                       end = rep(chr$end, each=length(sps)), name= rep(chr$name, each=length(sps)))
    mybed$name <- paste(mybed$chrom, mybed$name, sep="-")
    
    mybed$start <- format(mybed$start , scientific = FALSE)
    mybed$end <- format(mybed$end, scientific = FALSE)
    write.table(mybed, paste0("largedata/Alignment/AGPv3_chr", i, ".bed"), sep="\t", 
                row.names=FALSE, quote=FALSE, col.names=FALSE)
    print(i)
  }
}


###########
#options(scipen=10)
#write.table(foo, "foo.txt")
#options(scipen=0)  # restore the default
pre_bed()

library(maizeR)
for(i in 1:9){
  shid <- paste0("slurm-scripts/run_bed_chr", i, ".sh")
  #bedtools getfasta -name -tab -fi roast.chrom.10.msa.in -bed AGPv3_chr10.bed -fo AGPv3_chr10_gerpsnp.txt
  command <- paste0("cd largedata/Alignment/", "\n", 
                    "bedtools getfasta -name -tab -fi roast.chrom.", i, ".msa.in",
                    " -bed AGPv3_chr", i, ".bed -fo AGPv3_chr", i, "_gerpsnp.txt")
  cat(command, file=shid, sep="\n", append=FALSE)
}
shcode <- "sh slurm-scripts/run_bed_chr$SLURM_ARRAY_TASK_ID.sh"

set_array_job(shid = "slurm-scripts/run_bed_chr.sh",
              shcode = shcode, arrayjobs = "1-8", wd = NULL,
              jobid = "runbedtools", email = "yangjl0930@gmail.com")
#bedtools getfasta -name -tab -fi roast.chrom.1.msa.in -bed chr1.bed -fo chr1_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.2.msa.in -bed chr2.bed -fo chr2_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.3.msa.in -bed chr3.bed -fo chr3_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.4.msa.in -bed chr4.bed -fo chr4_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.5.msa.in -bed chr5.bed -fo chr5_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.6.msa.in -bed chr6.bed -fo chr6_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.7.msa.in -bed chr7.bed -fo chr7_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.8.msa.in -bed chr8.bed -fo chr8_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.9.msa.in -bed chr9.bed -fo chr9_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.10.msa.in -bed AGPv3_chr10.bed -fo AGPv3_chr10_gerpsnp.txt


### 182/81127


