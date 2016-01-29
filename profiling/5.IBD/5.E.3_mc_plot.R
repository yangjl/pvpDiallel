### Jinliang Yang
### April 29th, 2015
### plot the variance explained by genome-wide markers

mc1 <- read.csv("cache/model_comparison_perse.csv")
mc2 <- read.csv("cache/model_comparison_bph.csv")



library(ggplot2)
source("~/Documents/Github/zmSNPtools/Rcodes/multiplot.R")
library(reshape2)
res1 <- melt(mc1, id.vars = c("trait", "mode"))
res2 <- melt(mc2, id.vars = c("trait", "mode"))


med2 <- data.frame(trait=c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW"), 
                   phph=c(-0.24725, -0.08345, -0.10605,  0.29005,  1.24175,  0.25460, -0.00955 ))
med2$traitlw <- tolower(med2$trait)
#bymed2 <- with(trait, reorder(trait, pBPHmax, median))
bymed2 <- med2[order(med2$phph),]

p1 <- ggplot(subset(res1, mode=="a2"), aes(x=factor(trait, levels=bymed2$trait), y= -log10(value) )) + 
  geom_point(aes(color = variable), size = 5) +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Additive") + theme_bw() +
  labs(fill="Models") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p2 <- ggplot(subset(res1, mode=="d2"), aes(x=factor(trait, levels=bymed2$trait), y= -log10(value) )) + 
  geom_point(aes(color = variable), size = 5) +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Dominance") + theme_bw() +
  labs(fill="Models") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p3 <- ggplot(subset(res1, mode=="h2"), aes(x=factor(trait, levels=bymed2$trait), y= -log10(value) )) + 
  geom_point(aes(color = variable), size = 5) +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Incomplete Dominance") + theme_bw() +
  labs(fill="Models") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p4 <- ggplot(subset(res2, mode=="a2"), aes(x=factor(trait, levels=bymed2$trait), y= -log10(value) )) + 
  geom_point(aes(color = variable), size = 5) +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Additive") + theme_bw() +
  labs(fill="Models") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p5 <- ggplot(subset(res2, mode=="d2"), aes(x=factor(trait, levels=bymed2$trait), y= -log10(value) )) + 
  geom_point(aes(color = variable), size = 5) +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Dominance") + theme_bw() +
  labs(fill="Models") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p6 <- ggplot(subset(res2, mode=="h2"), aes(x=factor(trait, levels=bymed2$trait), y= -log10(value) )) + 
  geom_point(aes(color = variable), size = 5) +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Incomplete Dominance") + theme_bw() +
  labs(fill="Models") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))




########
pdf("graphs/Fig_post_var.pdf", width=13, height=5)
multiplot(p1, p2, p3, cols=3)
dev.off()


