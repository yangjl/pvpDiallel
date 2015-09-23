# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

source("lib/slurm4gerpIBDCV.R")

### step 1: generate inp file for GenSel4B
Run7Trait <- function(inppwd="slurm-scripts/g2/", genobase="/largedata/SNP/gerpIBD_h_g1_", mypi){
  shcommand <- c()
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  
  for(i in 5){
  #for(i in 1:7){
    for(mode in c("a2", "d2", "h2")){
      for(cv in 1:5){
        for(sp in 1:10){
          myinp <- paste0(inppwd, ti[i], "_real_", mode,"_cv",cv, "_sp", sp, ".inp")
          GS_cv_inp(
            inp= myinp, pi= mypi,
            geno= paste0(wd, genobase, mode, ".gs"), 
            trainpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[i], "_train", cv, "_sp", sp, ".txt"),
            testpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[i], "_test", cv, "_sp", sp, ".txt"),
            chainLength=11000, burnin=1000, varGenotypic=gen[i], varResidual=res[i]
          )
          shcommand <- c(shcommand, paste("GenSel4R", myinp))
        }
      }
      
    }
  }
  
  
  return(shcommand)
}

####
wd <- getwd()
system("mkdir slurm-scripts/g2")
mysh <- Run7Trait(inppwd="slurm-scripts/g2/", genobase="/largedata/SNP/gerpIBD_h_g2_", mypi=0.99)
slurm4GenSelCV(
  shfile= "slurm-scripts/g2/gy_real_g2.sh", shcommand = mysh,
  sbathJ= "g2_real",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
# sbatch -p bigmemh slurm-scripts/g2/gy_real_g2.sh

####
wd <- getwd()
system("mkdir slurm-scripts/g1")
mysh <- Run7Trait(inppwd="slurm-scripts/g1/", genobase="/largedata/SNP/gerpIBD_h_g1_", mypi=0.99)
slurm4GenSelCV(
  shfile= "slurm-scripts/g1/gy_real_g1.sh", shcommand = mysh,
  sbathJ= "g1_real",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)

###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
# sbatch -p bigmemh slurm-scripts/g1/gy_real_g1.sh
