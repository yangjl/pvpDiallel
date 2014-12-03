# Jinliang Yang
# Nov 2nd, 2014


#test run of the 66 diallel of trait per se with additive model
ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)


source("lib/slurm4GenSel.R")
for(i in 1:7){ 
  trait <- tolower(ti[i])
  shfile <- paste("slurm-scripts/", trait, "_realrun.sh", sep="")
  phenofile <- paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/", trait, ".txt", sep="")
  
  slurm4GenSel(
    sh=shfile, 
    sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
    sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
    sbathJ=trait,
    
    pi=0.9999, findsale ="no",
    geno="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/snp11m_add_gensel.newbin", 
    pheno=phenofile,
    map="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/allsnps_11m_genetic.map",
    chainLength=41000, burnin=1000, varGenotypic= gen[i], varResidual= res[i]
  )
}


###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntaks=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=3 slurm-scripts/asi_realrun.sh
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntaks=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=3 slurm-scripts/dtp_realrun.sh
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntaks=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=3 slurm-scripts/dts_realrun.sh
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntaks=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=3 slurm-scripts/eht_realrun.sh
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntaks=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=3 slurm-scripts/gy_realrun.sh
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntaks=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=3 slurm-scripts/pht_realrun.sh
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntaks=x, 8GB of memory per CPU
###>>> RUN: sbatch -p serial --ntasks=3 slurm-scripts/tw_realrun.sh


