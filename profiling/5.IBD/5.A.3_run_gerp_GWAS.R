# Jinliang Yang
# Nov 2nd, 2014


#test run of the 66 diallel of trait per se with additive model
ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)


source("lib/slurm4GenSel.R")
for(i in 1:7){ 
  trait <- tolower(ti[i])
  shfile <- paste("slurm-scripts/", trait, "_realrun_a2.sh", sep="")
  phenofile <- paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/", trait, ".txt", sep="")
  
  slurm4GenSel(
    sh=shfile, 
    sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
    sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
    sbathJ=trait,
    
    pi=0.999, findsale ="no",
    geno="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/gerpIBD_output_a2.gs", 
    pheno=phenofile,
    map="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/gerpIBD_output.map",
    chainLength=41000, burnin=1000, varGenotypic= gen[i], varResidual= res[i]
  )
}

sbatch -p bigmemh --mem 16000 slurm-scripts/asi_realrun_a2.sh
sbatch -p bigmemh --mem 16000 slurm-scripts/asi_realrun_d1.sh
sbatch -p bigmemh --mem 16000 slurm-scripts/asi_realrun_d2.sh

sbatch -p bigmeml --mem 16000 slurm-scripts/dtp_realrun.sh



