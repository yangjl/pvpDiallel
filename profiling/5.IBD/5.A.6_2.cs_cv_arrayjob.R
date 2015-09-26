### Jinliang Yang
### Jan. 9th, 2014

source("lib/cv_array_jobs.R")

############# GERP > 2, per se #############
### 700 (100cs x 7 traits) array jobs, =>gerpid x 3modes

for(i in 1:100){
  setup_gerpibd_array_7traits(
    outdir="slurm-scripts/cv_b2", jobbase="gerpid_cs_job", jobid = 7*(i-1)+1,
    genobase= paste0("largedata/SNP/geno_b2_cs/gerpv2_b2_cs", i))
}


#[STOP HERE]

## note: it is for 7 traits with 3 modes for one random shuffling or real data
setup_newbin_array(
  genobase="largedata/SNP/geno_b2_cs/gerpv2_b2_cs0", jobid=1,
  jobdir="slurm-scripts/get_newbin", jobbase="run_newbin_job")

check <- list.files(path="largedata/SNP/geno_b2_cs", pattern="newbin$")
# rm *gs

##### gensel: 10 sp x (7traits x 5 cv x 3 modes)
setup_gensel_array(
  outdir="slurm-scripts/cv_b2", jobbase="run_gs_job", jobid=1,
  inpbase="slurm-scripts/cv_b2/cs0",
  genobase="largedata/SNP/geno_b2_cs/gerpv2_b2_cs0")




############# GERP > 0, per se #############
### 700 (100cs x 7 traits) array jobs, =>gerpid x 3modes

for(i in 1:10){
  setup_gerpibd_array_7traits(
    outdir="slurm-scripts/cv_b0", jobbase="gerpid_cs_job", jobid = 7*(i-1)+1,
    genobase= paste0("largedata/SNP/geno_b0_cs/gerpv2_b2_cs", i))
}












