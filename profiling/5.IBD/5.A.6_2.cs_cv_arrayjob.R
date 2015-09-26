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

## note: it is for 7 traits with 3 modes for one random shuffling or real data
for(i in 1:10){
  setup_newbin_array(
    genobase= paste0("largedata/SNP/geno_b2_cs/gerpv2_b2_cs", i), jobid=21*(i-1)+1,
    jobdir="slurm-scripts/get_newbin", inpbase= paste0("cs",i),
    jobbase="run_newbin_job")
}

check <- list.files(path="largedata/SNP/geno_b2_cs", pattern="newbin$")
# rm *gs

##### gensel: 10 sp x (7traits x 5 cv x 3 modes)
for(i in 1:10){
  setup_gensel_array(
    outdir="slurm-scripts/cv_b2", jobbase="run_gs_job", jobid=10*(i-1)+1,
    inpbase= paste0("slurm-scripts/cv_b2/cs", i),
    genobase= paste0("largedata/SNP/geno_b2_cs/gerpv2_b2_cs", i))
  
}



############# GERP > 0, per se #############
### 700 (100cs x 7 traits) array jobs, =>gerpid x 3modes

for(i in 1:100){
  setup_gerpibd_array_7traits(
    outdir="slurm-scripts/cv_b0", jobbase="gerpid_cs_job", jobid = 7*(i-1)+1,
    genobase= paste0("largedata/SNP/geno_b0_cs/gerpv2_b0_cs", i))
}










