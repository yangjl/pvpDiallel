# Jinliang Yang
# updated: 7/14/2014
# Purpose: quick plot of GWAS results

getBayes <- function(inputfile="/home/NSF-SAM-GS/GenSel/SAM_run41000.mrkRes1", mfcutoff=0){
  
  tab5rows <- read.table(inputfile, header=TRUE, nrows=5)
  classes <- sapply(tab5rows, class)
  res <- read.table(inputfile, header=TRUE, colClasses=classes)
  message(sprintf("###>>> input [ %s ]", nrow(res)))
  
  res$chr <- gsub("_.*", "", res$snpid)
  res$chr <- as.numeric(as.character(sub("chr", "", res$chr)))
  res <- subset(res, !is.na(chr))
  res$pos <- as.numeric(as.character(gsub(".*_", "", res$snpid)))
  res <- subset(res, ModelFreq > mfcutoff)
  message(sprintf("remove unknow chr and >mfcutff, remainning [ %s ]", nrow(res)))
  return(res)
}


source("lib/quickMHTplot.R")

###### mrkRes
getplot <- function(trait="akw"){
  #### pai=0.995
  bayes <- getBayes(paste("largedata/GenSel/realrun/", trait, "_realrun.mrkRes1", sep=""), mfcutoff=0)
  #bayes1s <- subset(bayes1, ModelFreq > 0.005)
  pdf(paste("largedata/lgraphs/", trait, "_gs_100mrun.pdf", sep=""), width=10, height=4)
  quickMHTplot(res=bayes, main=paste(toupper(trait), " pai=0.99999, chain length=101000"), cex=.9, pch=16, 
               col=rep(c("slateblue", "cyan4"), 5), 
               GAP=5e+06, ylab="model frequency", yaxis=NULL,
               col2plot="ModelFreq")
  dev.off()
  return(bayes)
}


##### window
#########################
traits <- c("asi", "dtp", "dts", "eht", "gy", "pht", "tw")

bayes1 <- getplot(trait=traits[1])  
bayes2 <- getplot(trait=traits[2])  
bayes3 <- getplot(trait=traits[3])  
bayes4 <- getplot(trait=traits[4])  
bayes5 <- getplot(trait=traits[5])  
bayes6 <- getplot(trait=traits[6])  
bayes7 <- getplot(trait=traits[7])  

save(file="cache/train101m.RData", list=c("bayes1", "bayes2", "bayes3", "bayes4", "bayes5", "bayes6", "bayes7"))





