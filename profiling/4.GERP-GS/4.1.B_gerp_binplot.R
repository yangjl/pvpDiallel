### Jinliang Yang
### chr plot of the avg RS in bins


tab <- rbind(tab1, tab2, tab3, tab4, tab5, tab6, tab7, tab8, tab9, tab10)

ChrPlot <- function(binsize=1000000, tab=tab1m){
  #### read chr length
  cl <- read.table("data/ZmB73_RefGen_v2.length", header=FALSE)
  names(cl) <- c("chrom", "BP")
  plot(c(0, max(cl$BP)/binsize), c(10,110), type="n", main="binsize = 1000bp", 
       xlab="Physical position (Kb)", ylab="", yaxt="n", bty="n")
  
  axis(side=2, tick =FALSE, las=1, at=c(105, 95, 85, 75, 65, 55, 45, 35, 25, 15), 
       labels=paste("Chr", 1:10, sep=""))
  
  ### core plot
  for (chri in 1:10){
    mytab <- subset(tab, chr == chri)
    points(mytab$pos, 105 - 10*(chri-1) + mytab$binrs*3000, pch=19, cex=0.4)
  }
  
  #### chromosome
  for (i in 1:10){
    lines(c(0, cl[i,]$BP/binsize),c(105-10*(i-1), 105-10*(i-1)), lwd=4, col="grey")
    #lines (c(centromere[i,]$Start,centromere[i,]$End),
    #       c(105-10*i, 105-10*i),lwd=5, col="tomato") 
  }  
}
###
ChrPlot(binsize=1000000, tab=tab1m)
#######################
ChrPlot1M <- function(binsize=1000000, tab=tab1m){
  #### read chr length
  cl <- read.table("data/ZmB73_RefGen_v2.length", header=FALSE)
  names(cl) <- c("chrom", "BP")
  plot(c(0, max(cl$BP)/binsize), c(10,110), type="n", main="binsize = 1000bp", 
       xlab="Physical position (Kb)", ylab="", yaxt="n", bty="n")

  axis(side=2, tick =FALSE, las=1, at=c(105, 95, 85, 75, 65, 55, 45, 35, 25, 15), 
       labels=paste("Chr", 1:10, sep=""))
  #### chromosome
  for (i in 1:10){
    lines(c(0, cl[i,]$BP/binsize),c(105-10*(i-1), 105-10*(i-1)), lwd=4, col="grey")
    #lines (c(centromere[i,]$Start,centromere[i,]$End),
    #       c(105-10*i, 105-10*i),lwd=5, col="tomato") 
  }
  ### core plot
  cols <- rep(c("slateblue", "cyan4"), 5)
  for (chri in 1:10){
    mytab <- subset(tab, chr == chri)
    points(mytab$pos, 105 - 10*(chri-1) + mytab$binrs/5, pch=19, cex=0.6, col=cols[chri])
  } 
}
###
ChrPlot1M(binsize=1000000, tab=tab1m)