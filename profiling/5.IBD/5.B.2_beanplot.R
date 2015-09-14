### Jinliang Yang
### beanplot

#http://www.jstatsoft.org/v28/c01/paper

res0 <- read.csv("cache/gerpall_h_g2_perse_gy.csv")

#res0 <- subset(res1, type == "random" & cv != "cv1")

table(subset(res0, type=="real")$trait)
table(subset(res0, type=="random")$trait)


library("beanplot")



res1 <- subset(res0, mode == "a2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$type <- factor(res1$type, levels = c("real", "random"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5,
         main = "Additive GERP Score", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))


res1 <- subset(res0, mode == "d2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$type <- factor(res1$type, levels = c("real", "random"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5,
         main = "Dominant GERP Score", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))

res1 <- subset(res0, mode == "h2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))

out$trait <- factor(out$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))

out$trait <- "gy"
out$type <- factor(out$type, levels = c("real", "cs"))
beanplot(R2 ~ type + trait, data = out, ll = 0.04, cex=1.5,
         main = "h GERP Score", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))








myt <- c("tw", "dtp", "dts", "pht", "eht", "asi", "gy")
myt <- "gy"
runttest <- function(res0, mymode="d2", mytrait=myt[1]){
  
  real <- subset(res0, type=="real" & trait== mytrait & mode == mymode)
  rand <- subset(res0, type=="random" & trait == mytrait & mode == mymode)
  
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
  
  out1$type <- "real"
  out2$type <- "cs"
  
  test <- t.test(out1$R2, out2$R2, alternative ="greater")
  print(test)
  return(rbind(out1, out2[, -1]))
}
runttest(mymode="a2", mytrait=myt)
runttest(mymode="d2", mytrait=myt)
out <- runttest(res0, mymode="h2", mytrait=myt)
out <- runttest(res0, mymode="d2", mytrait=myt)
out <- runttest(res0, mymode="a2", mytrait=myt)

for(i in 1:7){
  runttest(mymode="d1", mytrait=myt[i])
}

quantile(subset(res0, type=="random" & trait == mytrait & mode == mymode)$R2, mean(subset(res0, type=="real" & trait== mytrait & mode == mymode)$R2))




