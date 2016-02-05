### Jinliang Yang
### Jan. 9th, 2014

source("lib/setUpslurm.R")

###### random shuffled data 
for(i in 1:10){
  input1 <- paste("largedata/SNP/gerp_cs", i, ".sh", sep="")
  input2 <- paste("gerpIBD -n positive -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
                  -g largedata/SNP/genic_gerpv2_cs", i, ".csv -o largedata/SNP/gerpIBD_cs", i, sep="")
  input3 <- paste("genic_gerp", i, sep="")
  
  setUpslurm(slurmsh=input1,
             oneline=TRUE,
             codesh=input2,
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ=input3) 
}

###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh largedata/SNP/gerp_cs1.sh

###>>> RUN: sbatch -p bigmemh largedata/SNP/gerp_cs2.sh

###>>> RUN: sbatch -p bigmemh largedata/SNP/gerp_cs3.sh

###>>> RUN: sbatch -p bigmemh largedata/SNP/gerp_cs4.sh

###>>> RUN: sbatch -p bigmemh largedata/SNP/gerp_cs5.sh

###>>> RUN: sbatch -p bigmemm largedata/SNP/gerp_cs6.sh

###>>> RUN: sbatch -p bigmemm largedata/SNP/gerp_cs7.sh

###>>> RUN: sbatch -p bigmemm largedata/SNP/gerp_cs8.sh

###>>> RUN: sbatch -p bigmemm largedata/SNP/gerp_cs9.sh

###>>> RUN: sbatch -p bigmemm largedata/SNP/gerp_cs10.sh
