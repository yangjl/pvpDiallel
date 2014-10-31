# Jinliang Yang
# July 10th, 2014

source("lib/sh4GenSel.R")

sh4GenSel(pwd="/home/jolyang/Documents/pvpDiallel/largedata/GenSel", 
          sh= "test.sh", 
          pi=0.99999, 
          geno="/home/jolyang/Documents/pvpDiallel/largedata/SNP/snp11m_add_gensel", 
          pheno="/home/jolyang/Documents/pvpDiallel/largedata/pheno/",
          map="/home/jolyang/Documents/pvpDiallel/largedata/SNP/allsnps_11m.map",
          chainLength=41000, burnin=1000, varGenotypic=4, varResidual=1)



################ testrun for add genotype
for(i in 1:8){
  mysh <- paste(traits[i], "_run41000.sh", sep="")
  mygeno <- "/home/NSF-SAM-GS/snpmatrix/merged_chrall_samid_maf1miss6.gensel.newbin"
  mypheno <- paste("/mnt/02/yangjl/Documents/SAM_GS/SAM_proj/reports/SAM_pheno382_", traits[i],
                   ".txt", sep="")
  
  
  
}




