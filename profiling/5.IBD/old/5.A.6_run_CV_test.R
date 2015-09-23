# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

source("lib/slurm4gerpIBDCV.R")


#test run of the 66 diallel of trait per se with additive model
ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)


### RUN the real data for pheno ASI

wd <- getwd()
### step 1: generate inp file for GenSel4B
shcommand <- c()
for(mode in c("a1", "a2", "d1", "d2")){
  for(i in 1:10){
    GS_cv_inp(
      inp= paste0("slurm-scripts/ASI_test", i, "_", mode, ".inp"), pi=0.999,
      geno= paste0(wd, "/largedata/SNP/gerpIBD_cs", i, "_", mode, ".gs"), 
      trainpheno= paste0(wd, "/largedata/pheno/CV5fold/asi_train1_sp1.txt"),
      testpheno= paste0(wd, "/largedata/pheno/CV5fold/asi_test1_sp1.txt"),
      chainLength=1000, burnin=100, varGenotypic=1.4, varResidual=2
    )
    shcommand <- c(shcommand, paste("GenSel4R", paste0("slurm-scripts/ASI_test", i, "_", mode, ".inp"))) 
  }
}

### slurm input
slurm4GenSelCV(
  shfile= "slurm-scripts/cv_test.sh", shcommand = shcommand,
  sbathJ="cv_test",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/cv_test.sh  


