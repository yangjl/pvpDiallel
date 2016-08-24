### Jinliang Yang
### deterimine the deleterious alleles


mm <- read.csv("largedata/Alignment/conserved_alleles_AGPv2.csv")
geno <- read.csv("largedata/GERPv2/gerpsnp_506898.csv")
geno$marker <- as.character(geno$marker)

mm$major <- as.character(mm$major)
mm$Zea <- as.character(mm$Zea)
mm$snpid <- as.character(mm$snpid)

mjr <- subset(mm, major == Zea)
#438644      6

mnr <- subset(mm, major != Zea)
#68195     6

mean(subset(geno, marker %in% mjr$snpid)[, "RS"])
mean(subset(geno, marker %in% mnr$snpid)[, "RS"])

geno$frq <- "major"
geno[geno$marker %in% mnr$snpid,]$frq <- "minor"

pdf(file="graphs/tem_bplot.pdf", width=5, height = 5)
boxplot(RS ~ frq, data=geno, xlab="B73 in Phylogenetic Tree", ylab="Avg. GERP")
dev.off()
