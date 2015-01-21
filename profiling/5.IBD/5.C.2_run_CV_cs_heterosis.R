# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

source("lib/slurm4gerpIBDCV.R")

### step 1: generate inp file for GenSel4B
#Run7Trait_v2 <- function(inppwd="slurm-scripts/BPHmax/", phenopwd="/largedata/pheno/CV5fold/")
RunByTrait_v2 <- function(i=1, inppwd="slurm-scripts/BPHmax/", phenopwd="/largedata/pheno/CV5fold/"){
  shcommand <- c()
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  
  for(mode in c("a2", "d2")){
    for(csi in 1:10){
      for(cv in 1:5){
        for(sp in 1:10){
          myinp <- paste0(inppwd, ti[i], "_cs", csi, "_", mode,"_cv",cv, "_sp",sp, ".inp")
          GS_cv_inp(
            inp= myinp, pi=0.999,
            geno= paste0(wd, "/largedata/SNP/gerpIBD_cs", csi, "_", mode, ".gs.newbin"), 
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

################################################################
wd <- getwd()
ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))

for(myi in 1:7){
  sh1 <- RunByTrait_v2(i=myi,inppwd="slurm-scripts/BPHmax/", phenopwd="/largedata/pheno/CV5fold_BPHmax/")
  ### slurm input
  slurm4GenSelCV(
    shfile= paste0("slurm-scripts/BPHmax/BPHmax_", ti[myi], "_run2000.sh"), shcommand = sh1,
    sbathJ= paste0("BPHmax_run1k_", ti[myi]),  
    sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
    sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
  )
}

  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemm --ntask=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_asi_run2000.sh

#sbatch -p serial --ntasks=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_asi_run2000.sh
#sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_dtp_run2000.sh
#sbatch -p serial --ntasks=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_dts_run2000.sh
#sbatch -p serial --ntasks=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_eht_run2000.sh
#sbatch -p serial --ntasks=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_gy_run2000.sh
sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_pht_run2000.sh
sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_tw_run2000.sh

################################################################
wd <- getwd()
ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))

for(myi in 1:7){
  sh2 <- RunByTrait_v2(i=myi,inppwd="slurm-scripts/pBPHmax/", phenopwd="/largedata/pheno/CV5fold_pBPHmax/")
  ### slurm input
  slurm4GenSelCV(
    shfile= paste0("slurm-scripts/pBPHmax/pBPHmax_", ti[myi], "_run1k.sh"), shcommand = sh2,
    sbathJ= paste0("pBPHmax_run1k_", ti[myi]),  
    sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
    sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
  )
}


###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemm --ntask=2 --mem 16000 slurm-scripts/BPHmax/BPHmax_asi_run2000.sh
sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPHmax_asi_run1k.sh
sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPHmax_dtp_run1k.sh
sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPHmax_dts_run1k.sh
sbatch -p bigmemm --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPHmax_eht_run1k.sh
sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPHmax_gy_run1k.sh
sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPHmax_pht_run1k.sh
sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/pBPHmax/pBPHmax_tw_run1k.sh





