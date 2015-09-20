### Jinliang Yang
### Sept 19th, 2015


k <- read.csv("data/num_effect.csv")

out <- k[, 1:2]
out$k <- "k1"
names(out)[2] <- "num"
for(i in 3:5){
  tem <- k[, c(1,i)]
  tem$k <- names(k)[i]
  names(tem)[2] <- "num"
  out <- rbind(out, tem)
}

out$file <- gsub(".*/|_.*", "", out$file)
out$file <- toupper(out$file)

a2 <- k[, c(1, 6)]
d2 <- k[, c(1, 7)]
names(a2)[2] <- "h2"
names(d2)[2] <- "h2"
a2$eff <- "add"
d2$eff <- "dom"
out2 <- rbind(a2, d2)
out2$file <- gsub(".*/|_.*", "", out2$file)
out2$file <- toupper(out2$file)


############
library("ggplot2", lib="~/bin/Rlib/")
library("plyr")



########
theme_set(theme_grey(base_size = 18), theme_bw()) 
p1 <- ggplot(out, aes(x=factor(file, levels=unique(toupper(med2[order(med2$phph),]$trait))), y=num, 
                      fill=factor(k, labels=c("k > 1","0 < k <= 1", "-1 <= k <= 0", "k <- 1")) )) + 
  geom_bar(position=position_dodge(), stat="identity") +
  xlab("") +
  ylab("Number of Loci") +
  ggtitle("") +
  labs(fill="k (a/d))") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

p2 <- ggplot(out2, aes(x=factor(file, levels=unique(toupper(med2[order(med2$phph),]$trait))), y=h2, 
                       fill=factor(eff, labels=c("Additive", "Dominant")))) + 
  geom_bar(position=position_dodge(), stat="identity") +
  xlab("") +
  ylab("Accumulative Variance") +
  ggtitle("") +
  labs(fill="Effect") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

pdf("graphs/Fig3_eff_var.pdf", width=13, height=5)
multiplot(p1, p2, cols=2)
dev.off()


##############
med2 <- data.frame(trait=c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW"), 
                   phph=c(-0.24725, -0.08345, -0.10605,  0.29005,  1.24175,  0.25460, -0.00955 ))

med2$trait <- tolower(med2$trait)
test <- merge(med2, subset(out2, eff=="dom"), by.x="trait", by.y="file")

bymed2 <- with(trait, reorder(trait, pBPHmax, median))

