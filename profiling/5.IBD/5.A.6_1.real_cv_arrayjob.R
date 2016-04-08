### Jinliang Yang
### Jan. 9th, 2014
### updated: 4/7/2016

library(farmeR)

### convert geno into newbin
gsfiles <- list.files(path="/home/jolyang/Documents/Github/pvpDiallel/largedata/newGERPv2/allgeno", 
                      pattern="gs$", full.names=TRUE)
inputdf <- data.frame(
  pi=0.995, geno=gsfiles,
  trainpheno="/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/CV5fold/gy_train1_sp1.txt",
  testpheno="/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/CV5fold/gy_test1_sp1.txt",
  chainLength=10, burnin=1, varGenotypic=1.4, varResidual=2
)

run_GenSel4(inputdf, inpdir="largedata/newGERPv2/allgeno", 
            email="yangjl0930@gmail.com", runinfo = c(TRUE, "med", 1) )


### convert geno into newbin
#test run of the 66 diallel of trait per se with additive model
ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)

#7traits x 3 modes x 12 permuation x  5 fold 100 rand x
inputdf <- data.frame()
pwd <- "/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/CV5fold/"
a2 <- list.files(path="/home/jolyang/Documents/Github/pvpDiallel/largedata/newGERPv2/allgeno", 
                      pattern="a2.gs.newbin$", full.names=TRUE)
d2 <- list.files(path="/home/jolyang/Documents/Github/pvpDiallel/largedata/newGERPv2/allgeno", 
                 pattern="d2.gs.newbin$", full.names=TRUE)
h2 <- list.files(path="/home/jolyang/Documents/Github/pvpDiallel/largedata/newGERPv2/allgeno", 
                 pattern="h2.gs.newbin$", full.names=TRUE)

for(i in 1:7){
  for(j in 1:3){
    for(p in 1:12){
      for(f in 1:5){
        for(r in 1:100){
          tem <- data.frame(
            pi=0.995,
            geno="/Users/yangjl/Documents/GWAS2_KRN/SNP/merged/geno_chr.newbin",
            trainpheno=paste0(pwd, ti[i], "_train1_sp1.txt",),
            testpheno="/Users/yangjl/Documents/Heterosis_GWAS/pheno2011/reports/cd_GenSel_fullset.txt",
            chainLength=41000, burnin=1000, varGenotypic=1.4, varResidual=2
          ) 
        }
      }
    }
  }
}

inputdf <- 

#traits = 7 x geno=12(11+1) x mode = 3 (3+1) x rand 100 x 5-fold
7*12*4*100*5=168000 ### training works
run_GenSel4(inputdf, inpdir="slurm-script", email=NULL, runinfo = c(FALSE, "bigmemh", 1) )




source("lib/cv_array_jobs.R")

############# GERP > 0, per se #############
### array job for 7 traits => 3 modes
setup_gerpibd_array_7traits(
  outdir="slurm-scripts/cv_b0", jobbase="run_gerpid_job", jobid =1,
  genobase="largedata/SNP/geno_b0_cs/gerpv2_b0_cs0")

## note: it is for 7 traits with 3 modes for one random shuffling or real data
setup_newbin_array(
  genobase="largedata/SNP/geno_b0_cs/gerpv2_b0_cs0", jobid=1,
  jobdir="slurm-scripts/get_newbin", jobbase="run_newbin_job")

check <- list.files(path="largedata/SNP/geno_b0_cs", pattern="newbin$")
# rm *gs

##### gensel: 100 sp x (7traits x 5 cv x 3 modes)
setup_gensel_array(
  outdir="slurm-scripts/cv_b0", jobbase="gs_b0_job", jobid=1,
  inpbase="slurm-scripts/cv_b0/cs0",
  genobase="largedata/SNP/geno_b0_cs/gerpv2_b0_cs0")



