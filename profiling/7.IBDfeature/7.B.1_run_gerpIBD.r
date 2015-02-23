### Jinliang Yang
### Feb 22nd, 2015

source("lib/setUpslurm.R")
###### read data
### Note: install the new version of gerpIBD
setUpslurm(slurmsh="largedata/SNP/gerp_cs1.sh",
           oneline=TRUE,
           codesh="gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
-g largedata/SNP/gerp11m_in_gene_b0.csv -n no  -o largedata/SNP/gerp_gene_b0",
           wd=NULL,
           sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
           sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
           sbathJ="gerpibd1")

##################
codes <- c("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
            -g largedata/SNP/gerp11m_in_gene_b0.csv -n no  -o largedata/SNP/gerp_gene_b0",
           
           "gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
            -g largedata/SNP/gerp11m_in_gene_s0.csv -n no  -o largedata/SNP/gerp_gene_s0",
           
           "gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
            -g largedata/SNP/gerp11m_in_exon_b0.csv -n no  -o largedata/SNP/gerp_exon_b0",
           
           "gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
            -g largedata/SNP/gerp11m_in_exon_s0.csv -n no  -o largedata/SNP/gerp_exon_s0",
           
           "gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
            -g largedata/SNP/gerp11m_in_intron_b0.csv -n no  -o largedata/SNP/gerp_intron_b0",
           
           "gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
            -g largedata/SNP/gerp11m_in_intron_s0.csv -n no  -o largedata/SNP/gerp_intron_s0"
           )

source("lib/setUpslurm.R")
###### read data
for(i in 1:6){
  ### Note: install the new version of gerpIBD
  setUpslurm(slurmsh= paste0("largedata/SNP/gerp", i, ".sh"),
             oneline=TRUE,
             codesh= codes[i],
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ= paste0("gerp", i)) 
}
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> note --ntask=x, 8GB of memory per CPU
###>>> RUN: sbatch -p bigmemh --mem 16000 largedata/SNP/gerp1.sh

###>>> RUN: sbatch -p bigmemh --mem 16000 largedata/SNP/gerp2.sh

###>>> RUN: sbatch -p bigmemh --mem 16000 largedata/SNP/gerp3.sh

###>>> RUN: sbatch -p bigmemm --mem 16000 largedata/SNP/gerp4.sh

###>>> RUN: sbatch -p bigmemm --mem 16000 largedata/SNP/gerp5.sh

###>>> RUN: sbatch -p bigmemm --mem 16000 largedata/SNP/gerp6.sh
