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
for(i in 1:11){
  setup_newbin_array(
    genobase= paste0("largedata/SNP/gene_perse_cs/gene_perse_cs", i-1), jobid=21*(i-1)+1,
    phenobase="largedata/pheno/CV5fold",
    jobdir="largedata/SNP/gene_perse_cs", inpbase= paste0("cs",i -1),
    jobbase="newbin_job")
}

##### gensel: 10 sp x (7traits x 5 cv x 3 modes)
###[1] 115500 GS
for(i in 1:11){
  setup_gensel_array(
    outdir="largedata/SNP/gene_perse_cs/", jobbase="perse_gs_job", jobid=100*(i-1)+1,
    inpbase= paste0("largedata/SNP/gene_perse_cs/cs", i-1),
    phenobase="largedata/pheno/CV5fold",
    genobase= paste0("largedata/SNP/gene_perse_cs/gene_perse_cs", i-1))
}

###>>> setup gensel array jobs: [ 1001 - 1100]
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh largedata/SNP/gene_perse_cs//perse_gs_job.sh


############# GERP > 0, BPH #############
### 70 (10cs x 7 traits) array jobs, =>gerpid x 3modes
for(i in 1:11){
  setup_gerpibd_array_7traits(
    outdir="largedata/SNP/gene_bph_cs", jobbase="gerpid_gene_bph", jobid = 7*(i-1)+1,
    kfile_path="largedata/snpeff/BPH/",
    genobase= paste0("largedata/SNP/gene_bph_cs/gene_bph_cs", i-1))
}

## note: it is for 7 traits with 3 modes for one random shuffling or real data
for(i in 1:11){
  setup_newbin_array(
    genobase= paste0("largedata/SNP/gene_bph_cs/gene_bph_cs", i-1), jobid=21*(i-1)+1,
    phenobase="largedata/pheno/CV5fold_BPHmax",
    jobdir="largedata/SNP/gene_bph_cs", inpbase= paste0("cs",i -1),
    jobbase="newbin_job")
}

###[1] 115500 GS
for(i in 1:11){
  setup_gensel_array(
    outdir="largedata/SNP/gene_bph_cs/", jobbase="bph_gs_job", jobid=100*(i-1)+1,
    inpbase= paste0("largedata/SNP/gene_bph_cs/cs", i-1),
    phenobase="largedata/pheno/CV5fold_BPHmax",
    genobase= paste0("largedata/SNP/gene_bph_cs/gene_bph_cs", i-1))
}




