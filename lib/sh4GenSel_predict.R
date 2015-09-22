# Jinliang Yang
# Purpose: control GenSel running
# date: July.10.2014
# location: server.9

GenSel_inp <- function(inp="CL_test.inp", pi=0.995, findscale ="no",
                       geno="/Users/yangjl/Documents/GWAS2_KRN/SNP/merged/geno_chr", 
                       pheno="/Users/yangjl/Documents/Heterosis_GWAS/pheno2011/reports/cd_GenSel_fullset.txt",
                       chainLength=1000, burnin=100, varGenotypic=1.4, varResidual=2){
  
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
        paste("FindScale", findscale),
        "modelSequence no",
        "isCategorical no",
        #"linkageMap AGPv2",
        "addMapInfoToMarkers no",
        "windowBV no",
        "",
        "// markerFileName",
        paste("markerFileName", geno, sep=" "), 
        "",
        "// phenotypeFileName",
        paste("phenotypeFileName", pheno, sep=" "),
        "",
        "// mapOrderFileName",
        #paste("mapOrderFileName", map, sep=" "),
        
        file=inp, sep="\n"
    )	
}

Predict_inp <- function(inp="",
                        geno="",
                        pheno="",
                        mrkRes=""){
  cat(paste("// gensel input file written", Sys.time(), sep=" "), 
      
      "analysisType Predict",
      "windowWidth 5",
      "// linkageMap AGPv2",
      "// addMapInfoToMarkers yes",
      
      "// markerFileName",
      paste("markerFileName", geno, sep=" "), 
      "",
      "// phenotypeFileName",
      paste("phenotypeFileName", pheno, sep=" "),
      "",
      "// mapOrderFileName",
      #paste("mapOrderFileName", map, sep=" "),
      "",
      "// markerSolFileName",
      paste("markerSolFileName", mrkRes, sep=" "),
      
      file=inp, sep="\n")
}