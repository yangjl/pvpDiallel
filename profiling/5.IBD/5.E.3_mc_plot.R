### Jinliang Yang
### April 29th, 2015
### plot the variance explained by genome-wide markers

res1 <- read.csv("cache/gerpsnp_wholeset_perse.csv")
res2 <- read.csv("cache/gerpsnp_wholeset_bph.csv")


library(ggplot2)
source("~/Documents/Github/zmSNPtools/Rcodes/multiplot.R")

med2 <- data.frame(trait=tolower(c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW")), 
                   phph=c(-0.24725, -0.08345, -0.10605,  0.29005,  1.24175,  0.25460, -0.00955 ))
med2$traitlw <- tolower(med2$trait)
#bymed2 <- with(trait, reorder(trait, pBPHmax, median))
bymed2 <- med2[order(med2$phph),]

p1 <- ggplot(res1, aes(x=factor(trait, levels=bymed2$trait), y=h2, 
                       fill=factor(mode, levels=c("a2", "d2", "h2"), labels=c("A", "D", "k")))) + 
  geom_bar(position=position_dodge(), stat="identity") +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Trait per se") + theme_bw() +
  labs(fill="Effect") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p2 <- ggplot(res2, aes(x=factor(trait, levels=bymed2$trait), y=h2, 
                       fill=factor(mode, levels=c("a2", "d2", "h2"), labels=c("A", "D", "k")))) + 
  geom_bar(position=position_dodge(), stat="identity") +
  xlab("") +
  ylab("Posterior Variance Explained") +
  ggtitle("Heterosis") + theme_bw() +
  labs(fill="Effect") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))


########
pdf("graphs/Fig_post_var.pdf", width=13, height=5)
multiplot(p1, p2, cols=2)
dev.off()

multiplot(p1, p2, cols=2)

