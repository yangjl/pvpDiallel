### Jinliang Yang
### 9/24/2015

#####
source("~/Documents/Github/zmSNPtools/Rcodes/rescale.R")
ob <- load("largedata/lcache/k_gerp.RData")

concat_k <- function(k, do_rescale = FALSE){
  dat <- data.frame()
  for(i in 1:length(k)){
    ### remove non-informative sites
    
    onek <- k[[i]]
    onek <- subset(onek, Effect_A !=0)
    onek$Effect_A <- onek$Effect_A + 0.02
    if(sum(onek$k > 1) > 0){
      if(sum(onek$k > 10) > 0){
        onek[onek$k > 10, ]$k <- 2
      }
      onek[onek$k > 1, ]$k <- rescale(onek[onek$k > 1, ]$k, c(1, 2))
    }
    if(sum(onek$k < -1) > 0){
      if(sum(onek$k < -10) > 0){
        onek[onek$k < -10, ]$k <- -2
      }
      onek[onek$k < -1, ]$k <- rescale(onek[onek$k < -1, ]$k, c(-2, -1))
    }
    
    if(do_rescale == TRUE){
      onek$Effect_A <- rescale(onek$Effect_A, c(0,1))
      onek$Effect_D <- rescale(onek$Effect_D, c(0,1))
      
      onek$h2_mrk_A <- rescale(onek$h2_mrk_A, c(0,1))
      onek$h2_mrk_D <- rescale(onek$h2_mrk_D, c(0,1))
      onek$H2_mrk <- rescale(onek$H2_mrk, c(0,1))  
    }
    
    onek$trait <- names(k)[i]
    dat <- rbind(dat, onek)
  }
  dat$trait <- toupper(dat$trait)
  return(dat) 
}


dat <- concat_k(k, do_rescale = FALSE)







##############################################
library(wesanderson)
library(ggplot2, lib="~/bin/Rlib/")
source("~/Documents/Github/zmSNPtools/Rcodes/multiplot.R")

med2 <- data.frame(trait=c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW"), 
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



pdf("graphs/Fig4_k_others.pdf", width=13, height=8)
multiplot(p1, p4, p2, p5, p3, p6, cols=3)
dev.off()

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




