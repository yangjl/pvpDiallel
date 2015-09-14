# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

source("lib/slurm4gerpIBDCV.R")

### step 1: generate inp file for GenSel4B
RunByTrait <- function(i=1, csi){
  shcommand <- c()
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  
  for(mode in c("a2", "d2", "h2")){
    for(cv in 1:5){
      for(sp in 1:10){
        myinp <- paste0("slurm-scripts/g2/", ti[i], "_cs", csi, "_", mode,"_cv",cv, "_sp",sp, ".inp")
        GS_cv_inp(
          inp= myinp, pi=0.999,
          geno= paste0(wd, "/largedata/SNP/gerpIBD_h_b2_cs", csi, "_", mode, ".gs"), 
          trainpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[i], "_train", cv, "_sp", sp, ".txt"),
          testpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[i], "_test", cv, "_sp", sp, ".txt"),
          chainLength=11000, burnin=1000, varGenotypic=gen[i], varResidual=res[i]
        )
        shcommand <- c(shcommand, paste("GenSel4R", myinp))
      }
    }
  }
  return(shcommand)
}

####
wd <- getwd()
ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))

for(csi in 1:10){
  for(myi in 5){
    sh1 <- RunByTrait(i=myi, csi)
    ### slurm input
    slurm4GenSelCV(
      shfile= paste0("slurm-scripts/g2/runcv_", ti[myi], "_cs", csi, ".sh"), shcommand = sh1,
      sbathJ= paste0("g2_", ti[myi], "_cs", csi),  
      sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
      sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
    )
  }
}
  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh slurm-scripts/g2/runcv_gy_cs10.sh




