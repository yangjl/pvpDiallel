### Jinliang Yang
### Jan. 9th, 2014
### updated: 4/7/2016


library(farmeR)

#test run of the 66 diallel of trait per se with additive model
ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)

### convert geno into newbin
inputdf <- data.frame(pi=0.995,
                      geno="/Users/yangjl/Documents/GWAS2_KRN/SNP/merged/geno_chr.newbin",
                      trainpheno="/Users/yangjl/Documents/Heterosis_GWAS/pheno2011/reports/cd_GenSel_fullset.txt",
                      testpheno="/Users/yangjl/Documents/Heterosis_GWAS/pheno2011/reports/cd_GenSel_fullset.txt",
                      chainLength=10, burnin=1, varGenotypic=1.4, varResidual=2)

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



