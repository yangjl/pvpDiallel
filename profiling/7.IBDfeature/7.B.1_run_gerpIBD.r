### Jinliang Yang
### Feb 4th, 2016

source("lib/cv_array_jobs.R")
############# GERP > 0, per se #############
### 70 (10cs x 7 traits) array jobs, =>gerpid x 3modes
for(i in 1:11){
  setup_gerpibd_array_7traits(
    outdir="largedata/SNP/gene_perse_cs", jobbase="gerpid_gene_ps", jobid = 7*(i-1)+1,
    kfile_path="largedata/snpeff/perse/",
    genobase= paste0("largedata/SNP/gene_perse_cs/gene_perse_cs", i-1))
}







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


############# GERP > 0, BPH #############
### 70 (10cs x 7 traits) array jobs, =>gerpid x 3modes
for(i in 1:11){
  setup_gerpibd_array_7traits(
    outdir="largedata/SNP/gene_bph_cs", jobbase="gerpid_gene_bph", jobid = 7*(i-1)+1,
    kfile_path="largedata/snpeff/BPH/",
    genobase= paste0("largedata/SNP/gene_bph_cs/gene_bph_cs", i-1))
}





