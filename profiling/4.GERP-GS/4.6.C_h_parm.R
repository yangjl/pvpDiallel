### Jinliang Yang
### Sept 4th, 2015
### get degree of dominance


set_gblup <- function(out_pwd, out_gpar="gparameter.dat", out_snpe="output_snpeff_ce.snpe",
                      geno_path_pattern=c("largedata/SNP/", "genotype_h_chr"),
                      phenofile, trait_col, mapfile){ 
  
  genofiles <- list.files(path=geno_path_pattern[1], pattern=geno_path_pattern[2], full.names=TRUE)
  pheno <- read.table(phenofile, header=TRUE)
  
  out_gpar <- paste0(out_pwd, out_gpar)
  cat(
    "1000 #numer of iterations",
    "1.0 2.0 7.0 #starting values of Va, Vd and Ve",
    "1.0e-08 #tolerance level",
    paste(phenofile, "#phenotype file"),
    paste(trait_col, "#trait position in phenotype file"),
    "0 #number of fixed factors",
    "0 #positions of fixed factors in phenotype file",
    "0 #number of covariables",
    "0 #positions of covariables in phenotype file",
    paste(nrow(pheno), "#number of individuals genotyped"),
    "10 #number of chromosomes",
    file=out_gpar, append=FALSE, sep="\n")
  ### 10 chromosome stuff
  for(i in 1:length(genofiles)){
    geno <- fread(genofiles[i], header=TRUE)
    geno <- as.data.frame(geno)
    cat(paste(ncol(geno)-1, genofiles[i], "#genotype file for each chromosome"),
        file=out_gpar, append=TRUE, sep="\n"
    )
  }
  
  cat( 
    paste0(out_pwd, "output_greml_ce #output file for GREML"),
    paste0(out_pwd, "output_gblup_ce #output file for GBLUP"),
    paste("#def_Q", 1),
    paste("#use_ai_reml", 1),
    paste("#iter_ai_reml_start", 3),
    paste("#missing_phen_val", -999),
    paste("#map_file",  mapfile), #snpid chr position
    paste0("output_mrk_effect ", out_pwd, out_snpe),
    file=out_gpar, append=TRUE, sep="\n")
  message(sprintf("###>>> run this [ greml_ce %s > %s/%s ]", out_gpar, out_pwd, gsub("snpe", "log", out_snpe)))
}

##########
library("data.table", lib="~/bin/Rlib/")

trait <- read.table("largedata/pheno/wholeset/trait_mx.dat", header=TRUE)
perse_idx <- grep("perse", names(trait))
pmph_idx <- grep("pBPHmax", names(trait))
pmph_idx[1] <- grep("asi_pBPHmin", names(trait))
names(trait[pmph_idx])
#[1] "asi_pBPHmin" "dtp_pBPHmax" "dts_pBPHmax" "eht_pBPHmax" "gy_pBPHmax" 
#[6] "pht_pBPHmax" "tw_pBPHmax" 
for(i in pmph_idx){
  set_gblup(out_pwd="largedata/snpeff/",
            out_gpar= paste0("gp_", names(trait)[i], ".dat"), 
            out_snpe= paste0(names(trait)[i], "_snpeff_ce.snpe"),
            geno_path_pattern=c("largedata/SNP/", "genotype_h_chr"),
            phenofile="largedata/pheno/wholeset/trait_mx.dat", trait_col=i, 
            mapfile="largedata/SNP/genotype_h.map")
}

###>>> run this [ greml_ce largedata/snpeff/gp_CD.dat > largedata/snpeff//CD_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_KRN.dat > largedata/snpeff//KRN_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_AKW.dat > largedata/snpeff//AKW_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_CL.dat > largedata/snpeff//CL_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_CW.dat > largedata/snpeff//CW_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_KC.dat > largedata/snpeff//KC_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_TKW.dat > largedata/snpeff//TKW_logff_ce.log ]

trait <- read.table("largedata/pheno/wholeset/trait_mx.dat", header=TRUE)
bph_idx <- grep("_BPHmax", names(trait))
bph_idx[1] <- grep("asi_BPHmin", names(trait))
names(trait[bph_idx])
#[1] "asi_BPHmin" "dtp_BPHmax" "dts_BPHmax" "eht_BPHmax" "gy_BPHmax" 
#[6] "pht_BPHmax" "tw_BPHmax" 
for(i in bph_idx){
  set_gblup(out_pwd="largedata/snpeff/BPH/",
            out_gpar= paste0("gp_", names(trait)[i], ".dat"), 
            out_snpe= paste0(names(trait)[i], "_snpeff_ce.snpe"),
            geno_path_pattern=c("largedata/SNP/", "genotype_h_chr"),
            phenofile="largedata/pheno/wholeset/trait_mx.dat", trait_col=i, 
            mapfile="largedata/SNP/genotype_h.map")
}

###>>> run this [ greml_ce largedata/snpeff/BPH/gp_asi_BPHmin.dat > largedata/snpeff/BPH//asi_BPHmin_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/BPH/gp_dtp_BPHmax.dat > largedata/snpeff/BPH//dtp_BPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/BPH/gp_dts_BPHmax.dat > largedata/snpeff/BPH//dts_BPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/BPH/gp_eht_BPHmax.dat > largedata/snpeff/BPH//eht_BPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/BPH/gp_gy_BPHmax.dat > largedata/snpeff/BPH//gy_BPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/BPH/gp_pht_BPHmax.dat > largedata/snpeff/BPH//pht_BPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/BPH/gp_tw_BPHmax.dat > largedata/snpeff/BPH//tw_BPHmax_logff_ce.log ]

trait <- read.table("largedata/pheno/wholeset/trait_mx.dat", header=TRUE)
pbph_idx <- grep("_pBPH$", names(trait))
names(trait[pbph_idx])
#"asi_pBPH" "dtp_pBPH" "dts_pBPH" "eht_pBPH" "gy_pBPH"  "pht_pBPH" "tw_pBPH"
for(i in pbph_idx){
  set_gblup(out_pwd="largedata/snpeff/pBPH/",
            out_gpar= paste0("gp_", names(trait)[i], ".dat"), 
            out_snpe= paste0(names(trait)[i], "_snpeff_ce.snpe"),
            geno_path_pattern=c("largedata/SNP/", "genotype_h_chr"),
            phenofile="largedata/pheno/wholeset/trait_mx.dat", trait_col=i, 
            mapfile="largedata/SNP/genotype_h.map")
}

## not interesting!

trait <- read.table("largedata/pheno/wholeset/trait_mx.dat", header=TRUE)
bph_idx <- grep("_BPH$", names(trait))
names(trait[bph_idx])
#[1] "asi_BPH" "dtp_BPH" "dts_BPH" "eht_BPH" "gy_BPH"  "pht_BPH" "tw_BPH"
for(i in bph_idx){
  set_gblup(out_pwd="largedata/snpeff/BPH/",
            out_gpar= paste0("gp_", names(trait)[i], ".dat"), 
            out_snpe= paste0(names(trait)[i], "_snpeff_ce.snpe"),
            geno_path_pattern=c("largedata/SNP/", "genotype_h_chr"),
            phenofile="largedata/pheno/wholeset/trait_mx.dat", trait_col=i, 
            mapfile="largedata/SNP/genotype_h.map")
}