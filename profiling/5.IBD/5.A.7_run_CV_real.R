# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

source("lib/slurm4gerpIBDCV.R")

### step 1: generate inp file for GenSel4B
Run7Trait <- function(){
  shcommand <- c()
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  
  for(i in ti){
    for(mode in c("a1", "a2", "d1", "d2")){
      for(cv in 1:5){
        for(sp in 1:10){
          myinp <- paste0("slurm-scripts/", ti[i], "_real_", mode,"_cv",cv, "_sp",sp, ".inp")
          GS_cv_inp(
            inp= myinp, pi=0.999,
            geno= paste0(wd, "/largedata/SNP/gerpIBD_cs_", mode, ".gs.newbin"), 
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
mysh <- Run7Trait()
slurm4GenSelCV(
  shfile= "slurm-scripts/cv_realrun2000.sh", shcommand = mysh,
  sbathJ= "cv_realrun",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/cv_realrun2000.sh

