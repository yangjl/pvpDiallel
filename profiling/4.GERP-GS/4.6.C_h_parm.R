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
            phenofile="largedata/pheno/wholeset/trait_mx.dat", trait_col=35, 
            mapfile="largedata/SNP/genotype_h.map")
}

###>>> run this [ greml_ce largedata/snpeff/gp_asi_perse.dat > largedata/snpeff//asi_perse_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_dtp_perse.dat > largedata/snpeff//dtp_perse_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_dts_perse.dat > largedata/snpeff//dts_perse_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_eht_perse.dat > largedata/snpeff//eht_perse_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_gy_perse.dat > largedata/snpeff//gy_perse_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_pht_perse.dat > largedata/snpeff//pht_perse_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_tw_perse.dat > largedata/snpeff//tw_perse_logff_ce.log ]

###>>> run this [ greml_ce largedata/snpeff/gp_asi_pBPHmin.dat > largedata/snpeff//asi_pBPHmin_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_dtp_pBPHmax.dat > largedata/snpeff//dtp_pBPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_dts_pBPHmax.dat > largedata/snpeff//dts_pBPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_eht_pBPHmax.dat > largedata/snpeff//eht_pBPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_gy_pBPHmax.dat > largedata/snpeff//gy_pBPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_pht_pBPHmax.dat > largedata/snpeff//pht_pBPHmax_logff_ce.log ]
###>>> run this [ greml_ce largedata/snpeff/gp_tw_pBPHmax.dat > largedata/snpeff//tw_pBPHmax_logff_ce.log ]
