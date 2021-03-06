# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

### step 1: generate inp file for GenSel4B
Run7Trait_genic_cs <- function(inppwd="slurm-scripts/gerpfeature/", phenopwd="/largedata/pheno/CV5fold/",
                               cs=1, geno_pattern="gerpIBD_cs"){
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
          myinp <- paste0(inppwd, ti[i], "_cs", cs, "_", mode, "_sp",sp,"_cv",cv, ".inp")
          
          geno  <- paste0(wd, "/largedata/SNP/", geno_pattern, cs, "_", mode, ".gs.newbin")
          if(!file.exists(geno)){
            geno <- paste0(wd, "/largedata/SNP/", geno_pattern, cs, "_", mode, ".gs")
          }
          
          GS_cv_inp(
            inp= myinp, pi=0.999,
            geno= geno, 
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


#### BPHmax
source("lib/slurm4gerpIBDCV.R")
for(i in 1:10){
  wd <- getwd()
  mysh <- Run7Trait_genic_cs(inppwd="slurm-scripts/genic/", phenopwd="/largedata/pheno/CV5fold_BPHmax/",
                             geno_pattern="gerpIBD_cs",cs=i)
  slurm4GenSelCV(
    shfile= paste0("slurm-scripts/bph_genic_cs", i, ".sh"), shcommand = mysh,
    sbathJ= paste0("bph_genic_cs", i),  
    sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
    sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
  )
}
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemm slurm-scripts/bph_genic_cs1.sh
###>>> RUN: sbatch -p bigmemm slurm-scripts/bph_genic_cs2.sh
###>>> RUN: sbatch -p bigmemh slurm-scripts/bph_genic_cs3.sh
###>>> RUN: sbatch -p bigmemm slurm-scripts/bph_genic_cs4.sh
###>>> RUN: sbatch -p bigmemm slurm-scripts/bph_genic_cs5.sh
###>>> RUN: sbatch -p bigmemm slurm-scripts/bph_genic_cs6.sh
###>>> RUN: sbatch -p bigmemm slurm-scripts/bph_genic_cs7.sh
###>>> RUN: sbatch -p bigmemh slurm-scripts/bph_genic_cs8.sh
###>>> RUN: sbatch -p bigmemh slurm-scripts/bph_genic_cs9.sh
###>>> RUN: sbatch -p bigmemh slurm-scripts/bph_genic_cs10.sh



#### trait per se
source("lib/slurm4gerpIBDCV.R")
for(i in 1:10){
  wd <- getwd()
  mysh <- Run7Trait_genic_cs(inppwd="slurm-scripts/genicperse/", phenopwd="/largedata/pheno/CV5fold/",
                             geno_pattern="gerpIBD_cs",cs=i)
  slurm4GenSelCV(
    shfile= paste0("slurm-scripts/ps_genic_cs", i, ".sh"), shcommand = mysh,
    sbathJ= paste0("ps_genic_cs", i),  
    sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
    sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
  )
}

###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs1.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs2.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs3.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs4.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs5.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs6.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs7.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs8.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs9.sh
###>>> RUN: sbatch -p serial --ntasks=2 slurm-scripts/ps_genic_cs10.sh

####
source("lib/slurm4gerpIBDCV.R")
for(i in 1:10){
  wd <- getwd()
  mysh <- Run7Trait_genic_cs(inppwd="slurm-scripts/genicphph/", phenopwd="/largedata/pheno/CV5fold_pBPHmax/",
                             geno_pattern="gerpIBD_cs",cs=i)
  slurm4GenSelCV(
    shfile= paste0("slurm-scripts/pbph_genic_cs", i, ".sh"), shcommand = mysh,
    sbathJ= paste0("pbph_genic_cs", i),  
    sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
    sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
  )
}
###>>> sbatch -p bigmemm slurm-scripts/pbph_genic_cs1.sh


#### MPH
source("lib/slurm4gerpIBDCV.R")
for(i in 1:10){
  wd <- getwd()
  mysh <- Run7Trait_genic_cs(inppwd="slurm-scripts/genicmph/", phenopwd="/largedata/pheno/CV5fold_MPH/",
                             geno_pattern="gerpIBD_cs",cs=i)
  slurm4GenSelCV(
    shfile= paste0("slurm-scripts/MPH_genic_cs", i, ".sh"), shcommand = mysh,
    sbathJ= paste0("MPH_genic_cs", i),  
    sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
    sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
  )
}
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs1.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs2.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs3.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs4.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs5.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs6.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs7.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs8.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs9.sh
sbatch -p serial --ntasks=2 slurm-scripts/MPH_genic_cs10.sh

#### pMPH
source("lib/slurm4gerpIBDCV.R")
for(i in 1:10){
  wd <- getwd()
  mysh <- Run7Trait_genic_cs(inppwd="slurm-scripts/genicpmph/", phenopwd="/largedata/pheno/CV5fold_pMPH/",
                             geno_pattern="gerpIBD_cs",cs=i)
  slurm4GenSelCV(
    shfile= paste0("slurm-scripts/pMPH_genic_cs", i, ".sh"), shcommand = mysh,
    sbathJ= paste0("pMPH_genic_cs", i),  
    sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
    sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
  )
}
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs1.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs2.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs3.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs4.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs5.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs6.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs7.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs8.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs9.sh
sbatch -p serial --ntasks=2 slurm-scripts/pMPH_genic_cs10.sh



