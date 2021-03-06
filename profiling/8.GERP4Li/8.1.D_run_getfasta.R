### AGPv2 -> AGPv3 conversion
### http://plants.ensembl.org/Oryza_sativa/Tools/AssemblyConverter?db=core
library(maizeR)
set_farm_job(slurmsh = "slurm-scripts/run_getfa.sh",
             shcode = "R --no-save  < profiling/8.GERP4Li/8.1.C_getfasta_gerpv3.R", 
             wd = NULL, jobid = "getfa",
             email = "yangjl0930@gmail.com")
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> RUN: sbatch -p bigmemh --mem 240000 --ntasks=30 slurm-scripts/run_getfa.sh


library(maizeR)
for(i in 1:10){
  shid <- paste0("slurm-scripts/run_bed_chr", i, ".sh")
  #bedtools getfasta -name -tab -fi roast.chrom.10.msa.in -bed AGPv3_chr10.bed -fo AGPv3_chr10_gerpsnp.txt
  command <- paste0("cd largedata/Alignment/", "\n", 
                    "sed -i 's/\\s\\+/\\t/g' AGPv3_chr", i, ".bed", "\n",
                    "bedtools getfasta -name -tab -fi roast.chrom.", i, ".msa.in",
                    " -bed AGPv3_chr", i, ".bed -fo AGPv3_chr", i, "_gerpsnp.txt")
  cat(command, file=shid, sep="\n", append=FALSE)
}
shcode <- "sh slurm-scripts/run_bed_chr$SLURM_ARRAY_TASK_ID.sh"

set_array_job(shid = "slurm-scripts/run_bed_chr.sh",
              shcode = shcode, arrayjobs = "1-10", wd = NULL,
              jobid = "runbedtools", email = "yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> RUN: sbatch -p med slurm-scripts/run_bed_chr.sh

#bedtools getfasta -name -tab -fi roast.chrom.4.msa.in -bed chr4.bed -fo chr4_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.5.msa.in -bed chr5.bed -fo chr5_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.6.msa.in -bed chr6.bed -fo chr6_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.7.msa.in -bed chr7.bed -fo chr7_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.8.msa.in -bed chr8.bed -fo chr8_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.9.msa.in -bed chr9.bed -fo chr9_gerpsnp.txt
#bedtools getfasta -name -tab -fi roast.chrom.10.msa.in -bed AGPv3_chr0.bed -fo AGPv3_chr0_gerpsnp.txt

library(maizeR)
cwd <- paste("cd largedata/Alignment",
             "gerpinfo -i AGPv3_chr10_gerpsnp.txt -s 3 -m - -o AGPv3_GERP_chr10.txt", 
             sep="\n")
set_farm_job(slurmsh = "slurm-scripts/run_gerpinfo.sh",
             shcode = cwd, wd = NULL, jobid = "gerp",
             email = "yangjl0930@gmail.com")
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> RUN: sbatch -p bigmemh slurm-scripts/run_gerpinfo.sh
