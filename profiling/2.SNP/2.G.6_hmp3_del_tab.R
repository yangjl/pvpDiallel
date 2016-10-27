### Jinliang Yang
### 10-27-2016

library(data.table)

##### ref and alt MUST be the two columns of the data
est_maf <- function(df){
  freq <- apply(df, 1, function(x){
    x <- as.character(x)
    myref <- x[1]
    myalt <- x[2]
    c0 <- sum(x == myref) - 1 #remove the ref column
    c1 <- sum(x == myalt) - 1 #remove the alt column
    
    return(round(min(c(c0, c1))/(c0 + c1), 4))
  })
  return(freq)
}
###### -------------
get_del_rate <- function(){
  
  for(chri in 1:10){
    ##--- read in the hmp3 GERPv3 data with major=> deleterious call
    gp <- fread(paste0("largedata/Alignment/hmp3_GERPv3_major_chr", chri, ".csv"), header=TRUE, data.table=FALSE)
    gp$snpid <- paste(gp$chr, gp$pos, sep="_")
    
    ##--- read in the genotype of maize and landrace
    geno <- fread(paste0("~/dbcenter/HapMap/HapMap3/chr", i, "_gt_n35.txt"), data.table=FALSE)
    ids <- read.table("~/dbcenter/HapMap/HapMap3/bkn_pvp_samples.txt")
    names(geno) <- c("chr", "pos", "ref", "alt", as.character(ids$V1))
    
    ##--- reformat the genotype call
    for(i in 5:ncol(geno)){
      geno[,i] <- gsub("/.*", "", geno[,i])
    }
    geno$snpid <- paste(geno$chr, geno$pos, sep="_")
    
    ##-- merge data
    pgeno <- merge(gp, geno, by="snpid")
    
    message(sprintf("###>>> processing chr [%s]: [%s] del != ref", chri, 
                    round(nrow(subset(pgeno, major != ref) )/nrow(pgeno), 3 )))
    
    
    pgeno[, 10:ncol(pgeno)][pgeno[, 10:ncol(pgeno)] == "."] <- "N"
    out <- data.frame()
    for(k in 10:ncol(pgeno)){
      dn <- nrow(subset(pgeno, pgeno[, k] != "N" & pgeno[,k] != major))
      tem <- data.frame(id=names(pgeno)[k], DN=dn, miss=sum(pgeno[,k] == "N"))
      out <- rbind(out, tem)
    }
    
    out$nmiss <- nrow(pgeno) - out$miss
    out$DR <- round(out$DN/out$nmiss, 4)
    
    pgeno$maf <- est_maf(pgeno[, 8:44])
  }
  
  
  
}










