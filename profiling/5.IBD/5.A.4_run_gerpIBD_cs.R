### Jinliang Yang
### Jan. 9th, 2014

source("lib/setUpslurm.R")

###### random shuffled data 
for(i in 1:10){
  input1 <- paste("slurm-scripts/run_gerp2_cs", i, ".sh", sep="")
  input2 <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                 "-g largedata/SNP/gerpv2_b2_cs", i, ".csv -f largedata/snpeff/gy_h.txt ",
                 "-o largedata/SNP/gerpIBD_h_b2_cs", i)
  input3 <- paste("gerp2_h_cs", i, sep="")
  
  setUpslurm(slurmsh=input1,
             oneline=TRUE,
             codesh=input2,
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ=input3) 
}
#RUN:  sbatch -p serial --mem 8000 slurm-scripts/run_gerp2_cs10.sh



################### and then generate map ###############################################

### checking gerpIBD results and write the map file
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

