### Jinliang Yang
### beanplot
### updated: April 27th, 2015

#http://www.jstatsoft.org/v28/c01/paper
#########################################
##>>>>>
library("beanplot")
add_bean_plot <- function(resdf = HPH, mymode="a2", ...){
  
  res0 <- resdf
  
  res0$cs <- gsub("cs0", "real", res0$cs)
  res0$cs <- gsub("cs.*", "cs", res0$cs)
  res1 <- subset(res0, mode == mymode)
  par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
  
  res1$cs <- factor(res1$cs, levels = c("real", "cs"))
  res1$trait <- toupper(res1$trait)
  res1$trait <- factor(res1$trait, levels = toupper(c("asi", "dtp", "dts", "eht", "gy", "pht", "tw")) )
  beanplot(r ~ cs + trait, data = res1, ll = 0.04, cex=1.5,
           side = "both", border = NA, col = list(c("blue", "red"), c("grey", "black")) , ...)
  #legend("bottomleft", fill = c("black", "grey"),
  #       legend = c("Group 2", "Group 1"))
  
}

##### get the data frames
bph_max <- read.csv("cache/genic_BPHmax.csv")
bph_max <- subset(bph_max, trait != "asi")
bph_min <- read.csv("cache/genic_BPHmin.csv")

BPH <- rbind(bph_max, bph_min)
mean(subset(BPH, cs == "cs0" & mode == "a2")$r) #[1] 0.56
mean(subset(BPH, cs == "cs0" & mode == "d2")$r) #[1] 0.58


pbph_max <- read.csv("cache/genic_pBPHmax.csv")
pbph_max <- subset(pbph_max, trait != "asi")
pbph_min <- read.csv("cache/gerpall_pBPHmin.csv")
pbph_min <- pbph_min[, names(pbph_max)]
pBPH <- rbind(pbph_max, pbph_min)
mean(subset(pBPH, cs == "cs0" & mode == "a2")$r) #[1] 0.41
mean(subset(pBPH, cs == "cs0" & mode == "d2")$r) #[1] 0.31


perse <- read.csv("cache/genic_perse.csv")
mean(subset(perse, cs == "cs0" & mode == "a2")$r) #[1] 0.84
mean(subset(perse, cs == "cs0" & mode == "d2")$r) #[1] 0.72

##################################################################################################################

pdf("manuscript/Figure_Table/S_genicsnp.pdf", width=8, height=10)
par(mfrow=c(3,2))
add_bean_plot(resdf = perse, mymode="a2", 
              main = "Trait per se with additive model", ylab = "CV Accuracy (r)")
add_bean_plot(resdf = perse, mymode="d2", 
              main = "Trait per se with dominant model", ylab = "CV Accuracy (r)")

add_bean_plot(resdf = BPH, mymode="a2", 
              main = "BPH with additive model", ylab = "CV Accuracy (r)")
add_bean_plot(resdf = BPH, mymode="d2", 
              main = "BPH with dominant model", ylab = "CV Accuracy (r)")

add_bean_plot(resdf = pHPH, mymode="a2", 
              main = "pBPH with additive model", ylab = "CV Accuracy (r)")
add_bean_plot(resdf = pHPH, mymode="d2", 
              main = "pBPH with dominant model", ylab = "CV Accuracy (r)")

dev.off()


#####
pval <- read.csv("cache/pval_gerpall.csv")
subset(pval, pval <= 0.05)

idx <- grep("MPH", pval$file)
pval2 <- pval[-idx, ]

pval2$FDR <- p.adjust(pval2$pval, method="fdr" )
subset(pval2, FDR < 0.05)



res0 <- read.csv("cache/cv_genic_BPHmax.csv")
res0$type <- "realgenic"
res0$mode <- gsub("^1", "", res0$mode)
res0 <- res0[, c("file", "R2", "r", "trait", "type", "mode", "sp", "cv")]

res_cs <- read.csv("cache/genic_cv_cs_pHPH.csv")
names(res_cs)[5] <- "type"

res0 <- res_cs
res0$type <- as.character(res0$type)
res0[res0$type %in% "cs0",]$type <- "realgenic"
res0[res0$type != "realgenic", ]$type <- "cs"


#res0 <- rbind(res0, res_cs)

table(subset(res0, type=="real")$trait)
table(subset(res0, type=="random")$trait)


library("beanplot")


res1 <- subset(res0, type=="realgenic" & mode %in% c("a2", "d2"))
#par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
res1$mode <- factor(res1$mode, levels = c("a2", "d2"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(r ~ mode + trait, data = res1, ll = 0.04, cex=1.5,  ylim=c(0, 1),
         main = "Dominant for BPHmax (Exon GERP >0 and GERP <0)", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
legend("bottomleft", fill = c("black", "grey"),
       legend = c("Group 2", "Group 1"))



res1 <- subset(res0, mode == "a2")
#par(mfrow=c(2,2))
res1$type <- factor(res1$type, levels = c("realgenic", "cs"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5,  overallline = "median",
         main = "Additive for pHPH", ylab = "cross-validation accuracy", side = "both",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("blue", "grey"),
#       legend = c("real data", "permutation"))


res1 <- subset(res0, mode == "d2")
#par(lend = 1)
res1$type <- factor(res1$type, levels = c("realgenic", "cs"))
res1$trait <- factor(res1$trait, levels = c("tw", "dtp", "dts", "pht", "eht", "asi", "gy"))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04, cex=1.5, 
         main = "Dominant for pHPH", side = "both", ylab = "cross-validation accuracy",
         border = NA, col = list(c("blue", "red"), c("grey", "black")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))










runttest <- function(res0=res0, mymode="d2", mytrait=myt[1]){
  res <- data.frame()
  for(i in 1:length(mytrait)){
    test <- t.test(subset(res0, type=="realgenic" & trait== mytrait[i] & mode == mymode)$r, 
                   subset(res0, type=="cs" & trait == mytrait[i] & mode == mymode)$r, alternative ="greater")
    tem <- data.frame(trait=mytrait[i], pval=test$p.value)
    res <- rbind(res, tem)
  }
  return(res)
}

#####
myt <- c("tw", "dtp", "dts", "pht", "eht", "asi", "gy")
runttest(res0=res0, mymode="d2", mytrait=myt[c(2:3,5:7)])







