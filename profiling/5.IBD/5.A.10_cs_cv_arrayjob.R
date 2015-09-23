### Jinliang Yang
### Jan. 9th, 2014

source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
source("lib/slurm4gerpIBDCV.R")


cv150_mode_cv_sp <- function(inp_path="slurm-scripts/g2", genobase, myti, csi){
  ## myi: i of the trait
  
  ### prior information
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  shcommand <- c()
  for(mode in c("a2", "d2", "h2")){
    for(cv in 1:5){
      
      ### the first one use gs
      sp <- 1
      myinp <- paste0(inp_path, "/", ti[myti], "_cs", csi, "_", mode,"_cv",cv, "_sp",sp, ".inp")
      GS_cv_inp(
        inp= myinp, pi=0.995,
        # largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_", traits[j]
        geno= paste0(wd, "/", genobase, csi, "_", mode, ".gs"), 
        trainpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[myti], "_train", cv, "_sp", sp, ".txt"),
        testpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[myti], "_test", cv, "_sp", sp, ".txt"),
        chainLength=11000, burnin=1000, varGenotypic=gen[myti], varResidual=res[myti]
      )
      shcommand <- c(shcommand, paste("GenSel4R", myinp))
      
      #### using newbin
      for(sp in 2:10){
        myinp <- paste0(inp_path, "/", ti[myti], "_cs", csi, "_", mode,"_cv",cv, "_sp",sp, ".inp")
        GS_cv_inp(
          inp= myinp, pi=0.995,
          # largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_", traits[j]
          geno= paste0(wd, "/", genobase, csi, "_", mode, ".gs.newbin"), 
          trainpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[myti], "_train", cv, "_sp", sp, ".txt"),
          testpheno= paste0(wd, "/largedata/pheno/CV5fold/", ti[myti], "_test", cv, "_sp", sp, ".txt"),
          chainLength=11000, burnin=1000, varGenotypic=gen[myti], varResidual=res[myti]
        )
        shcommand <- c(shcommand, paste("GenSel4R", myinp))
      }
    }
  }
  return(shcommand)
}

cv_array <- function(outdir="slurm-scripts/cv_b0/", jobbase="run_cv_job", totcs=100){
  jobs <- 0
  traits <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  dir.create(outdir, showWarnings = FALSE)
  for(j in 1:7){
    ### the number of cs
    for(i in 1:totcs){
      ### array job ID
      jobs <- jobs+1
      shid <- paste0(outdir, "/", jobbase, jobs, ".sh")
      ### gerpIBD command goes into the sh
      sh1 <- paste0("gerpIBD -d largedata/IBD/allsnps_11m_IBD.bed -s largedata/SNP/allsnps_11m.dsf5 ",
                    "-g largedata/SNP/geno_b0_cs/gerpv2_b0_cs", i, ".csv -f largedata/snpeff/", traits[j], "_k.txt ",
                    "-o largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_", traits[j],
                    " -t k")
      #rm2 <- c("rm largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_*b*")
      ### farm job id
      sh2 <- cv150_mode_cv_sp(inp_path=outdir, genobase="largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", myti=j, csi=i)
      #message(sprintf("###>>> "))
      sh3 <- c(paste0("#rm largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_", traits[j],"*gs"),
               paste0("#rm largedata/SNP/geno_b0_cs/gerpIBD_b0_cs", i, "_", traits[j],"*gs.newbin"))
      
      sh4 <- c(paste0("rm ", outdir, "/", traits[j], "_cs", i, "*.mcmcSamples*"),
               paste0("rm ", outdir, "/", traits[j], "_cs", i, "*.mrkRes*"))
      
      cat(c(sh1, sh2[1], sh3[1], sh2), file=shid, sep="\n", append=FALSE)
    }
  }
  message("###>>> codes preparation done! Need to setup slurm arrayjob using [set_arryjob.R]")
}

### setup codes
cv_array(outdir="slurm-scripts/cv_b0/", jobbase="run_cv_job", totcs=2)
###submit an array job
set_arrayjob(shid="slurm-scripts/cv_b0/run_arrayjob_test.sh",
             shcode="sh slurm-scripts/cv_b0/run_cv_job$SLURM_ARRAY_TASK_ID.sh",
             arrayjobs="1-2",
             wd=NULL, jobid="test", email=NULL)

