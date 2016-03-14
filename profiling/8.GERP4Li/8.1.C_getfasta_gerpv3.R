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
  
  options(scipen=10)
  for(i in 1:10){
    chr <- subset(v3, chrom==i)
    
    mybed <- data.frame(chrom= rep(sps, times=nrow(chr)), start=rep(chr$start, each=length(sps)),
                       end = rep(chr$end, each=length(sps)), name= rep(chr$name, each=length(sps)))
    mybed$name <- paste(mybed$chrom, mybed$name, sep="-")
    
    #mybed$start <- format(mybed$start , scientific = FALSE)
    #mybed$end <- format(mybed$end, scientific = FALSE)
    write.table(mybed, paste0("largedata/Alignment/AGPv3_chr", i, ".bed"), sep="\t", 
                row.names=FALSE, quote=FALSE, col.names=FALSE)
    print(i)
  }
  options(scipen=0)
}


###########
#options(scipen=10)
#write.table(foo, "foo.txt")
#options(scipen=0)  # restore the default
pre_bed()



