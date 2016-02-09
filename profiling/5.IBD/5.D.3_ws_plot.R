### Jinliang Yang
### jan 29th, 2016

res1 <- read.csv("cache/gerpsnp_wholeset_perse.csv")
res2 <- read.csv("cache/gerpsnp_wholeset_bph.csv")


library(ggplot2)
source("~/Documents/Github/zmSNPtools/Rcodes/multiplot.R")

h <- read.csv("cache/loh_pBPHmax_median.csv")
med2 <- h
med2$traitlw <- tolower(med2$trait)
#bymed2 <- with(trait, reorder(trait, pBPHmax, median))
bymed2 <- med2[order(med2$h),]


p1 <- ggplot(res1, aes(x=factor(trait, levels=bymed2$traitlw), y=h2,
                       fill=factor(mode, levels=c("a2", "d2", "h2"), labels=c("A", "D", "k")))) + 
  geom_bar(position=position_dodge(), stat="identity") +
  xlab("") +
  ylim(c(0,1)) +
  ylab("Posterior Variance Explained") +
  ggtitle("Trait per se") + theme_bw() +
  labs(fill="Effect") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p2 <- ggplot(res2, aes(x=factor(trait, levels=bymed2$traitlw), y=h2, 
                       fill=factor(mode, levels=c("a2", "d2", "h2"), labels=c("A", "D", "k")))) + 
  geom_bar(position=position_dodge(), stat="identity") +
  xlab("") +
  ylim(c(0,1)) +
  ylab("Posterior Variance Explained") +
  ggtitle("Heterosis") + theme_bw() +
  labs(fill="Effect") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))


########
pdf("graphs/Fig_post_var.pdf", width=12, height=5)
multiplot(p1, p2, cols=2)
dev.off()

multiplot(p1, p2, cols=2)

########
pdf("graphs/Fig_post_var_v1.pdf", width=6, height=5)
p2
dev.off()

