### Jinliang Yang
### GERP in cM/Mb

### server and local
ob <- load("cache/4.1.B_gerpbins.RData")

map <- read.csv("data/gam_p2g_traindata.csv")

##############################################
tab_p2g <- function(tab, map){
  source("lib/p2g.R")
  
  #Input file:  Three columns: 1.marker_name 2.chromosome (Integer) 
  #3. Physical position (Colname must be Physical);
  names(tab) <- c("marker_name", "binrs", "chrosomosome", "Physical")
  tab1 <- tab[, -2]
  tab1$Physical <- tab1$Physical*1000000
  res <- p2g(predict=tab1, train=map) 
  res <- merge(res, tab[, -3:-4], by.x="marker", by.y="marker_name")
  return(res)
}

res1m <- tab_p2g(tab=tab1m, map)

save(file="cache/cvsnp_p2g_TAV758.RData", list=c("map", "cvsnp"))

