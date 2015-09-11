### Jinliang Yang
### 1.5.2014
### purpose: run the gerpIBD program


source("lib/setUpslurm.R")
###### read data
codes <- paste("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5",
               "-g largedata/SNP/gerpv2_b0_real.csv -f largedata/snpeff/gy_h.txt",
               "-o largedata/SNP/gerpIBD_h")
setUpslurm(slurmsh="slurm-scripts/run_gerpibd_h.sh",
           oneline=TRUE,
           codesh=codes,
           wd=NULL,
           sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
           sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
           sbathJ="gerp_h")

codes <- paste("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5",
               "-g largedata/SNP/gerpv2_b1_real.csv -f largedata/snpeff/gy_h.txt",
               "-o largedata/SNP/gerpIBD_h_g1")
setUpslurm(slurmsh="slurm-scripts/run_gerpibd_h_g1.sh",
           oneline=TRUE,
           codesh=codes,
           wd=NULL,
           sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
           sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
           sbathJ="g1_h")

codes <- paste("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5",
               "-g largedata/SNP/gerpv2_b2_real.csv -f largedata/snpeff/gy_h.txt",
               "-o largedata/SNP/gerpIBD_h_g2")
setUpslurm(slurmsh="slurm-scripts/run_gerpibd_h_g2.sh",
           oneline=TRUE,
           codesh=codes,
           wd=NULL,
           sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
           sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
           sbathJ="g2_h")

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

getMap(infile= "largedata/SNP/gerpIBD_output.gs", outfile=NULL)
