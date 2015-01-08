### Jinliang Yang
### 1.5.2014
### purpose: run the gerpIBD program


source("lib/setUpslurm.R")

###### example
setUpslurm(slurmsh="largedata/SNP/gerp_cs1.sh",
           oneline=TRUE,
           codesh="gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
-g largedata/SNP/allsnps_11m_gerpv2_cs1.csv -o largedata/SNP/gerpIBD_output",
           wd=NULL,
           sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
           sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
           sbathJ="gerpibd1")
  
#################  
for(i in 1:10){
  input1 <- paste("largedata/SNP/gerp_cs", i, ".sh", sep="")
  input2 <- paste("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 \\
-g largedata/SNP/allsnps_11m_gerpv2_cs", i, ".csv -o largedata/SNP/gerpIBD_cs", i, sep="")
  input3 <- paste("gerpibd", i, sep="")
  
  setUpslurm(slurmsh=input1,
             oneline=TRUE,
             codesh=input2,
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ=input3) 
}
#RUN: sbatch -p serial --mem 16000 largedata/SNP/gerp_cs1.sh








################### and then generate map ###############################################






### need map file

### checking output results
library(data.table)
test <- fread("largedata/SNP/gerpIBD_output_a1.gs", header=TRUE, sep="\t")


### checing gerpIBD results and write the map file
h5 <- read.table("largedata/SNP/gerpIBD_output_a1.gs", header=TRUE, nrow=5)

map <- data.frame(ibdid=names(h5)[-1], AGPv2_chr=1, AGPv2_pos=1)
map$ibdid <- gsub("X", "", map$ibdid)
map$AGPv2_chr <- gsub("_.*", "", map$ibdid)
map$AGPv2_pos <- gsub(".*_", "", map$ibdid)

write.table(map, "largedata/SNP/gerpIBD_output.map", row.names=FALSE, quote=FALSE, sep="\t")





res <- read.table("currentest_d2.gs", header=TRUE)
