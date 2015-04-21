# Jinliang Yang
# April 21, 2015
# run the wholeset with GERP SNPs

source("lib/RunWhoeSet_genic.R")
####

mysh <- RunWholeSet_genic(inppwd="slurm-scripts/wholeset/")

setUpslurm(slurmsh="slurm-scripts/wholeset_testrun.sh",
           codesh=mysh,
           wd=NULL, jobid="testrun", email=TRUE                  
)
  
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh --ntasks 2 slurm-scripts/wholeset_testrun.sh





