# Jinliang Yang
# Jan 12th, 2015
# harvest the results of model training with gerp and random SNPs

harvestCV <- function(dir="slurm-scripts/", fileptn="\\.ghatREL", remove=FALSE){
  
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

########
SplitName <- function(infile=rand1){
  
  infile$file <- as.character(infile$file)
  infile$trait <- "A"
  infile$mode <- "a"
  infile$cv <- "cv"
  infile$sp <- "sp"
  for(i in 1:nrow(infile)){
    tem <- unlist(strsplit(infile$file[i], split="_"))
    infile$trait[i] <- tem[1]
    #infile$cs[i] <- tem[2]
    infile$mode[i] <- tem[2]
    infile$cv[i] <- tem[3]
    infile$sp[i] <- tem[4] 
  }
  return(infile)
}

#### extract with real data
main1 <- function(){
  res1 <- harvestCV(dir="slurm-scripts/exon/", fileptn="\\.ghatREL", remove=FALSE)
  res1 <- SplitName(infile=res1) #885
  print(table(res1$trait))
  
  write.table(res1, "cache/cv_exon_BPHmax.csv", sep=",", row.names=FALSE, quote=FALSE)
}

main1()

#### extract with real data
main2 <- function(){
  res1 <- harvestCV(dir="slurm-scripts/intron/", fileptn="\\.ghatREL", remove=FALSE)
  res1 <- SplitName(infile=res1) #885
  print(table(res1$trait))
  
  write.table(res1, "cache/cv_intron_pBPHmax.csv", sep=",", row.names=FALSE, quote=FALSE)
}

main2()
