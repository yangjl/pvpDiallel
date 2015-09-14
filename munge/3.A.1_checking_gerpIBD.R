### Jinliang Yang


library("data.table", lib="~/bin/Rlib/")

test_gerpibd <- function(base="largedata/SNP/gerpIBD_h_g1"){
  
  infile <- c(paste0(base, "_a2.gs"), paste0(base, "_d2.gs"), paste0(base, "_h2.gs"))
  
  for(i in 1:3){
    d <- as.data.frame(fread(infile[i]))
    message(sprintf("###>>> file: [ %s ], cols [ %s ]", infile[i], ncol(d)))
    tem <- range(d[, 2])
    message(sprintf("###>>> range of the SNP [ %s - %s ]", tem[1], tem[2] ) )
  }
  
  return(d)
}

d <- test_gerpibd(base="largedata/SNP/gerpIBD_h_g2")
m1d <- test_gerpibd(base="largedata/SNP/gerpIBD_h_b2_cs1")




m2d <- test_gerpibd(base="largedata/SNP/gerpIBDm2_h_b2_cs7")



