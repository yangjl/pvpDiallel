# Jinliang Yang
# Jan 9th, 2015
# run the cv with GERP SNPs

source("lib/slurm4gerpIBDCV.R")

### step 1: generate inp file for GenSel4B
Run7Trait_gerpfeature <- function(inppwd="slurm-scripts/gerpfeature/", phenopwd="/largedata/pheno/CV5fold/",
                                  g=1){
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
          myinp <- paste0(inppwd, ti[i], "_", g, mode,"_cv",cv, "_sp",sp, ".inp")
          
          geno  <- paste0(wd, "/largedata/SNP/", gerpf[g], mode, ".gs.newbin")
          if(!file.exists(geno)){
            geno <- paste0(wd, "/largedata/SNP/", gerpf[g], mode, ".gs")
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


gerpf <- c("gerp_gene_b0_", "gerp_gene_s0_", "gerp_exon_b0_", 
           "gerp_exon_s0_", "gerp_intron_b0_", "gerp_intron_s0_")
####
wd <- getwd()
mysh <- Run7Trait_gerpfeature(inppwd="slurm-scripts/gerpfeature/", phenopwd="/largedata/pheno/CV5fold_BPHmax/",
                              g=1)

slurm4GenSelCV(
  shfile= "slurm-scripts/bphcv_gerpf_run700.sh", shcommand = mysh,
  sbathJ= "bphcv_gerpf1",  
  sbatho= paste0(wd, "/slurm-log/testout-%j.txt"),
  sbathe= paste0(wd, "/slurm-log/error-%j.txt")                     
)
  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemm --mem 16000 slurm-scripts/bphcv_gerpf_run700.sh

####
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



