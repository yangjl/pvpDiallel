# Jinliang Yang
# Jan 12th, 2015
# harvest the results of model training with gerp and random SNPs


harvestCV <- function(dir="slurm-scripts/", fileptn="\\.ghatREL1"){
  
  files <- list.files(path = dir, pattern=fileptn, full.names=TRUE)
  ## file line of the shell file:
  message(sprintf("[ %s ] files detected!", length(files)))

  res <- unlist(lapply(1:length(files), function(i){
    #genotype gHat DTP Fix  meanBias PEV=Var(g/y)   R^2 
    ghat <- read.table(files[i], skip=1, header=FALSE)
    if(i %% 10000 ==0) {
      # Print on the screen some message
      message(sprintf("###>>> finished reading [ %s ] files!", i))
    }
    return(cor(ghat$V2, ghat$V3))
  }))
  
  resout <- data.frame(file=files, r=res)
  
  return(resout)
}

########
SplitName <- function(infile=resout){
  
  infile$file <- as.character(infile$file)
  infile$file <- gsub(".*/", "", infile$file)
  
  infile$trait <- gsub("_.*", "", infile$file)
  infile$cs <- paste0("cs", gsub(".*_cs|_.*", "", infile$file))
  infile$mode <- gsub("_cv.*", "", infile$file) 
  infile$mode <- gsub(".*_", "", infile$mode)
  infile$cv <- paste0("cv", gsub(".*_cv|_.*", "", infile$file))
  infile$sp <- paste0("sp", gsub(".*_sp|\\..*", "", infile$file))
  infile$rel <- gsub(".*\\.", "", infile$file)
  
  print(table(infile$trait))
  return(infile)
}

#### extract with real data
main <- function(){
  res1 <- harvestCV(dir="slurm-scripts/cv_b2/", fileptn="\\.ghatREL", remove=FALSE)
  res1 <- SplitName(infile=res1) #885
  print(table(res1$trait))
  
  rand1 <- subset(rand1, trait != "asi")
  rand1$trait <- tolower(rand1$trait)
  
  res1$type <- "real"
  rand1$type <- "random"
  allfile <- rbind(res1, rand1)
  
  write.table(allfile, "cache/gerpall_h_g2_perse_gy.csv", sep=",", row.names=FALSE, quote=FALSE)
}

main()
