# Jinliang Yang
# July 18th, 2014
# purpose: plot of heterosis

ob <- load("~/Documents/Heterosis_GWAS/HGWAS_proj/cache/heterosis_traits.RData")

### changed to dialle only
krn <- subset(krn, pop == "Diallel")
cd <- subset(cd, pop == "Diallel")
cl <- subset(cl, pop == "Diallel")
cw <- subset(cw, pop == "Diallel")
akw <- subset(akw, pop == "Diallel")
kc <- subset(kc, pop == "Diallel")
tkw <- subset(tkw, pop == "Diallel")

ph <- c(mean(krn$pHPH), mean(cd$pHPH), mean(akw$pHPH), mean(cl$pHPH), mean(cw$pHPH),
        mean(kc$pHPH), mean(tkw$pHPH))
pm <- c(mean(krn$pMPH), mean(cd$pMPH), mean(akw$pMPH), mean(cl$pMPH), mean(cw$pMPH),
        mean(kc$pMPH), mean(tkw$pMPH))

htable <- data.frame(trait=c("KRN", "CD", "AKW", "CL", "CW", "KC", "TKW"),
                     pHPH=ph, pMPH=pm)
htable <- htable[order(htable$pHPH),]
### mean of the everything
htable$pHPH <- round(htable$pHPH*100, 1)
htable$pMPH <- round(htable$pMPH*100, 1)


pdf("~/Documents/Heterosis_GWAS/HGWAS_proj/graphs/F1_doh.pdf", width=5, height=5)
plot(1:7, htable$pMPH, bty="n", xaxt="n", xlab="", ylim=c(0, 500),
     ylab="Degress of Heterosis", pch=22, cex=1, bg="lightgrey")
points(1:7, htable$pHPH, pch=23, cex=1, bg="lightgrey")
axis(side=1, at=1:7, labels=htable$trait)
legend("topleft", legend =c("MPH", "HPH"), pch=c(22,23), bty="n")
dev.off()

