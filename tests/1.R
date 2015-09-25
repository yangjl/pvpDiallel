# Example Unit Testing Script

res0 <- read.csv("cache/g2_k_perse.csv")

myt <- c("tw", "dtp", "dts", "pht", "eht", "asi", "gy")
runttest <- function(res0, mymode="h2", mytrait=myt[7]){
  
  res0$R2 <- res0$r^2
  real <- subset(res0, cs == "cs0" & trait== mytrait & mode == mymode)
  real <- subset(real, r > 0.3)
  rand <- subset(res0, cs != "cs0" & trait == mytrait & mode == mymode)
  
  real$sp <- as.character(real$sp)
  sps <- unique(real$sp)
  out1 <- data.frame()
  for(i in 1:length(sps)){
    tem <- data.frame(sp=sps[i], R2= mean(subset(real, sp==sps[i])$R2), r=mean(subset(real, sp==sps[i])$r))
    out1 <- rbind(out1, tem)
  }
  
  rand$sp <- as.character(rand$sp)
  sps2 <- unique(rand$sp)
  cs <- as.character(rand$cs)
  css <- unique(rand$cs)
  out2 <- data.frame()
  for(i in 1:length(css)){
    sub <- subset(rand, cs==css[i])
    for(j in 1:length(sps)){
      tem <- data.frame(cs=css[i], sp=sps[j], R2= mean(subset(sub, sp==sps[j])$R2), r=mean(subset(sub, sp==sps[j])$r))
      out2 <- rbind(out2, tem)
    }
  }
  
  test <- t.test(out1$R2, out2$R2, alternative ="greater")
  print(test)
  #return(rbind(out1, out2[, -1]))
}
