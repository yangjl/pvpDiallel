# Jinliang Yang
# Nov 2nd, 2014


source("lib/sh4GenSel_predict.R")

### step 1: generate inp file for GenSel4B
Run7Trait <- function(inppwd="slurm-scripts/gwas_b2/", genobase="largedata/SNP/gerpIBD_k_b1_", mypi=0.995){
  shcommand <- c()
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  dir.create(inppwd, showWarnings=FALSE)
  for(i in 1:7){
    inp1 <- paste0(inppwd, gsub(".*/", "", genobase), ti[i], ".inp")
    GenSel_inp(inp=inp1, 
               pi=mypi, 
               findscale ="no",
               geno = paste0(wd, "/", genobase, ti[i], "_h2.gs"),
               pheno = paste0(wd, "/largedata/pheno/wholeset/", ti[i], "_perse.txt"),
               chainLength=41000, burnin=1000, varGenotypic=gen[i], varResidual=res[i])
    
    inp2 <- paste0(inppwd, gsub(".*/", "", genobase), ti[i], "_predict_a2b.inp")
    Predict_inp(inp=inp2,
                geno= paste0(wd, "/", genobase, ti[i], "_a2b.gs"),
                pheno= paste0(wd, "/largedata/pheno/wholeset/", ti[i], "_perse.txt"),
                mrkRes= paste0(inppwd, gsub(".*/", "", genobase), ti[i], ".mrkRes1"))
    
    inp3 <- paste0(inppwd, gsub(".*/", "", genobase), ti[i], "_predict_ab2.inp")
    Predict_inp(inp=inp3,
                geno= paste0(wd, "/", genobase, ti[i], "_ab2.gs"),
                pheno= paste0(wd, "/largedata/pheno/wholeset/", ti[i], "_perse.txt"),
                mrkRes= paste0(inppwd, gsub(".*/", "", genobase), ti[i], ".mrkRes1"))
    
    
    shcommand <- c(shcommand, paste("GenSel4R", inp1), paste("GenSel4R", inp2), paste("GenSel4R", inp3))
  }
  return(shcommand)
}

cmd <- Run7Trait(inppwd="slurm-scripts/gwas_b2/", genobase="largedata/SNP/gerpIBD_k_b2_", mypi=0.995)



####
source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")

setUpslurm(
  slurmsh="slurm-scripts/gwas_b2/gwas_b2.sh",
  codesh=cmd,
  wd=NULL, jobid="gwas-b2", 
  email="yangjl0930@gmail.com"
)
