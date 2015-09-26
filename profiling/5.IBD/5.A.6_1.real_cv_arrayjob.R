### Jinliang Yang
### Jan. 9th, 2014


source("lib/cv_array_jobs.R")

############# GERP > 2, per se #############
### array job for 7 traits => 3 modes
setup_gerpibd_array_7traits(
  outdir="slurm-scripts/cv_b2", jobbase="run_gerpid_job", jobid =1,
  genobase="largedata/SNP/geno_b2_cs/gerpv2_b2_cs0")

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










### setup codes
real_array(outdir="slurm-scripts/cv_b2/", jobbase="run_job", 
         genobase="largedata/SNP/geno_b2_cs/gerpv2_b2_cs", totcs=0)

###submit an array job
set_arrayjob(shid="slurm-scripts/cv_b2/run_arrayjob.sh",
             shcode="sh slurm-scripts/cv_b2/run_job$SLURM_ARRAY_TASK_ID.sh",
             arrayjobs="1-7",
             wd=NULL, jobid="cvb2", email="yangjl0930@gmail.com")

############# GERP > 1, per se #############
### setup codes
real_array(outdir="slurm-scripts/cv_b1/", jobbase="run_job", 
           genobase="largedata/SNP/geno_b1_cs/gerpv2_b1_cs", totcs=0)

###submit an array job
set_arrayjob(shid="slurm-scripts/cv_b1/run_arrayjob.sh",
             shcode="sh slurm-scripts/cv_b1/run_job$SLURM_ARRAY_TASK_ID.sh",
             arrayjobs="1-7",
             wd=NULL, jobid="real_b1", email="yangjl0930@gmail.com")

############# GERP > 0, per se #############
### setup codes
real_array(outdir="slurm-scripts/cv_b0/", jobbase="run_job", 
           genobase="largedata/SNP/geno_b0_cs/gerpv2_b0_cs", totcs=0)

###submit an array job
set_arrayjob(shid="slurm-scripts/cv_b0/run_arrayjob.sh",
             shcode="sh slurm-scripts/cv_b0/run_job$SLURM_ARRAY_TASK_ID.sh",
             arrayjobs="1-7",
             wd=NULL, jobid="real_b0", email="yangjl0930@gmail.com")




# serial --mem 8000 --ntasks=4