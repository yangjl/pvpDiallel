## Jinliang
### ped preparation and SNP imputation


######## generate pedigree information
pheno <- read.csv("data/trait_matrix.csv", header=TRUE)

ped <- pheno[pheno$trait=="GY", c("P1", "P2", "Hyb")]
names(ped) <- c("p1", "p2", "f1")
ped$f1 <- paste(ped$p1, ped$p2, sep="x")

write.table(ped, "largedata/SNP/ped66.txt", sep="\t", row.names=FALSE, quote=FALSE)



imp4d -d ped66.txt -i allsnps_11m.dsf5 -o snp11m_add_gensel -s 8 -e 19 --header yes -m 0





