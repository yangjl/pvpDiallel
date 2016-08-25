### Jinliang Yang
### updated 2016-08-24
### deterimine the deleterious alleles

library(data.table)

gp <- fread("largedata/GERPv3_hmp3.csv", header=TRUE, data.table=FALSE)
gp$snpid <- paste(gp$chr, gp$pos, sep="_")

########
get_daf(chri=1, outbase)


#######  
get_daf <- function(chri=1, outbase){
  ## Note, major/minor obtained from alignment, Zea only sites been ignored, should be RS=0
  mm <- fread(paste0("largedata/Alignment/hmp3_major_chr", chri, ".csv"), header=TRUE, data.table=FALSE)
  ## RS, maf and ref/alt from hmp3 data
  subgp <- subset(gp, chr == chri)
  ## Ref allele frq
  frq <- fread(paste0("~/dbcenter/HapMap/HapMap3/plink_chr", chri, ".frq"), data.table=FALSE)
  
  sub <- merge(subgp, frq[, 2:5], by.x="snpid", by.y="SNP")
  
  idx <- which(abs(sub$maf - round(sub$MAF, 3)) > 0.01)
  message(sprintf("###>>> For chr [%s], tot [%s] mafs are different between two methods!", chri, length(idx) ))
  
  mgp <- merge(mm[,c("snpid","major", "minor")], sub[, c("snpid", "RS", "ref", "alt", "maf", "A1", "A2")], all=TRUE)
  
  ### test whether missing sites == 0
  ns0 <- sum(subset(mgp, is.na(major))$RS == 0)
  ns1 <- nrow(subset(mgp, is.na(major)))
  t <- sum(mgp$RS == 0)
  message(sprintf("###>>> For chr [%s], total [%s] RS=0, [%s] NA site=0 of [%s] total NA sites!", chri, t, ns0, ns1))
  
  ### 
  mgp1 <- subset(mgp, !is.na(major))
  
  ## major alleles in the aligment eq to the major allele in hmp, so the maf is the deleterious allele freq.
  mjr <- subset(mgp1, major == A2)
  mjr$daf <- mjr$maf
  #438644      6
  
  ## major ==A2, A2 because deleterious, their freqs should be 1-maf
  mnr <- subset(mgp1, major != A2)
  mnr$daf <- 1 - mnr$maf
  
  outfile <- paste0(outbase, "_chr", chri, ".txt")
  write.table(rbind(mjr, mnr), outfile, sep="\t", row.names=FALSE, quote=FALSE)
  
}



