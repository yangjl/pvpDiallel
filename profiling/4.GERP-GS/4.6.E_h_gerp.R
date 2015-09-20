### Jinliang Yang
### plot the relationship of gerp and h


get_k <- function(files){
  
  geno <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")
  geno <- geno[, 1:5]
  
  output <- list()
  for(i in 1:length(files)){
    h1 <- read.table(files[i], header=TRUE)
    names(h1) <- c("snpid","chr","pos","Effect_A","Effect_D","Effect_A2","Effect_D2","h2_mrk_A", 
                   "h2_mrk_D","H2_mrk","h2_mrk_A_p","h2_mrk_D_p","H2_mrk_p","log10_h2_mrk_A","log10_h2_mrk_D","log10_H2_mrk")
    
    h1$k <- h1$Effect_D/h1$Effect_A
    
    trait <- gsub(".*/|_.*", "", files[i])
    output[[trait]] <- merge(geno[, 1:3], h1,  by.y="snpid", by.x="marker")
    gh[[i]] <- 
    message(sprintf("###>>> processing file: [ %s ]", files[i]))
  }
  return(output)
}

cor_k_others <- function(k, RScutoff=0){
  out <- data.frame()
  for(i in 1:7){
    k[[i]] <- subset(k[[i]], RS > RScutoff)
    tst1 <- cor.test(k[[i]]$Effect_A, k[[i]]$RS)
    tst2 <- cor.test(k[[i]]$Effect_D, k[[i]]$RS)
    tst3 <- cor.test(k[[i]]$k, k[[i]]$RS)
    tst4 <- cor.test(k[[i]]$h2_mrk_A, k[[i]]$RS)
    tst5 <- cor.test(k[[i]]$h2_mrk_D, k[[i]]$RS)
    tst6 <- cor.test(k[[i]]$H2_mrk, k[[i]]$RS)
    
    
    out1 <- data.frame(trait=names(k)[i], test="A_RS", p=tst1$p.value, cor=tst1$estimate)
    out2 <- data.frame(trait=names(k)[i], test="D_RS", p=tst2$p.value, cor=tst2$estimate)
    out3 <- data.frame(trait=names(k)[i], test="K_RS", p=tst3$p.value, cor=tst3$estimate)
    out4 <- data.frame(trait=names(k)[i], test="h2_A_RS", p=tst4$p.value, cor=tst4$estimate)
    out5 <- data.frame(trait=names(k)[i], test="h2_D_RS", p=tst5$p.value, cor=tst5$estimate)
    out6 <- data.frame(trait=names(k)[i], test="h2_RS", p=tst6$p.value, cor=tst6$estimate)
    
    out <- rbind(out, out1, out2, out3, out4, out5, out6)
    #print()
  }
  return(out)
}

####
files <- list.files(path="largedata/snpeff", pattern="snpe$", full.names=TRUE)
k <- get_k(files)

kcor0 <- cor_k_others(k, RScutoff=0)
kcor1 <- cor_k_others(k, RScutoff=1)
kcor2 <- cor_k_others(k, RScutoff=2)
# RS bigger not better

save(file="largedata/lcache/k_gerp.RData", list=c("k", "kcor0", "kcor1", "kcor2"))


#####
source("~/Documents/Github/zmSNPtools/Rcodes/rescale.R")
ob <- load("largedata/lcache/k_gerp.RData")
dat <- data.frame()
do_rescale = FALSE
for(i in 1:length(k)){
  ### remove non-informative sites
  k[[i]] <- subset(k[[i]], Effect_A !=0)
  k[[i]]$Effect_A <- k[[i]]$Effect_A + 0.02
  if(sum(k[[i]]$k > 1) > 0){
    k[[i]][k[[i]]$k > 1, ]$k <- rescale(k[[i]][k[[i]]$k > 1, ]$k, c(1, 2))
  }
  if(sum(k[[i]]$k < -1) > 0){
    k[[i]][k[[i]]$k < -1, ]$k <- rescale(k[[i]][k[[i]]$k < -1, ]$k, c(-2, -1))
  }
  
  if(do_rescale == TRUE){
    k[[i]]$Effect_A <- rescale(k[[i]]$Effect_A, c(0,1))
    k[[i]]$Effect_D <- rescale(k[[i]]$Effect_D, c(0,1))

    k[[i]]$h2_mrk_A <- rescale(k[[i]]$h2_mrk_A, c(0,1))
    k[[i]]$h2_mrk_D <- rescale(k[[i]]$h2_mrk_D, c(0,1))
    k[[i]]$H2_mrk <- rescale(k[[i]]$H2_mrk, c(0,1))  
  }
  
  k[[i]]$trait <- names(k)[i]
  dat <- rbind(dat, k[[i]])
}
dat$trait <- toupper(dat$trait)


library(wesanderson)
med2 <- data.frame(trait=c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW"), 
                   phph=c(-0.24725, -0.08345, -0.10605,  0.29005,  1.24175,  0.25460, -0.00955 ))
med2 <- med2[order(med2$phph),]

cols <- wes_palette(7, name = "Zissou", type = "continuous")
theme_set(theme_grey(base_size = 18)) 

p1 <- ggplot(dat, aes(x=RS, y=Effect_A, colour=factor(trait, levels=med2$trait))) +
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Additive Effect") +
  #  (by default includes 95% confidence region)
  #scale_fill_manual(values=c("#008080", "#003366", "#40e0d0", "#ffa500", "#f6546a", "#ff00ff", "#800000")) +
  #http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
  geom_smooth(method=lm, size=1.3) +
  scale_color_manual(values=cols)
 

p2 <- ggplot(dat, aes(x=RS, y=Effect_D, colour=factor(trait, levels=med2$trait))) +
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Dominant Effect") +
  scale_colour_manual(values=cols) +
  geom_smooth(method=lm, size=1.3)   # Add linear regression line 

p3 <- ggplot(dat, aes(x=RS, y=k, colour=factor(trait, levels=med2$trait))) +
  #geom_point(shape=1) +    # Use hollow circles
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Degree of Domiance (k)") +
  scale_colour_manual(values=cols) +
  geom_smooth(method=lm, size=1.3)   # Add linear regression line 

p4 <- ggplot(dat, aes(x=RS, y=h2_mrk_A, colour=factor(trait, levels=med2$trait))) +
  #geom_point(shape=1) +    # Use hollow circles
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Additive Variance") +
  scale_colour_manual(values=cols) +
  geom_smooth(method=lm, size=1.3) 

p5 <- ggplot(dat, aes(x=RS, y=h2_mrk_D, colour=factor(trait, levels=med2$trait))) +
  #geom_point(shape=1) +    # Use hollow circles
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Dominant Variance") +
  scale_colour_manual(values=cols) +
  geom_smooth(method=lm, size=1.3) 
p6 <- ggplot(dat, aes(x=RS, y=H2_mrk, colour=factor(trait, levels=med2$trait))) +
  #geom_point(shape=1) +    # Use hollow circles
  labs(colour="Traits") +
  theme_bw() +
  xlab("GERP Score") +
  ylab("Total Variance") +
  scale_colour_manual(values=cols) +
  geom_smooth(method=lm, size=1.3) 

multiplot(p1, p4, p2, p5, p3, p6, cols=3)



pdf("graphs/Fig4_k_others.pdf", width=17, height=8)
multiplot(p1, p4, p2, p5, p3, p6, cols=3)
dev.off()






