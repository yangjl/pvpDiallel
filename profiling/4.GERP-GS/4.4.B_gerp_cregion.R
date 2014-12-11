# Jinliang Yang
# updated: 12/10/2014
# Purpose: select SNPs from GERP conserved region

###########################

GERPelem2bed6 <- function(infile="largedata/GERPv2/roast.chrom.1.msa.in.rates.full.elems", chr="chr1"){
  elem <- read.table(infile, header=FALSE)
  names(elem) <- c("chrom", "start",  "end",  "score",	"strand", "length", "name", "V8")
  
  ###
  #message(sprintf("score=RS score, strand=p value, name=elemid"))
  elem <- elem[, c("chrom", "start", "end", "name", "score", "strand")]
  
  ###
  elem$chrom <- chr;
  elem$start <- elem$start -1;
  elem$name <- paste(elem$chrom, elem$start, sep="_")
  return(elem) 
}

### combine 10 GERP elements into bed6 format
# Note: score=RS score, strand=p value, name=elemid
chr1 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.1.msa.in.rates.full.elems", chr="chr1") 
chr2 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.2.msa.in.rates.full.elems", chr="chr2") 
chr3 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.3.msa.in.rates.full.elems", chr="chr3") 
chr4 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.4.msa.in.rates.full.elems", chr="chr4") 
chr5 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.5.msa.in.rates.full.elems", chr="chr5") 
chr6 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.6.msa.in.rates.full.elems", chr="chr6") 
chr7 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.7.msa.in.rates.full.elems", chr="chr7") 
chr8 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.8.msa.in.rates.full.elems", chr="chr8") 
chr9 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.9.msa.in.rates.full.elems", chr="chr9") 
chr10 <- GERPelem2bed6(infile="largedata/GERPv2/roast.chrom.10.msa.in.rates.full.elems", chr="chr10") 

gerpelemt <- rbind(chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10)
sum(gerpelemt$end - gerpelemt$start)
#[1] 29869451





bedtools intersect -a gerp_element.bed -b snp 
