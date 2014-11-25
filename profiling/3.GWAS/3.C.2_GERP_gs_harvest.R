# Jinliang Yang
# Nov 24th, 2014
# harvest the results of model training with gerp and random SNPs




gerp <- read.table("slurm-scripts/DTP_randsnp1_s6.ghatREL1", skip=1, header=FALSE)
fixeff <- read.table("slurm-scripts/DTP_randsnp1_s6.cgrRes1", skip=2, header=FALSE)
#names(gerp) <- c()

cor.test(gerp$V2+fixeff$V2, gerp$V3)



harvestTR <- function(dir="slurm-scripts/", fileptn="\\.ghatREL"){
  
  
  files <- list.files(path = dir, pattern=fileptn)
  ## file line of the shell file:
  
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
  return(resout)
  
}

####
res <- harvestTR(dir="slurm-scripts/", fileptn="\\.ghatREL")

res2 <- harvestTR(dir="slurm-scripts/", fileptn="^ASI.*\\.ghatREL")
res2
