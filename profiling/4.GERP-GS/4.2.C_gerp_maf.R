### Jinliang Yang
### 11/23/2014
### purpose: find the relationship of RS with SNP frq

#load data in the local machine for plotting
ob <- load("largedata/lcache/snpnzRS.RData")

snpnz$MAF2 <- as.factor(round(snpnz$MAF, 2))

snptab <- ddply(snpnz, .(MAF2), summarise,
                rsmean= mean(RS),
                rssd = sd(RS))

plot(snptab$MAF2, snptab$rsmean)
cor.test(as.numeric(as.character(snptab$MAF2)), snptab$rsmean)
##############################################################

plot(snpnz$MAF, snpnz$RS)
?ddply()


hist(snpnz$RS, breaks=50, main="Distribution of GERP", xlab="GERP score")
abline(v=0, lty=2, col="grey", lwd=3)
nrow(subset(snpnz, RS>2))
nrow(subset(snpnz, RS<0))




### GERP data
ob <- load("largedata/lcache/4.1.A_gerpdis.RData")
chrall <- rbind(chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10)

chrall <- data.table(chrall)

### GERP>0 sites
chrall0 <- subset(chrall, RS > 0) # 86006888        4
chrall0[, snpid:=paste0(chr, "_", pos)]

### merging by setkey
setkey(snp11m, snpid)
setkey(chrall, snpid)

snpgs <- snp11m[chrall, roll=T]
system.time(new.T <- zea.grin.T[amesWyears.T, roll =T])


