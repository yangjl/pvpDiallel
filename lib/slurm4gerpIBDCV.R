# Jinliang Yang
# Purpose: slurm script for GenSel running
# date: Nov.2nd.2014
# location: farm, for cross-validation


slurm4GenSelCV <- function(
  shfile="slurm.sh", shcommand = "sh run.sh",
  sbathJ="jobid",  
  sbatho="/home/jolyang/Documents/pvpDiallel/slurm-log/testout-%j.txt",
  sbathe="/home/jolyang/Documents/pvpDiallel/slurm-log/error-%j.txt"                       
  ){
 
  
    #####
    wd <- getwd()
    #### parameters pass to slurm script
    cat(paste("#!/bin/bash"),
        #-D sets your project directory.
        #-o sets where standard output (of your batch script) goes.
        #-e sets where standard error (of your batch script) goes.
        #-J sets the job name.
        paste("#SBATCH -D", wd, sep=" "),
        paste("#SBATCH -o", sbatho, sep=" "),
        paste("#SBATCH -e", sbathe, sep=" "),
        paste("#SBATCH -J", sbathJ, sep=" "),
        "set -e",
        "set -u",
        "",
        file=shfile, sep="\n", append=FALSE);
    
    #### attach some sh scripts
    
    cat(shcommand,
        file=shfile, sep="\n", append=TRUE);
    
    if(length(shcommand) > 1){
      cat("",
          paste("python /home/jolyang/bin/send_email.py -s", shcommand[length(shcommand)]),
          file=shfile, sep="\n", append=TRUE);
    }else{
      cat("",
          paste("python /home/jolyang/bin/send_email.py -s", shcommand),
          file=shfile, sep="\n", append=TRUE);
    }
    
    
    message(paste("###>>> In this path: cd ", wd, sep=""), "\n",
            paste("###>>> note --ntask=x, 8GB of memory per CPU"), "\n",
            paste("###>>> RUN: sbatch -p bigmemm --ntask=2 --mem 16000", shfile),
            "")
  
}

############################
GS_cv_inp <- function(
  inp="CL_test.inp", pi=0.995,
  geno="/Users/yangjl/Documents/GWAS2_KRN/SNP/merged/geno_chr.newbin", 
  trainpheno="/Users/yangjl/Documents/Heterosis_GWAS/pheno2011/reports/cd_GenSel_fullset.txt",
  testpheno="/Users/yangjl/Documents/Heterosis_GWAS/pheno2011/reports/cd_GenSel_fullset.txt",
  chainLength=1000, burnin=100, varGenotypic=1.4, varResidual=2
  ){
  
    cat(paste("// gensel input file written", Sys.time(), sep=" "), 
        
        "analysisType Bayes",
        "bayesType BayesC",
        paste("chainLength", chainLength, sep=" "),
        paste("burnin", burnin=burnin, sep=" "),
        paste("probFixed", pi, sep=" "),
        
        paste("varGenotypic",  varGenotypic, sep=" "),
        paste("varResidual",  varResidual, sep=" "),
        "nuRes 10",
        "degreesFreedomEffectVar 4",
        "outputFreq 100",
        "seed 1234",
        "mcmcSamples yes",
        "plotPosteriors no",
        "FindScale no",
        "modelSequence no",
        "isCategorical no",
 
        "",
        "// markerFileName",
        paste("markerFileName", geno, sep=" "), 
        "",
        "// train phenotypeFileName",
        paste("trainPhenotypeFileName", trainpheno, sep=" "),
        "",
        "// test phenotypeFileName",
        paste("testPhenotypeFileName", testpheno, sep=" "),
        
        #"// includeFileName",
        #paste("includeFileName", inmarker, sep=" "),
        
        file=inp, sep="\n"
    )	
}
