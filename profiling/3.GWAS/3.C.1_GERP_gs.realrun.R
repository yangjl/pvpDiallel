# Jinliang Yang
# Nov 23rd, 2014
# run the cv with GERP SNPs
source("lib/slurm4GenSelCV.R")


#test run of the 66 diallel of trait per se with additive model
ti <- c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW")
res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)


### run a single trait as a test!!!
# using GERP data
# run 12 CV

Set12Run <- function(include="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/inmarker/snp_gerp_bg0.txt",
                     trait = "DTP", shfile="slurm-scripts/DTP_gerprun.sh", jobid="dtpgerp", pi=0.9999, varid=2,
                     inpbase="cvgerp"){
  
  ### generate 12 inp
  geno="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/snp11m_add_gensel.newbin"
  myinp <- c()
  for(i in 1:12){
    inp <- paste("slurm-scripts/", trait, inpbase, i, ".inp", sep="")
    trainP <- paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/CV/", tolower(trait), "_train", i, ".txt", sep="")
    testP <- paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/CV/", tolower(trait), "_test", i, ".txt", sep="")
    
    ##### parameters pass to GenSel input
    GenSel_inp(inp=inp, geno=geno,inmarker=include, trainpheno=trainP, testpheno=testP, pi=pi, findsale ="no", 
               chainLength=41000, burnin=1000, varGenotypic= gen[varid], varResidual= res[varid])
    myinp <- c(myinp, inp)
  }
  ##### 1 slurm script
  slurm4GenSelCV(sh=shfile, inp=myinp,
                 sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
                 sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
                 sbathJ=jobid)
}
############################################################################################


#### RUN GERP for DTP
Set12Run(include="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/inmarker/snp_gerp_bg0.txt",
         inpbase="_gerp", pi=0.9999,varid=2,
         trait = "DTP", shfile="slurm-scripts/DTP_gerprun.sh", jobid="dtpgerp")

#### RUN 10 random SNP sets
for(k in 1:10){
  Set12Run(include=paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/inmarker/snprandom_set", k, ".txt", sep=""),
           inpbase= paste("_randsnp", k, "_s", sep=""), pi=0.9999,varid=2,
           trait = "DTP", shfile=paste("slurm-scripts/DTP_rand", k, ".sh", sep=""), jobid=paste("dtp", k, sep=""))
}


### RUN >2 29k GERP for ASI
Set12Run(include="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/inmarker/snp_gerp_bg2.txt",
         inpbase="_gerp29k_", pi=0.998,varid=1,
         trait = "ASI", shfile="slurm-scripts/ASI_gerp29k.sh", jobid="asi_gerp")

#### RUN 10 random 29k SNP sets for ASI trait
for(k in 1:10){
  Set12Run(include=paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/inmarker/snp29k_set", k, ".txt", sep=""),
           inpbase= paste("_snp29k", k, "_s", sep=""), pi=0.998,varid=1,
           trait = "ASI", shfile=paste("slurm-scripts/ASI_snp29k_", k, ".sh", sep=""), jobid=paste("asi", k, sep=""))
}

### RUN < -4 29k GERP for ASI
Set12Run(include="/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/inmarker/snp_gerp_sm4.txt",
         inpbase="_gerpsm4_", pi=0.998,varid=1,
         trait = "ASI", shfile="slurm-scripts/ASI_gerpsm4.sh", jobid="asi_gerp4")

#### RUN 10 random 29k SNP sets for ASI trait
for(k in 1:10){
  Set12Run(include=paste("/home/jolyang/Documents/Github/pvpDiallel/largedata/SNP/inmarker/snps4_set", k, ".txt", sep=""),
           inpbase= paste("_snpsm4_", k, "_s", sep=""), pi=0.998,varid=1,
           trait = "ASI", shfile=paste("slurm-scripts/ASI_snpsm4_", k, ".sh", sep=""), jobid=paste("asism4_", k, sep=""))
}




sbatch -p bigmemh --ntasks=2 slurm-scripts/DTP_gerprun.sh
sbatch -p serial --ntasks=2  slurm-scripts/ASI_gerp29k.sh
sbatch -p serial --ntasks=2  slurm-scripts/ASI_snp29k_1.sh

sbatch -p serial --ntasks=2  slurm-scripts/ASI_gerpsm4.sh
sbatch -p serial --ntasks=2  slurm-scripts/ASI_snpsm4_1.sh















