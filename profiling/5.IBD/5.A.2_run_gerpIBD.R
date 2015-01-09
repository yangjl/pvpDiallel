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

### checing gerpIBD results and write the map file
getMap <- function(infile="largedata/SNP/gerpIBD_output_a1.gs", outfile=NULL){
  
  h5 <- read.table(infile, header=TRUE, nrow=5)
  
  map <- data.frame(ibdid=names(h5)[-1], AGPv2_chr=1, AGPv2_pos=1)
  map$ibdid <- gsub("X", "", map$ibdid)
  map$AGPv2_chr <- gsub("_.*", "", map$ibdid)
  map$AGPv2_pos <- gsub(".*_", "", map$ibdid)
  
  if(is.null(outfile)){
    outfile <- gsub("gs", "map", infile)
  }
  write.table(map, outfile, row.names=FALSE, quote=FALSE, sep="\t")
}


for(num in 4:7){
  getMap(infile= paste0("largedata/SNP/gerpIBD_cs", num, "_a1.gs"), outfile=NULL)
  getMap(infile= paste0("largedata/SNP/gerpIBD_cs", num, "_a2.gs"), outfile=NULL)
  getMap(infile= paste0("largedata/SNP/gerpIBD_cs", num, "_d1.gs"), outfile=NULL)
  getMap(infile= paste0("largedata/SNP/gerpIBD_cs", num, "_d2.gs"), outfile=NULL)
  message(sprintf("###--->>> output cs [ %s ] ", num)) 
}



