### Jinliang Yang
### filtering SAM SNPs

### input genotype of SAM from Eddy
setwd("/home/NSF-SAM-GS/snpmatrix")
tab5rows <- read.table("NSF-SAM.genotyping.SNPs_only_matrix-20140410.txt", nrow=5, header=TRUE)
classes <- sapply(tab5rows, class)


### run python codes to filtering the maf and missing
python ~/Documents/PyCodes/snpfrq/snpfrq_v2.0.py -h
python ~/Documents/PyCodes/snpfrq/snpfrq_v2.0.py -i NSF-SAM.genotyping.SNPs_only_matrix-20140410.txt \
-s 5 -e 384 -a 0.05 -b 0.6 -o SAM_SNPs_chrall.dsf

python ~/Documents/PyCodes/snpfrq/snpfrq_v2.0.py -i NSF-SAM.genotyping.SNPs_only_matrix-20140410.txt \
-s 5 -e 384 -a 0.01 -b 0.6 -o SAM_SNPs_chrall_maf1miss6.dsf


#### read in the data and change the names with SAM ID!
dsf5 <- read.table("SAM_SNPs_chrall_maf1miss6.dsf", nrow=5, header=TRUE)
classes <- sapply(dsf5, class)
dsf <- read.table("SAM_SNPs_chrall_maf1miss6.dsf", header=TRUE, colClasses=classes)

par(mfrow=c(1,2))
hist(dsf$MAF, breaks=50, main="MAF > 0.01", xlab="minor allele frq")
hist(dsf$missing, breaks=50, main="Missing rate < 0.6", xlab="missing rate")


id_lookup <- function(dsf=dsf){
  ## updated the name_lookup table
  nmtable <- read.csv("~/Documents/SAM_GS/SAM_proj/data/SAM_name_lookup.csv")
  
  gidtable <- data.frame(gid=names(dsf), order=1:length(dsf))
  nmtable <- nmtable[!is.na(nmtable$ID_in_snpfile),]
  gidtable2 <- merge(gidtable, nmtable[, c("SAMID", "ID_in_snpfile", "accession")], 
                     by.x="gid", by.y="ID_in_snpfile", all.x=TRUE)
  
  gidtable2[is.na(gidtable2$SAMID), ]$SAMID <- gidtable2[is.na(gidtable2$SAMID), ]$gid
  gidtable2[is.na(gidtable2$accession), ]$accession <- gidtable2[is.na(gidtable2$accession), ]$gid
  gidtable2 <- gidtable2[order(gidtable2$order),]
  return(gidtable2)
}

gid <- id_lookup(dsf=dsf)
names(dsf) <- gid$SAMID
write.table(dsf, "SAM_SNPs_maf1miss6_samid.dsf", sep="\t", row.names=FALSE, quote=FALSE)
names(dsf) <- gid$accession
write.table(dsf, "SAM_SNPs_maf1miss6_PI.dsf", sep="\t", row.names=FALSE, quote=FALSE)


### output map file
map <- dsf[, 1:5]
map$AGPv2_chr <- gsub("_.*", "", map$snpid)
map$AGPv2_chr <- gsub("chr", "", map$AGPv2_chr)
map$AGPv2_pos <- gsub(".*_", "", map$snpid)
write.table(map, "SAM_SNPs_maf1miss6_samid.map", sep="\t", row.names=FALSE, quote=FALSE)

#### 10M
map <- read.table("/home/NSF-SAM-GS/snpmatrix/SAM_SNPs_maf1miss6_samid.map", header=T)
map$AGPv2_pos <- round(map$AGPv2_pos/10, 0)
write.table(map, "/home/NSF-SAM-GS/snpmatrix/SAM_SNPs_maf1miss6__samid_10m.map", 
            sep="\t", row.names=FALSE, quote=FALSE)


