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
  phenofile <- paste("/home/jolyang/Documents/pvpDiallel/largedata/pheno/", trait, ".txt", sep="")
  
  slurm4GenSel(
    sh=shfile, 
    sbatho="/home/jolyang/Documents/pvpDiallel/slurm-log/testout-%j.txt",
    sbathe="/home/jolyang/Documents/pvpDiallel/slurm-log/error-%j.txt",
    sbathJ=trait,
    
    pi=0.99999, findsale ="no",
    geno="/home/jolyang/Documents/pvpDiallel/largedata/SNP/snp11m_add_gensel.newbin", 
    pheno=phenofile,
    map="/home/jolyang/Documents/pvpDiallel/largedata/SNP/allsnps_11m.map",
    chainLength=101000, burnin=1000, varGenotypic= gen[i], varResidual= res[i]
  )
}





