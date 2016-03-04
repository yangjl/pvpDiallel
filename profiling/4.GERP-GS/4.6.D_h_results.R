### Jinliang Yang
### 09/08/2015

num_eff <- function(files){
  
  output <- data.frame()
  for(i in 1:length(files)){
    h1 <- read.table(files[i], header=TRUE)
    names(h1) <- c("snpid","chr","pos","Effect_A","Effect_D","Effect_A2","Effect_D2","h2_mrk_A", 
                   "h2_mrk_D","H2_mrk","h2_mrk_A_p","h2_mrk_D_p","H2_mrk_p","log10_h2_mrk_A","log10_h2_mrk_D","log10_H2_mrk")
    
    h1$k <- h1$Effect_D/h1$Effect_A
    
    tem <- h1$k
    
    out <- data.frame(file=files[i], 
                      k1=length(tem[tem > 1]),
                      k2=length(tem[tem > 0 & tem <= 1]), 
                      k3=length(tem[tem >= -1 & tem < 0]), 
                      k4=length(tem[tem < -1]),
                      h2_A=sum(h1$h2_mrk_A),
                      h2_D=sum(h1$h2_mrk_D))
    
    output <- rbind(output, out)
    
    message(sprintf("###>>> processing file: [ %s ]", files[i]))
  }
  return(output)
}


files <- list.files(path="largedata/snpeff", pattern="snpe$", full.names=TRUE)
num_eff(files)

##########################################
getk <- function(files, outpwd="largedata/snpeff"){
  output <- data.frame()
  for(i in 1:length(files)){
    h1 <- read.table(files[i], header=TRUE)
    names(h1) <- c("snpid","chr","pos","Effect_A","Effect_D","Effect_A2","Effect_D2","h2_mrk_A", 
                   "h2_mrk_D","H2_mrk","h2_mrk_A_p","h2_mrk_D_p","H2_mrk_p","log10_h2_mrk_A","log10_h2_mrk_D","log10_H2_mrk")
    #h1 <- subset(h1, Effect_A !=0)
    h1 <- subset(h1, H2_mrk > 1e-7 & Effect_A !=0)
    
    trait <- gsub(".*/|_.*", "", files[i])
    h1$k <- h1$Effect_D/h1$Effect_A
    
    out <- h1[, c("snpid", "k")]

    if(sum(out$k > 1) > 0){
      if(sum(out$k > 2) > 0){
        out[out$k > 2, ]$k <- 2
      }
      #out[out$k > 1, ]$k <- rescale(out[out$k > 1, ]$k, c(1, 2))
    }
    if(sum(out$k < -1) > 0){
      if(sum(out$k < -2) > 0){
        out[out$k < -2, ]$k <- -2
      }
      #out[out$k < -1, ]$k <- rescale(out[out$k < -1, ]$k, c(-2, -1))
    }
    names(out)[2] <- "h"
    message(sprintf("###>>> trait [ %s ], snp # [ %s ], k ranged [ %s - %s ]", trait, nrow(out), max(out$h), min(out$h)))
    write.table(out, paste0(outpwd, "/", trait, "_k.txt"), sep="\t", row.names=FALSE, quote=FALSE)
  }
}
##############
source("~/Documents/Github/zmSNPtools/Rcodes/rescale.R")
files1 <- list.files(path="largedata/snpeff/perse", pattern="snpe$", full.names=TRUE)
getk(file1, outpwd="largedata/snpeff/perse")

file2 <- list.files(path="largedata/snpeff/BPH", pattern="snpe$", full.names=TRUE)
getk(file2, outpwd="largedata/snpeff/BPH")

