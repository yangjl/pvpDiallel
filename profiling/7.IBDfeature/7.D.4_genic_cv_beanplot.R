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
pval <- read.csv("cache/pval_genic.csv")
subset(pval, pval <= 0.05)

idx <- grep("MPH", pval$file)
pval2 <- pval[-idx, ]

pval2$FDR <- p.adjust(pval2$pval, method="fdr" )
subset(pval2, FDR < 0.05)


