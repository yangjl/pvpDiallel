### Jinliang Yang
### 1.5.2014
### purpose: run the gerpIBD program

7*4*11
traits <- tolower(c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW"))


###############
gerpfile <- list.files(path="largedata/newGERPv2/allgeno", pattern="gerpv2", full.names=TRUE)
inputdf <- data.frame(
  d="largedata/IBD/allsnps_11m_IBD.bed", 
  s="largedata/SNP/allsnps_newgerp2_50k.dsf7", #deine deleterious alleles
  g=gerpfile, 
  f="largedata/newGERPv2/allgeno/k5.txt",
  out=gsub(".csv", "", gerpfile),
  t="all"
)

library(farmeR)
run_gerpIBD(inputdf[11,], email="yangjl0930@gmail.com", runinfo = c(FALSE, "bigmemm", 2) )








run_GATK <- function(inputdf,
                     ref.fa="~/dbcenter/Ecoli/reference/Ecoli_k12_MG1655.fasta",
                     gatkpwd="$HOME/bin/GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar",
                     picardpwd="$HOME/bin/picard-tools-2.1.1/picard.jar",
                     minscore=5,
                     markDup=TRUE,
                     realignInDels=FALSE, indels.vcf="indels.vcf",
                     recalBases=FALSE, dbsnp.vcf="dbsnp.vcf",
                     ){
  
  ##### prepare parameters:
  fq <- inputdf
  ### determine memory based on partition
  runinfo <- get_runinfo(runinfo)
  
  #### create dir if not exist
  dir.create("slurm-script", showWarnings = FALSE)
  for(i in 1:nrow(fq)){
    
    shid <- paste0("slurm-script/run_gatk_", i, ".sh")
    ### header of the shell code
    cat("### GATK pipeline created by farmeR",
        paste("###", format(Sys.time(), "%a %b %d %X %Y")),
        paste(""),
        file=shid, sep="\n", append=FALSE)
    
    if(sum(names(fq) %in% "bam") > 0){
      inputbam <- fq$bam[i]
    }else{
      ### alignment and sorting using picard-tools
      inputbam <- set_bwa(fq, run, minscore, picardpwd, i, ref.fa, shid)
    }
    
    #### mark duplicates
    if(markDup) inputbam <- set_markDup(fq, picardpwd, inputbam, i, run, shid)
    
    ### Perform local realignment around indels
    if(realignInDels) inputbam <- set_realignInDels(fq, inputbam, i, indels.vcf, ref.fa, gatkpwd, run, shid)
    
    ### Recalibrate Bases
    if(recalBases) inputbam <- set_recalBases(fq, inputbam, i, indels.vcf, dbsnp.vcf, ref.fa, gatkpwd, run, shid)
    
    ### Variant Discovery using HaplotypeCaller
    vcaller(fq, inputbam, i, ref.fa, gatkpwd, run, shid)
  }
  
  shcode <- paste("module load java/1.8", "module load bwa/0.7.9a",
                  "sh slurm-script/run_gatk_$SLURM_ARRAY_TASK_ID.sh", sep="\n")
  set_array_job(shid="slurm-script/run_gatk_array.sh",
                shcode=shcode, arrayjobs=paste("1", nrow(inputdf), sep="-"),
                wd=NULL, jobid="gatk", email=email, runinfo=runinfo)
  #  sbatch -p bigmemh --mem 32784 --ntasks=4  slurm-script/run_gatk_array.sh
}





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
