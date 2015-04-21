# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

source("lib/slurm4gerpIBDCV.R")
### step 1: generate inp file for GenSel4B
Run7Trait_v2 <- function(inppwd="slurm-scripts/BPHmax/", phenopwd="/largedata/pheno/CV5fold/"){
  shcommand <- c()
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  for(i in 1:7){
    for(mode in c("a2", "d2")){
      for(cv in 1:5){
        for(sp in 1:10){
          myinp <- paste0(inppwd, ti[i], "_real_", mode,"_cv",cv, "_sp",sp, ".inp")
          
          mygeno  <- paste0(wd, "/largedata/SNP/gerpIBD_output_", mode, ".gs.newbin")
          if(!file.exists(mygeno)){
            mygeno <- paste0(wd, "/largedata/SNP/gerpIBD_output_", mode, ".gs")
          }
          
          GS_cv_inp(
            inp= myinp, pi=0.999,
            geno= mygeno, 
            trainpheno= paste0(wd, phenopwd, ti[i], "_train", cv, "_sp", sp, ".txt"),
            testpheno= paste0(wd, phenopwd, ti[i], "_test", cv, "_sp", sp, ".txt"),
            chainLength=11000, burnin=1000, varGenotypic=gen[i], varResidual=res[i]
          )
          shcommand <- c(shcommand, paste("GenSel4R", myinp))
        }
      }
      
    }
  }
  
  return(shcommand)
}

#### HPHmax
wd <- getwd()
mysh <- Run7Trait_v2(inppwd="slurm-scripts/BPHmax/", phenopwd="/largedata/pheno/CV5fold_BPHmax/")

slurm4GenSelCV(
  shfile= "slurm-scripts/BPHmax/cv_real_run1000.sh", shcommand = mysh,
  sbathJ= "bphcv_realrun",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/BPHmax/cv_real_run1000.sh

#### pBPHmax
wd <- getwd()
mysh <- Run7Trait_v2(inppwd="slurm-scripts/pBPHmax/", phenopwd="/largedata/pheno/CV5fold_pBPHmax/")

slurm4GenSelCV(
  shfile= "slurm-scripts/pBPHmax/pBPH_real_run1000.sh", shcommand = mysh,
  sbathJ= "pBPH-cv_realrun",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)

###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPH_real_run1000.sh

#### MPH
wd <- getwd()
mysh <- Run7Trait_v2(inppwd="slurm-scripts/gerpall_MPH/", phenopwd="/largedata/pheno/CV5fold_MPH/")

slurm4GenSelCV(
  shfile= "slurm-scripts/MPH_real_run1000.sh", shcommand = mysh,
  sbathJ= "MPH-cv_realrun",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> RUN: sbatch -p bigmemh --ntasks 2 --mem 16000 slurm-scripts/MPH_real_run1000.sh

#### pMPH
wd <- getwd()
mysh <- Run7Trait_v2(inppwd="slurm-scripts/gerpall_pMPH/", phenopwd="/largedata/pheno/CV5fold_pMPH/")

slurm4GenSelCV(
  shfile= "slurm-scripts/pMPH_real_run1000.sh", shcommand = mysh,
  sbathJ= "p    MPH-cv_realrun",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> RUN: sbatch -p bigmemh --ntasks 2 --mem 16000 slurm-scripts/MPH_real_run1000.sh