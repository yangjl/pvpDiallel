# Jinliang Yang
# July 10th, 2014

source("lib/slurm4GenSel.R")

sh4GenSel(pwd="largedata/GenSel", 
          sh= "test.sh", 
          pi=0.99999, 
          geno="/home/jolyang/Documents/pvpDiallel/largedata/SNP/snp11m_add_gensel.newbin", 
          pheno="/home/jolyang/Documents/pvpDiallel/largedata/pheno/gy_diallel.txt",
          map="/home/jolyang/Documents/pvpDiallel/largedata/SNP/allsnps_11m.map",
          chainLength=41000, burnin=1000, varGenotypic=4, varResidual=1)

sbatch -p bigmemh gensel_test.sh

slurm4GenSel(
  sh="slurm-scripts/gy_test.sh", 
  sbatho="/home/jolyang/Documents/pvpDiallel/slurm-log/testout-%j.txt",
  sbathe="/home/jolyang/Documents/pvpDiallel/slurm-log/error-%j.txt",
  sbathJ="gyjob",
  
  pi=0.99999, findsale ="no",
  geno="/home/jolyang/Documents/pvpDiallel/largedata/SNP/snp11m_add_gensel.newbin", 
  pheno="/home/jolyang/Documents/pvpDiallel/largedata/pheno/gy.txt",
  map="/home/jolyang/Documents/pvpDiallel/largedata/SNP/allsnps_11m.map",
  chainLength=11000, burnin=1000, varGenotypic=1.4, varResidual=2
)








################ testrun for add genotype
for(i in 1:8){
  mysh <- paste(traits[i], "_run41000.sh", sep="")
  mygeno <- "/home/NSF-SAM-GS/snpmatrix/merged_chrall_samid_maf1miss6.gensel.newbin"
  mypheno <- paste("/mnt/02/yangjl/Documents/SAM_GS/SAM_proj/reports/SAM_pheno382_", traits[i],
                   ".txt", sep="")
  
  
  
}




