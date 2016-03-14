### Jinliang Yang
### exploring genome-wide feature of GERP score

library("data.table", lib="~/bin/Rlib")

chrall <- fread("largedata/gerpv3_228m.csv")
dim(chrall)
#[1] 228,951,075         4

gerps <- as.data.frame(chrall)
#[1] 86006888        4
bed5 <- gerps[, c("chr", "pos", "pos", "chr", "RS")]
names(bed5) <- c("chrom", "start", "end", "name", "score")
bed5$start <- bed5$start - 1
bed5$name <- paste(bed5$chrom, bed5$end, sep="_")

bed4 <- bed5[, 1:4]
for(i in 1:10){
  sub <- subset(bed4, chrom == i)
  write.table(sub, paste0("largedata/Alignment/GERP_b0_86M_AGPv2_chr", i,  ".bed"), sep="\t",
              row.names=FALSE, quote=FALSE, col.names=FALSE)
}


#### new approach
chrlen <- read.table("~/dbcenter/AGP/AGPv2/ZmB73_RefGen_v2.fasta.fai", header=FALSE)
chrlen <- chrlen[1:10,]

for(i in 1:10){
  
  tot <- round(chrlen$V2[i]/1000, 0)
  df <- data.frame(chr=rep(i, times=tot), start=(0:(tot-1))*1000, end=(1:tot)*1000)
  df$name <- paste(df$chr, df$start, df$end, sep="_")
  
  write.table(df, paste0("largedata/Alignment/AGPv2_chr", i,  ".bed"), sep="\t",
              row.names=FALSE, quote=FALSE, col.names=FALSE)
}
















