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
  
  outall <- data.frame()
  for(chri in 1:10){
    ##--- read in the hmp3 GERPv3 data with major=> deleterious call
    gp <- fread(paste0("largedata/Alignment/hmp3_GERPv3_major_chr", chri, ".csv"), header=TRUE, data.table=FALSE)
    #gp$snpid <- paste(gp$chr, gp$pos, sep="_")
    
    ##--- read in the genotype of maize and landrace
    geno <- fread(paste0("~/dbcenter/HapMap/HapMap3/chr", chri, "_gt_n35.txt"), data.table=FALSE)
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
    
    ##-- compute overall load
    pgeno[, 10:ncol(pgeno)][pgeno[, 10:ncol(pgeno)] == "."] <- "N"
    out1 <- data.frame()
    for(k in 10:ncol(pgeno)){
      dn <- nrow(subset(pgeno, pgeno[, k] != "N" & pgeno[,k] != major))
      tem <- data.frame(id=names(pgeno)[k], DN=dn, nonmiss= nrow(pgeno) - sum(pgeno[,k] == "N"), chr=chri)
      out1 <- rbind(out1, tem)
    }
    out1$type <- "overall"
    
    ##--- Fixed and segregating load for landrace
    idx1 <- which(names(pgeno) == "BKN040")
    pgeno$maf <- est_maf(pgeno[, 8:idx1])
    subpg <- subset(pgeno, maf > 0)
    out2 <- data.frame()
    for(k in 10:idx1){
      dn <- nrow(subset(subpg, subpg[, k] != "N" & subpg[,k] != major))
      tem <- data.frame(id=names(subpg)[k], DN=dn, nonmiss= nrow(pgeno) - sum(pgeno[,k] == "N"), chr=chri)
      out2 <- rbind(out2, tem)
    }
    out2$type <- "seg"
    
    subpg <- subset(pgeno, maf == 0)
    out3 <- data.frame()
    for(k in 10:idx1){
      dn <- nrow(subset(subpg, subpg[, k] != "N" & subpg[,k] != major))
      tem <- data.frame(id=names(subpg)[k], DN=dn, nonmiss= nrow(pgeno) - sum(pgeno[,k] == "N"), chr=chri)
      out3 <- rbind(out3, tem)
    }
    out3$type <- "fixed"
    
    ##--- Fixed and segregating load for maize
    pgeno$maf <- est_maf(pgeno[, c(8, 9, (idx1+1):44)])
    subpg <- subset(pgeno, maf > 0)
    out4 <- data.frame()
    for(k in (idx1+1):44){
      dn <- nrow(subset(subpg, subpg[, k] != "N" & subpg[,k] != major))
      tem <- data.frame(id=names(subpg)[k], DN=dn, nonmiss= nrow(pgeno) - sum(pgeno[,k] == "N"), chr=chri)
      out4 <- rbind(out4, tem)
    }
    out4$type <- "seg"
    ##--- Fixed and segregating load for maize
    pgeno$maf <- est_maf(pgeno[, c(8, 9, (idx1+1):44)])
    subpg <- subset(pgeno, maf == 0)
    out5 <- data.frame()
    for(k in (idx1+1):44){
      dn <- nrow(subset(subpg, subpg[, k] != "N" & subpg[,k] != major))
      tem <- data.frame(id=names(subpg)[k], DN=dn, nonmiss= nrow(pgeno) - sum(pgeno[,k] == "N"), chr=chri)
      out5 <- rbind(out5, tem)
    }
    out5$type <- "fixed"
    
    outall <- rbind(outall, out1, out2, out3, out4, out5)
  }
  outall$DR <- round(outall$DN/outall$nonmiss, 4)
  return(outall)
}


###################
res <- get_del_rate()

write.table(res, "cache/hmp3_deleterious_ratio.csv", sep=",", row.names=FALSE, quote=FALSE)



res <- read.csv("cache/hmp3_deleterious_ratio.csv")
res$chr <- as.factor(res$chr)
res$geno <- "maize"
idx <- grep("BKN", res$id)
res[idx,]$geno <- "landrace"


res <- subset(res, id != "B73")
boxplot(DR ~ geno*type, data=res, notch=FALSE, 
        col=(c("gold","darkgreen")), names=c("landrace", "maize", "landrace", "maize", "landrace", "maize"),
        main="", xlab="", ylab="Deleterious Load per bp")





library("ggplot2")
fsize=16
ggplot(res, aes(x=chr, y=DR, fill=chr)) +
  facet_grid(.~geno) + 
  geom_boxplot() +
  guides(fill=FALSE) +
  theme_bw() + 
  theme(axis.text.x=element_blank(), 
        axis.ticks.x=element_blank(),
        axis.text=element_text(size=fsize), 
        axis.title=element_text(size=fsize, face="bold"), 
        legend.title = element_text(size=fsize, face="bold"), 
        legend.text = element_text(size=fsize)) +
  xlab("") + ylab("Deleterious sites / total sites (%)")