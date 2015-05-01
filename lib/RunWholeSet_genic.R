source("lib/slurm4GenSel.R")

### step 1: generate inp file for GenSel4B
RunWholeSet_genic <- function(inppwd="slurm-scripts/gerpfeature/", priors=gs2){
  #### Generate inp and return "GenSel4B inps"
  
  shcommand <- c()
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  #res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  #gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  traits <- c("perse", "BPHmax", "BPHmin", "pBPHmax", "pBPHmin", "MPH", "pMPH")
  
  
  #### g=1, only gerp gene
  g=1
  gerpf <- c("gerp_gene_b0_", "gerp_gene_s0_", "gerp_exon_b0_", 
             "gerp_exon_s0_", "gerp_intron_b0_", "gerp_intron_s0_")
  
  for(i in 1:7){
    for(modei in c("a2", "d2")){
      for(j in 1:5){
        myinp <- paste0(inppwd, ti[i], "_", traits[j],  "_", g, modei, ".inp")
        
        mygeno  <- paste0(wd, "/largedata/SNP/", gerpf[g], modei, ".gs.newbin")
        if(!file.exists(mygeno)){
          mygeno <- paste0(wd, "/largedata/SNP/", gerpf[g], modei, ".gs")
        }
        
        
        mypheno <- paste0(wd, "/largedata/pheno/wholeset/", tolower(ti[i]), "_", traits[j], ".txt")
        
        ######### core set ###########
        GenSel_inp(
          inp= myinp, pi=0.999,
          findsale ="no", geno=mygeno, 
          pheno=mypheno,
          chainLength=41000, burnin=1000, 
          varGenotypic = subset(priors, trait == ti[i] & mode == modei & transf == traits[j])$genvar, 
          varResidual = subset(priors, trait == ti[i] & mode == modei & transf == traits[j])$resvar
        )
        shcommand <- c(shcommand, paste("GenSel4R", myinp))
        
      }
    }
  }
  return(shcommand)
}

