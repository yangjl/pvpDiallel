### Jinliang Yang
### 9/24/2015

#####
source("~/Documents/Github/zmSNPtools/Rcodes/rescale.R")
ob <- load("largedata/lcache/k_gerp.RData")

geno <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")
geno <- geno[, 1:5]

for(i in c(6,1:10)){
  kval <- read.csv(paste0("largedata/lcache/kval_perse_", i, "x.csv"))
  dat <- merge(kval, geno, by.x="snpid", by.y="marker")
  dat$Effect_A <- -dat$Effect_A
  dat$Effect_D <- -dat$Effect_D
  plot_k_gerp(dat, outfile=paste0("largedata/lgraphs/gerp_k", i, "x_others.pdf"))
}












##############################################
library(wesanderson)
library(ggplot2)
source("~/Documents/Github/zmSNPtools/Rcodes/multiplot.R")

plot_k_gerp <- function(dat, outfile="largedata/lgraphs/gerp_k7x_others.pdf"){
  med2 <- data.frame(trait=tolower(c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW")), 
                     phph=c(-0.24725, -0.08345, -0.10605,  0.29005,  1.24175,  0.25460, -0.00955 ))
  med2 <- med2[order(med2$phph),]
  
  #cols <- wes_palette(7, name = "Zissou", type = "continuous")
  cols <- c("#f6546a", "#daa520", "#00ff00", "#66cdaa", "#3b5998", "#8a2be2", "#ff00ff")
  theme_set(theme_grey(base_size = 18)) 
  
  p1 <- ggplot(dat, aes(x=RS, y=Effect_A, colour=factor(trait, levels=med2$trait))) +
    labs(colour="Traits") +
    theme_bw() +
    xlab("GERP Score") +
    ylab("Additive Effect") +
    #  (by default includes 95% confidence region)
    #scale_fill_manual(values=c("#008080", "#003366", "#40e0d0", "#ffa500", "#f6546a", "#ff00ff", "#800000")) +
    #http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
    geom_smooth(method="gam", size=1.3) +
    guides(colour=FALSE) +
    theme(axis.text.y = element_text(angle = 90, hjust = 1)) +
    scale_color_manual(values=cols)
  
  
  p2 <- ggplot(dat, aes(x=RS, y=Effect_D, colour=factor(trait, levels=med2$trait))) +
    labs(colour="Traits") +
    theme_bw() +
    xlab("GERP Score") +
    ylab("Dominant Effect") +
    scale_colour_manual(values=cols) +
    guides(colour=FALSE) +
    theme(axis.text.y = element_text(angle = 90, hjust = 1)) +
    geom_smooth(method="gam", size=1.3)   # Add linear regression line 
  
  p3 <- ggplot(dat, aes(x=RS, y=k, colour=factor(trait, levels=med2$trait))) +
    #geom_point(shape=1) +    # Use hollow circles
    labs(colour="Traits") +
    theme_bw() +
    xlab("GERP Score") +
    ylab("Degree of Domiance (k)") +
    scale_colour_manual(values=cols) +
    guides(colour=FALSE) +
    theme(axis.text.y = element_text(angle = 90, hjust = 1)) +
    geom_smooth(method="gam", size=1.3)   # Add linear regression line 
  
  p4 <- ggplot(dat, aes(x=RS, y=h2_mrk_A, colour=factor(trait, levels=med2$trait))) +
    #geom_point(shape=1) +    # Use hollow circles
    labs(colour="Traits") +
    theme_bw() +
    xlab("GERP Score") +
    ylab("Additive Variance") +
    scale_colour_manual(values=cols) +
    guides(colour=FALSE) +
    theme(axis.text.y = element_text(angle = 90, hjust = 1)) +
    geom_smooth(method="gam", size=1.3) 
  
  p5 <- ggplot(dat, aes(x=RS, y=h2_mrk_D, colour=factor(trait, levels=med2$trait))) +
    #geom_point(shape=1) +    # Use hollow circles
    labs(colour="Traits") +
    theme_bw() +
    xlab("GERP Score") +
    ylab("Dominant Variance") +
    scale_colour_manual(values=cols) +
    guides(colour=FALSE) +
    theme(axis.text.y = element_text(angle = 90, hjust = 1)) +
    geom_smooth(method="gam", size=1.3) 
  
  p6 <- ggplot(dat, aes(x=RS, y=H2_mrk, colour=factor(trait, levels=med2$trait))) +
    #geom_point(shape=1) +    # Use hollow circles
    labs(colour="Traits") +
    theme_bw() +
    xlab("GERP Score") +
    ylab("Total Variance") +
    guides(colour=FALSE) +
    scale_colour_manual(values=cols) +
    theme(axis.text.y = element_text(angle = 90, hjust = 1)) +
    geom_smooth(method="gam", size=1.3) 
  
  #multiplot(p1, p4, p2, p5, p3, p6, cols=3)
  pdf(outfile, width=13, height=8)
  multiplot(p1, p4, p2, p5, p3, p6, cols=3)
  dev.off()
}








###########################
le <- ggplot(dat, aes(x=RS, y=H2_mrk, colour=factor(trait, levels=med2$trait))) +
  #geom_point(shape=1) +    # Use hollow circles
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Total Variance") +
  #guides(colour=FALSE) +
  scale_colour_manual(values=cols) +
  theme(axis.text.y = element_text(angle = 90, hjust = 1)) +
  geom_smooth(method="gam", size=1.3) 

pdf("graphs/Fig4_k_others_legend.pdf", width=4, height=4)
le
dev.off()




