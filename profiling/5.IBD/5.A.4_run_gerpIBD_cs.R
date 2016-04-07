### Jinliang Yang
### Jan. 9th, 2014

source("lib/setUpslurm.R")

###### random shuffled data 
traits <- c("asi", "dtp", "dts", "eht", "gy", "pht", "tw")
for(j in 1:7){
  ### the number of cs
  for(i in 1:10){
    ### sh file let farm to run
    input1 <- paste("slurm-scripts/gerpibd_b0/run_cs", i, "_", traits[j], ".sh", sep="")
    ### gerpIBD command goes into the sh
    input2 <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                     "-g largedata/SNP/geno_b0_cs/gerpv2_b0_cs", i, ".csv -f largedata/snpeff/", traits[j], "_k.txt ",
                     "-o largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_", traits[j])
    #rm2 <- c("rm largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_*b*")
    ### farm job id
    input3 <- paste("gerpm2_b1_h_cs", i, sep="")
    
    setUpslurm(slurmsh=paste0("slurm-scripts/run_k_", traits[j], ".sh"),
               oneline=TRUE,
               codesh=codes,
               wd=NULL,
               sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
               sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
               sbathJ= traits[j],
               mtype=c("short", "sbatch -p serail"))
  }
}

#RUN:  sbatch -p bigmemh slurm-scripts/run_m2_gerp1_cs10.sh

# loop over all FASTA files in the directory, print the filename
# (so we have some visual progress indicator), then submit the
# gzip jobs to SLURM
#
for FILE in *.fasta; do
echo ${FILE}
sbatch -p serial_requeue -t 10 --mem=200 --wrap="gzip ${FILE}"
sleep 1 # pause to be kind to the scheduler
done
source("lib/setUpslurm.R")



###### read data, GERP>0, seven traits
for(i in 1:length(traits)){
  codes <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                  "-g largedata/SNP/geno_b0_cs/gerpv2_b0_cs0.csv -f largedata/snpeff/perse/", traits[i], "_k.txt ",
                  "-o largedata/newGERPv2/test_k_", traits[i])
  setUpslurm(slurmsh=paste0("slurm-scripts/run_k_", traits[i], ".sh"),
             oneline=TRUE,
             codesh=codes,
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ=traits[i],
             mtype=c("short", "sbatch -p bigmemh"))
}



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

