# Jinliang Yang
# Nov 24th, 2014
# harvest the results of model training with gerp and random SNPs




gerp <- read.table("slurm-scripts/DTP_randsnp1_s6.ghatREL1", skip=1, header=FALSE)
fixeff <- read.table("slurm-scripts/DTP_randsnp1_s6.cgrRes1", skip=2, header=FALSE)
#names(gerp) <- c()

cor.test(gerp$V2+fixeff$V2, gerp$V3)



harvestTR <- function(dir="slurm-scripts/", fileptn="\\.ghatREL", remove=FALSE){
  
  files <- list.files(path = dir, pattern=fileptn)
  ## file line of the shell file:
  message(sprintf("[ %s ] files detected!", length(files)))
  
  resout <- data.frame()
  for(i in 1:length(files)){
    myfile <- paste(dir, files[i], sep="")
    #genotype gHat DTP Fix  meanBias PEV=Var(g/y)   R^2 
    ghat <- read.table(myfile, skip=1, header=FALSE)
    temp <- cor.test(ghat$V2, ghat$V3)
    r2 <- (temp$estimate)^2
    temout <- data.frame(file=files[i], R2=r2, r=temp$estimate)
    resout <- rbind(resout, temout)
  }
  
  ### remove all the files
  if(remove == TRUE){
    system(paste("cd", dir, "|", "rm", fileptn))
  }
  
  return(resout)
  
}

#### DTP all the SNPs
res1 <- harvestTR(dir="slurm-scripts/", fileptn="^DTP.*\\.ghatREL", remove=TRUE)
res1$trait <- gsub("_.*", "", res1$file)
res1$snpset <- gsub("DTP_", "", res1$file)
res1$snpset <- gsub("_.*", "", res1$snpset)

write.table(res1, "largedata/lcache/DTP_trainres.csv", sep=",", row.names=FALSE, quote=FALSE)

#### DTP 29k 
res1.2 <- harvestTR(dir="slurm-scripts/", fileptn="^DTP.*29k.*\\.ghatREL", remove=FALSE)
res1.2
t.test(res1.2$r[1:12], res1.2$r[-1:-12])
write.table(res1.2, "largedata/lcache/DTP_29kres.csv", sep=",", row.names=FALSE, quote=FALSE)

#### DTP sm4
res1.3 <- harvestTR(dir="slurm-scripts/", fileptn="^DTP.*sm4.*\\.ghatREL", remove=FALSE)
res1.3
t.test(res1.3$r[1:12], res1.3$r[-1:-12])
write.table(res1.3, "largedata/lcache/DTP_sm4kres.csv", sep=",", row.names=FALSE, quote=FALSE)




#### ASI 29k 
res2 <- harvestTR(dir="slurm-scripts/", fileptn="^ASI.*29k.*\\.ghatREL", remove=FALSE)
res2
t.test(res2$r[1:12], res2$r[-1:-12])
write.table(res2, "largedata/lcache/ASI_29kres.csv", sep=",", row.names=FALSE, quote=FALSE)

#### ASI sm4
res3 <- harvestTR(dir="slurm-scripts/", fileptn="^ASI.*sm4.*\\.ghatREL")
res3
t.test(res3$r[1:12], res3$r[-1:-12])
write.table(res3, "largedata/lcache/ASI_sm4.csv", sep=",", row.names=FALSE, quote=FALSE)


