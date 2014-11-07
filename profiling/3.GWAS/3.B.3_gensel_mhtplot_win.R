# Jinliang Yang
# updated: 7/14/2014
# Purpose: quick plot of GWAS results

###########################
samWINplot <- function(trait=traits[1]){

  #### pai=0.995
  infile <- paste("largedata/GenSel/realrun/", trait, "_realrun.winQTL1", sep="")
  bayes1 <- read.table(infile, header=FALSE, skip=1)
  names(bayes1) <- c("window", "start", "end", "nosnps", "var", "cumvar", "p", "pavg",
                     "mappos0", "mapposn", "chr_Mb")
  bayes1$chr <- gsub("_.*", "", bayes1$chr_Mb)
  bayes1$pos <- as.numeric(as.character(gsub(".*_", "", bayes1$chr_Mb)))*1000000
  
  #### plot
  source("lib/quickMHTplot.R")
  pdf(paste("largedata/lgraphs/", trait, "_winqtl.pdf", sep=""), width=10, height=4)
  quickMHTplot(res=bayes1, main=trait, cex=.6, pch=19, 
               col=rep(c("slateblue", "cyan4"), 5), 
               GAP=5e+06, ylab="model frequency", yaxis=NULL,
               col2plot="var")
  dev.off()
  return(bayes1)
}



#########################
traits <- c("asi", "dtp", "dts", "eht", "gy", "pht", "tw")

win1 <- samWINplot(trait=traits[1])  
win2 <- samWINplot(trait=traits[2])  
win3 <- samWINplot(trait=traits[3])  
win4 <- samWINplot(trait=traits[4])  
win5 <- samWINplot(trait=traits[5])  
win6 <- samWINplot(trait=traits[6])  
win7 <- samWINplot(trait=traits[7])  




