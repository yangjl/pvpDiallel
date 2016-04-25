### Jinliang Yang
### 1.5.2014
### purpose: run the gerpIBD program


###############
gerpfile <- list.files(path="largedata/newGERPv2/allgeno", pattern="csv$", full.names=TRUE)
inputdf <- data.frame(
  d="largedata/IBD/allsnps_11m_IBD.bed", 
  s="largedata/SNP/allsnps_newgerp2_50k.dsf7", #deine deleterious alleles
  g=gerpfile, 
  f="largedata/newGERPv2/allgeno/k5.txt",
  out=gsub(".csv", "", gerpfile),
  l=1,
  t="all"
)

library(farmeR)
run_gerpIBD(inputdf, email="yangjl0930@gmail.com", runinfo = c(TRUE, "med", 2) )

############### trait-specific k
gerpfile <- list.files(path="largedata/newGERPv2/allgeno", pattern="csv$", full.names=TRUE)
kfile <- list.files(path="largedata/snpeff/perse", pattern="_k.txt$", full.names=TRUE)
inputdf <- data.frame(
  d="largedata/IBD/allsnps_11m_IBD.bed", 
  s="largedata/SNP/allsnps_newgerp2_50k.dsf7", #deine deleterious alleles
  g= rep(gerpfile, times = 7),
  f= rep(kfile, each=12),
  out=gsub("allgeno", "allgeno_k", gsub(".csv", "", gerpfile)),
  l=1,
  t="k"
)

inputdf$out <- paste0(inputdf$out, "_", gsub(".*/|_k.txt", "", inputdf$f), "_perse")

library(farmeR)
run_gerpIBD(inputdf, email="yangjl0930@gmail.com", runinfo = c(TRUE, "bigmemh", 1) )








##############################################



for(j in 1:7){
  shid <- paste0(outdir, "/", jobbase, jobid, ".sh")
  ### gerpIBD command goes into the sh
  sh1 <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                "-g ", genobase, ".csv -f ", kfile_path, "/", traits[j], "_k.txt ",
                "-o ", genobase, "_", traits[j],
                " -t k")
  cat(sh1, file=shid, sep="\n", append=FALSE)
  message(sprintf("###>>> traits [ %s ]; total jobs [ %s ]", traits[j], jobid))
  jobid <- jobid+1
}


source("lib/setUpslurm.R")

traits <- c("asi", "dtp", "dts", "eht", "gy", "pht", "tw")

###### read data, GERP>0, seven traits
for(i in 1:length(traits)){
  codes <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                 "-g largedata/SNP/gerpv2_b0_real.csv -f largedata/snpeff/", traits[i], "_k.txt ",
                 "-o largedata/SNP/gerpIBD_k_", traits[i])
  setUpslurm(slurmsh=paste0("slurm-scripts/run_k_", traits[i], ".sh"),
             oneline=TRUE,
             codesh=codes,
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ=traits[i],
             mtype=c("short", "sbatch -p bigmemh"))
}

###### read data, GERP>1, seven traits
for(i in 1:length(traits)){
  codes <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                  "-g largedata/SNP/gerpv2_b1_real.csv -f largedata/snpeff/", traits[i], "_k.txt ",
                  "-o largedata/SNP/gerpIBD_k_b1_", traits[i])
  setUpslurm(slurmsh=paste0("slurm-scripts/run_k_b1_", traits[i], ".sh"),
             oneline=TRUE,
             codesh=codes,
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ= paste0("b1_", traits[i]),
             mtype=c("short", "sbatch -p bigmemh"))
}

###### read data, GERP>2, seven traits
for(i in 1:length(traits)){
  codes <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                  "-g largedata/SNP/gerpv2_b2_real.csv -f largedata/snpeff/", traits[i], "_k.txt ",
                  "-o largedata/SNP/gerpIBD_k_b2_", traits[i])
  setUpslurm(slurmsh=paste0("slurm-scripts/run_k_b2_", traits[i], ".sh"),
             oneline=TRUE,
             codesh=codes,
             wd=NULL,
             sbatho="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt",
             sbathe="/home/jolyang/Documents/Github/pvpDiallel/slurm-log/error-%j.txt",
             sbathJ= paste0("b2_", traits[i]),
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

getMap(infile= "largedata/SNP/gerpIBD_output.gs", outfile=NULL)
