### Jinliang Yang
### 10/26/2016
### purpose: find GT of the given SNPs in hmp3

library("farmeR")
cmd <- c("cd /home/jolyang/dbcenter/HapMap/HapMap3")
for(i in 1:10){
  #ext <- paste0("pigz -d -p 16 merged_flt_c", i, ".vcf.gz")
  #bgzip <- paste0("bgzip merged_flt_c", i, ".vcf -@ 16")
  #idx <- paste0("tabix -p vcf merged_flt_c", i, ".vcf.gz")
  
  ## annotate VCF header becasue there is an error FORMAT=>INFO for AD
  b0 <- paste0("bcftools annotate -h change_AD.txt merged_flt_c", i, ".vcf.gz -Oz -o merged_flt_ad_c", i, ".vcf.gz")
  b1 <- paste0("bcftools view merged_flt_ad_c", i, ".vcf.gz ", 
               "-m2 -M2 -v snps -S bkn_pvp_samples.txt -Oz -o ", "chr", i, "_bisnp_n35.vcf.gz") 
  
  b2 <- paste0("bcftools query -S bkn_pvp_samples.txt",
                " -f '%CHROM\t%POS\t%REF\t%ALT[\t%TGT]\n'",
                " merged_flt_c", i, ".vcf.gz > chr", i, "_frq.txt")
  
  cmd <- c(b1, b2)
}

set_farm_job(slurmsh = "slurm-script/getbzip.sh",
             shcode = cmd, wd = NULL, jobid = "bzip",
             email = "yangjl0930@gmail.com", runinfo = c(TRUE, "bigmemm", 16))


# bcftools query -R pvp_sites_v3.bed -S bkn_samples.txt -f 
cmd <- paste("bcftools query -S bkn_samples.txt -f", 
             "'%CHROM\t%POS\t%REF\t%ALT[\t%TGT]\n' merged_flt_c10.vcf.gz > out.txt")


chr10 <- fread("~/dbcenter/HapMap/HapMap3/genotype_chr10.txt")











