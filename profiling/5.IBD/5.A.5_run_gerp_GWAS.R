# Jinliang Yang
# Nov 2nd, 2014


#test run of the 66 diallel of trait per se with additive model
ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)


source("lib/slurm4GenSel.R")
for(i in 2:7){ 
  trait <- tolower(ti[1])
  shfile <- paste("slurm-scripts/", trait, "_testrun_d2_cs", i, ".sh", sep="")
  phenofile <- paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/", trait, ".txt", sep="")
  
  slurm4GenSel(
    sh=shfile, 
    sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
    sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
    sbathJ= paste(trait, "cs", i, sep=""),
    
    pi=0.999, findsale ="no",
    geno=paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/gerpIBD_cs", i, "_d2.gs", sep=""), 
    pheno=phenofile,
    map=paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/gerpIBD_cs", i, "_d2.map", sep=""), 
    chainLength=41000, burnin=1000, varGenotypic= gen[1], varResidual= res[1]
  )
}

#real run
#a1 0.451
#a2 0.47
#d1 0.476
#d2 0.01

sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a1_cs3.sh #0.443
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a2_cs3.sh #0.325
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d1_cs3.sh #0.447
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d2_cs3.sh #0.003

sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a1_cs4.sh #0.449
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a2_cs4.sh #0.325
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d1_cs4.sh #0.449
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d2_cs4.sh #0.003

sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a1_cs5.sh #0.470
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a2_cs5.sh #0.086
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d1_cs5.sh #0.470
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d2_cs5.sh #0.018

sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a1_cs6.sh #0.444
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a2_cs6.sh #0.174
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d1_cs6.sh #0.444
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d2_cs6.sh #

sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a1_cs7.sh #
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_a2_cs7.sh #
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d1_cs7.sh #
sbatch -p bigmeml --mem 16000 slurm-scripts/asi_testrun_d2_cs7.sh #










