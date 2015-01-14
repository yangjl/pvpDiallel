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
  infile$cs <- "cs"
  infile$mode <- "a"
  infile$cv <- "cv"
  infile$sp <- "sp"
  for(i in 1:nrow(infile)){
    tem <- unlist(strsplit(infile$file[i], split="_"))
    infile$trait[i] <- tem[1]
    infile$cs[i] <- tem[2]
    infile$mode[i] <- tem[3]
    infile$cv[i] <- tem[4]
    infile$sp[i] <- tem[5] 
  }
  return(infile)
}



#### extract with real data
writeCV <- function(){
  res1 <- harvestCV(dir="slurm-scripts/", fileptn="*_real_.*\\.ghatREL", remove=FALSE)
  res1 <- SplitName(infile=res1) #885
  print(table(res1$trait))
  
  ### extract with re-sampled data
  rand1 <- harvestCV(dir="slurm-scripts/", fileptn="*_cs.*\\.ghatREL", remove=FALSE)
  rand1 <- SplitName(infile=rand1)
  table(rand1$trait) #each trait should be 2000 data points
  rand1 <- subset(rand1, trait != "asi")
  rand1$trait <- tolower(rand1$trait)
  
  res1$type <- "real"
  rand1$type <- "random"
  allfile <- rbind(res1, rand1)
  
  write.table(allfile, "cache/cv_results.csv", sep=",", row.names=FALSE, quote=FALSE)
}



nrow(subset(rand1, trait=="ASI" & mode=="a2"))
mean(subset(rand1, trait=="tw" & mode=="a2")$r)
#0.28

t.test(subset(rand1, trait=="ASI" & mode=="d2")$r, subset(res1, trait == "asi" & mode=="d2")$r)


t.test(subset(rand1, trait=="pht" & mode=="d1")$r, subset(res1, trait == "pht" & mode=="d1")$r)



