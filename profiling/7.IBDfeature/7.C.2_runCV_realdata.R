# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

### step 1: generate inp file for GenSel4B
Run7Trait_genic_real <- function(inppwd="slurm-scripts/gerpfeature/", phenopwd="/largedata/pheno/CV5fold_BPHmax/",
                                 geno_pattern="gerp_gene_b0_"){
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
          myinp <- paste0(inppwd, ti[i], "_cs0_", mode, "_sp",sp,"_cv",cv, ".inp")
          
          geno  <- paste0(wd, "/largedata/SNP/", geno_pattern, mode, ".gs.newbin")
          if(!file.exists(geno)){
            geno <- paste0(wd, "/largedata/SNP/", geno_pattern, mode, ".gs")
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

#### trait per se
source("lib/slurm4gerpIBDCV.R")
wd <- getwd()
mysh <- Run7Trait_genic_real(inppwd="slurm-scripts/genicperse/", phenopwd="/largedata/pheno/CV5fold/",
                             geno_pattern="gerp_gene_b0_")
slurm4GenSelCV(
  shfile= "slurm-scripts/ps_genic_real.sh",
  shcommand = mysh,
  sbathJ= "ps_genic_real",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/ps_genic_real.sh

#### BPHmax
source("lib/slurm4gerpIBDCV.R")
wd <- getwd()
mysh <- Run7Trait_genic_real(inppwd="slurm-scripts/genicbphmax/", phenopwd="/largedata/pheno/CV5fold_BPHmax/",
                                 geno_pattern="gerp_gene_b0_")
slurm4GenSelCV(
  shfile= "slurm-scripts/bph_genic_real.sh",
  shcommand = mysh,
  sbathJ= "bph_genic_real",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemm --ntask=2 --mem 16000 slurm-scripts/bph_genic_real.sh


#### pBPHmax
source("lib/slurm4gerpIBDCV.R")
mysh <- Run7Trait_genic_real(inppwd="slurm-scripts/genicphph/", phenopwd="/largedata/pheno/CV5fold_pBPHmax/",
                             geno_pattern="gerp_gene_b0_")
slurm4GenSelCV(
  shfile= "slurm-scripts/phph_genic_real.sh",
  shcommand = mysh,
  sbathJ= "phph_genic_real",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --ntasks=2 --mem 16000 slurm-scripts/phph_genic_real.sh

######-------- ############

#### BPHmin
mysh <- Run7Trait_genic_real(inppwd="slurm-scripts/genicbphmin/", phenopwd="/largedata/pheno/CV5fold_BPHmin/",
                             geno_pattern="gerp_gene_b0_")
slurm4GenSelCV(
  shfile= "slurm-scripts/BPHmin_real.sh",
  shcommand = mysh,
  sbathJ= "BPHmin",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --ntasks 2 --mem 16000 slurm-scripts/BPHmin_real.sh

#### pBPHmin
mysh <- Run7Trait_genic_real(inppwd="slurm-scripts/genicpbphmin/", phenopwd="/largedata/pheno/CV5fold_pBPHmin/",
                             geno_pattern="gerp_gene_b0_")
slurm4GenSelCV(
  shfile= "slurm-scripts/pBPHmin_real.sh",
  shcommand = mysh,
  sbathJ= "pBPHmin",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --ntasks 2 --mem 16000 slurm-scripts/pBPHmin_real.sh

#### BPHmin
mysh <- Run7Trait_genic_real(inppwd="slurm-scripts/genicmph/", phenopwd="/largedata/pheno/CV5fold_MPH/",
                             geno_pattern="gerp_gene_b0_")
slurm4GenSelCV(
  shfile= "slurm-scripts/MPH_real.sh",
  shcommand = mysh,
  sbathJ= "MPH",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --ntasks 2 --mem 16000 slurm-scripts/MPH_real.sh

#### pBPHmin
mysh <- Run7Trait_genic_real(inppwd="slurm-scripts/genicpmph/", phenopwd="/largedata/pheno/CV5fold_pMPH/",
                             geno_pattern="gerp_gene_b0_")
slurm4GenSelCV(
  shfile= "slurm-scripts/pMPH_real.sh",
  shcommand = mysh,
  sbathJ= "pMPH",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --ntasks 2 --mem 16000 slurm-scripts/pMPH_real.sh





